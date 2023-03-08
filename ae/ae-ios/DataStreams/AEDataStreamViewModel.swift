//
//  AEDataStreamViewModel.swift
//  ae
//
//  Created by Blaine Rothrock on 4/27/22.
//

import Foundation
import Combine
import SwiftUI
import FlexiBLE
import GRDB

@MainActor class AEDataStreamViewModel: ObservableObject {
    
    var dataStream: FXBDataStream
    
    enum State {
        case loading
        case connected
        case error(msg: String)
    }
    
    @Published var state: State = .loading
    
    @Published var recordCount: Int? = nil
    @Published var frequency: Double? = nil
    @Published var reliability: Double? = nil
    @Published var configVMs: [ConfigViewModel] = []
    @Published var isOn: Bool
    
    var deviceVM: FXBDeviceViewModel?
    
    var hasConfigurations: Bool {
        return !dataStream.configValues.isEmpty
    }
    var hasVariableFrequency: Bool {
        return self.configVMs.first(where: { $0.config.name == "desired_frequency" }) != nil
    }
    
    
    private var observers = Set<AnyCancellable>()
    private var sensorStateConfig: ConfigViewModel?
    private var deviceName: String
    
    var estimatedReload: Double {
        return 0
    }
    
    init(_ dataStream: FXBDataStream, deviceName: String) {
        self.state = .loading
        self.dataStream = dataStream
        self.deviceName = deviceName
        self.isOn = false
        
        self.setupDevice()
    }
    
    private func setupDevice() {
        if let device = fxb.conn.fxbConnectedDevices.first(where: { $0.deviceName == deviceName }) {
            
            self.deviceVM = FXBDeviceViewModel(with: device)
            setInitialRecordCount()
            
        } else {
            self.state = .error(msg: "Device not connected")
        }
        
        configVMs = []
        sensorStateConfig = nil
        
        for config in dataStream.configValues {
            configVMs.append(ConfigViewModel(config: config))
        }
        
        if let stateConfig = configVMs.first(where: { $0.config.name == "sensor_state" }) {
            self.sensorStateConfig = stateConfig
        }
        
        Task {
            await fetchLatestConfig()
            DispatchQueue.main.async {
                self.state = .connected
            }
            
            self.$isOn.sink { newValue in
                if let selectedVal = self.sensorStateConfig?.selectedValue {
                    if (newValue ? "1" : "0") != selectedVal {
                        self.sensorStateConfig?.update(with: newValue ? "1" : "0")
                        self.updateConfigs()
                    }
                }
            }.store(in: &observers)
        }
    }
    
    private func setInitialRecordCount() {
        guard let deviceVM = deviceVM else  { return }
        Task {
            do {
                
                // FIXME: counting is too much with large data tables.
//                self.recordCount = try await FlexiBLE.shared.dbAccess?.timeseries.count(
//                    for: .dynamicData(name: dataStream.name),
//                    start: nil,
//                    end: Date.now,
//                    deviceName: deviceName,
//                    uploaded: nil
//                ) ?? 0
                
                deviceVM.device
                    .dataHandler(for: dataStream.name)?
                    .firehoseTS
                    .collect(Publishers.TimeGroupingStrategy.byTime(DispatchQueue.main, 1.0))
                    .sink(receiveValue: { [weak self] dates in
                        guard let self = self else { return }
                        
                        let dedupedDates = Array(Set(dates)).sorted(by: { $1 > $0 })
                        
                        withAnimation(.spring()) {
                            if self.recordCount != nil {
                                self.recordCount! += dedupedDates.count
                            }
                            self.frequency = self.frequency(from: dedupedDates)
                            if self.frequency != nil {
                                self.reliability = self.reliability(from: self.frequency!)
                            }
                        }
                        
                    })
                    .store(in: &self.observers)
            } catch {
                gLog.error("unable to detemine record count for \(self.dataStream.name)")
            }
        }
    }
    
    func fetchLatestConfig() async {
        guard !dataStream.configValues.isEmpty else {
            return
        }
        guard let persistedConfig = await FlexiBLE.shared.dbAccess?.dataStreamConfig.config(for: dataStream, deviceName: deviceName) else {
            return
        }
        
        for configDef in dataStream.configValues {
            if let vm = configVMs.first(where: { $0.config.name == configDef.name }) {
                if let colDef = persistedConfig.metadata.first(where: { $0.name == configDef.name }),
                    let value = persistedConfig.columns[colDef.cid].value as? String {
                    
                    if colDef.name == "sensor_state" {
                        isOn = (Int(value) ?? 0) > 0 ? true : false
                    }
                    
                    vm.update(with: value)
                    
                }
            }
        }
    }
    
    func loadDefaultConfigs() {
        fxb.conn.updateConfig(
            deviceName: deviceName,
            dataStream: dataStream
        )
        
        Task(priority: .userInitiated) { [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(DataStreamParamUpdateDelay.get() * 1_000_000))
            await self?.fetchLatestConfig()
        }
    }
    
    func updateConfigs() {
        var data: Data = Data()
        
        for vm in configVMs {
            if let _ = vm.config.range {
                data.append(vm.config.pack(value: String(Int(vm.selectedRangeValue))))
            } else {
                data.append(vm.config.pack(value: vm.selectedValue))
            }
        }
        
        fxb.conn.updateConfig(
            deviceName: deviceName,
            dataStream: dataStream,
            data: data
        )
        
        Task(priority: .userInitiated) { [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(DataStreamParamUpdateDelay.get() * 1_000_000))
            await self?.fetchLatestConfig()
        }
        
    }
    
    private func frequency(from dates: [Date]) -> Double {
        var diffs = [TimeInterval]()
        dates.enumerated().forEach { (i, date) in
            guard i > 0 else { return }
            diffs.append(dates[i-1].distance(to: dates[i]))
        }
        
        let meanTimeInterval = diffs.reduce(0.0, { $0 + $1 }) / Double(diffs.count)
        return 1.0/meanTimeInterval
    }
    
    private func reliability(from hz: Double) -> Double? {
        guard let freqConfig = self.configVMs.first(where: { $0.config.name == "desired_frequency" }),
            let desiredFreq = Double(freqConfig.selectedValue) else {
            return nil
        }
        
        return hz / desiredFreq
    }
}
