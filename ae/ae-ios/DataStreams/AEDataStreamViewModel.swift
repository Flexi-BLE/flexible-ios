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
    
    @Published var recordCount: Int = 0
    @Published var frequency: Double = 0
    @Published var reliability: Double? = 0
    @Published var configVMs: [ConfigViewModel] = []
    @Published var isOn: Bool
    
    var deviceVM: FXBDeviceViewModel?
    
    
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
        
        self.$isOn.sink { newValue in
            if (newValue ? "1" : "0") != self.sensorStateConfig?.selectedValue {
                self.sensorStateConfig?.update(with: newValue ? "1" : "0")
                self.updateConfigs()
            }
        }.store(in: &observers)
        
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
        
        if let stateConfig = configVMs.first(where: { $0.config.name == "sensor_state" }),
           let value = Double(stateConfig.selectedValue) {
            self.sensorStateConfig = stateConfig
            self.isOn = value > 0
        }
        
        Task {
            await fetchLatestConfig()
            DispatchQueue.main.async {
                self.state = .connected
            }
        }
    }
    
    private func setInitialRecordCount() {
        guard let deviceVM = deviceVM else  { return }
        Task { [weak self] in
            do {
                self?.recordCount = try await fxb.read.getTotalRecords(
                    for: "\(dataStream.name)_data",
                    from: nil,
                    to: Date.now,
                    deviceName: deviceVM.device.deviceName,
                    uploaded: nil
                )
            } catch {
                
            }
        }
        deviceVM.device
            .dataHandler(for: dataStream.name)?
            .firehoseTS
            .collect(Publishers.TimeGroupingStrategy.byTime(DispatchQueue.main, 1.0))
            .sink(receiveValue: { [weak self] dates in
                guard let self = self else { return }
                let dedupedDates = Array(Set(dates)).sorted(by: { $1 > $0 })
                self.recordCount += dates.count
                self.frequency = self.frequency(from: dedupedDates)
                self.reliability = self.reliability(from: self.frequency)
            })
            .store(in: &observers)
    }
    
    func fetchLatestConfig() async {
        guard
            let persistedConfig = await fxb.db.config(for: dataStream, deviceName: deviceName) else {
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
    
    func fetchData<T: AEDataValue & DatabaseValueConvertible>(
        limit: Int = 1000,
        offset: Int = 0,
        measurement: String?=nil
    ) async -> [T] {
        return await fxb.db.dataValues(
            for: dataStream.name,
            measurement: measurement ?? dataStream.dataValues[0].name,
            offset: offset,
            limit: limit
        )
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
