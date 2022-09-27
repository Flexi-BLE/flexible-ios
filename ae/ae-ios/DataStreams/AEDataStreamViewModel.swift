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
    @Published var recordCount: Int = 0
    @Published var frequency: Double = 0
    
    var deviceVM: FXBDeviceViewModel?
    
    @Published var isActive: Bool = false
    
    private var observers = Set<AnyCancellable>()
    
    @Published var configVMs: [ConfigViewModel] = []
    
    @Published var isOn: Bool {
        didSet {
            guard let _ = sensorStateConfig else {
//                isOn = false
                return
            }
            sensorStateConfig?.update(with: isOn ? "1" : "0")
            updateConfigs()
        }
    }
    
    private var sensorStateConfig: ConfigViewModel?
    
    private var deviceName: String
    
    var estimatedReload: Double {
        return 0
    }
    
    init(_ dataStream: FXBDataStream, deviceName: String) {
        self.dataStream = dataStream
        self.deviceName = deviceName
        self.isOn = false
        
        fxb.conn.fxbConnectedDevices
            .publisher
            .sink { _ in self.setupDevice() }
            .store(in: &observers)
    }
    
    private func setupDevice() {
        if let device = fxb.conn.fxbConnectedDevices.first(where: { $0.deviceName == deviceName }) {
            
            self.deviceVM = FXBDeviceViewModel(with: device)
            setInitialRecordCount()
            
            self.deviceVM?.device.$isSpecVersionMatched
                .prefix(2)
                .sink(receiveValue: { [weak self] matched in
                    self?.isActive = matched
                })
                .store(in: &observers)
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
        
//        self.subHose()
        
        Task {
            await fetchLatestConfig()
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
            .delay(for: 1.0, scheduler: DispatchQueue.main)
            .collect()
            .sink(receiveValue: { [weak self] dates in
                self?.recordCount += dates.count
                
                var diffs = [TimeInterval]()
                dates.enumerated().forEach { (i, date) in
                    guard i > 0 else { return }
                    diffs.append(dates[i].distance(to: dates[i-1]))
                }
                
                var meanTimeInterval = Double(diffs.count) / diffs.reduce(0.0, { $0 + $1 })
                self?.frequency = 1.0/meanTimeInterval
            })
            .store(in: &observers)
    }
    
    func fetchLatestConfig() async {
        guard let persistedConfig = await fxb.db.config(for: dataStream) else {
            return
        }
        
        for configDef in dataStream.configValues {
            if let vm = configVMs.first(where: { $0.config.name == configDef.name }) {
                if let colDef = persistedConfig.metadata.first(where: { $0.name == configDef.name }),
                    let value = persistedConfig.columns[colDef.cid].value as? String {
                    
                    vm.update(with: value)
                }
            }
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
            try? await Task.sleep(nanoseconds: 500_000_000)
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
    
//    func subHose() {
//        deviceVM?
//            .device
//            .dataHandler(for: dataStream.name)?
//            .firehose
//            .delay(for: 1.0, scheduler: DispatchQueue.global(qos: .utility))
//            .sink(receiveValue: { record in
//                print("🔥 record: ts: \(record.ts)")
//            })
//            .store(in: &observers)
//    }
}
