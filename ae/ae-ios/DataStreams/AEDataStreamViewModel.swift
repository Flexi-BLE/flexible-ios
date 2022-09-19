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
    @Published var dataStream: FXBDataStream
    @Published var recordCount: Int = 0
    @Published var meanFreqLastK: Float = 0
    
    @Published var configVMs: [ConfigViewModel] = []
    
    private var timer: Timer?
    private var timerCount: Int = 0
    
    private var deviceName: String
    
    var estimatedReload: Double {
        return 0
    }
    
    init(_ dataStream: FXBDataStream, deviceName: String) {
        self.dataStream = dataStream
        self.deviceName = deviceName
        
        // TODO: Timer reloads complete view of app each time it is triggered
        timer = Timer.scheduledTimer(
            withTimeInterval: 2,
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
            self.recordCount = await fxb.db.recordCountByIndex(for: dataStream)
            timerCount += 1
        }
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
            thingName: deviceName,
            dataSteam: dataStream,
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
}
