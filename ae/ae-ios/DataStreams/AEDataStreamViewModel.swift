//
//  AEDataStreamViewModel.swift
//  ae
//
//  Created by Blaine Rothrock on 4/27/22.
//

import Foundation
import Combine
import SwiftUI
import aeble
import GRDB

@MainActor class AEDataStreamViewModel: ObservableObject {
    @Published var dataStream: AEDataStream
    @Published var recordCount: Int = 0
    @Published var meanFreqLastK: Float = 0
    @Published var unUploadCount: Int = 0
    @Published var uploadAgg: AEBLEDBManager.UploadAggregate = AEBLEDBManager.UploadAggregate(0,0,0)
    
    @Published var configVMs: [ConfigViewModel] = []
    
    private var timer: Timer?
    private var timerCount: Int = 0
    
    private var deviceName: String
    
    var estimatedReload: Double {
        return 0
    }
    
    init(_ dataStream: AEDataStream, deviceName: String) {
        self.dataStream = dataStream
        self.deviceName = deviceName
        
        timer = Timer.scheduledTimer(
            withTimeInterval: 5.0,
            repeats: true,
            block: { _ in self.onTimer() }
        )
        
        for config in dataStream.configValues {
            configVMs.append(ConfigViewModel(config: config))
        }
        
        Task {
            await fetchLatestConfig()
        }
    }
    
    private func onTimer() {
        Task {
            self.recordCount = await aeble.db.recordCountByIndex(for: dataStream)
            self.unUploadCount = await aeble.db.unUploadedCount(for: dataStream)
            if timerCount % 5 == 0 || timerCount == 1 {
                self.meanFreqLastK = await aeble.db.meanFrequency(for: dataStream)
                self.uploadAgg = await aeble.db.uploadAgg(for: dataStream)
            }
            timerCount += 1
        }
    }
    
    func fetchLatestConfig() async {
        guard let persistedConfig = await aeble.db.config(for: dataStream) else {
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
        
        aeble.conn.updateConfig(
            thingName: deviceName,
            dataSteam: dataStream,
            data: data
        )
        
    }
    
    func fetchData<T: AEDataValue & DatabaseValueConvertible>(limit: Int = 1000, offset: Int = 0) async -> [T] {
        return await aeble.db.dataValues(
            for: dataStream.name,
            measurement: dataStream.dataValues[0].name,
            offset: offset,
            limit: limit
        )
    }
}
