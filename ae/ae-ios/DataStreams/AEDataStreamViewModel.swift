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
    @Published var unUploadCount: Int = 0
    @Published var uploadAgg: FXBDBManager.UploadAggregate = FXBDBManager.UploadAggregate(0,0,0)
    
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
        
        timer = Timer.scheduledTimer(
            withTimeInterval: 0.5,
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
            self.unUploadCount = await fxb.db.unUploadedCount(for: dataStream)
            if timerCount % 5 == 0 || timerCount == 1 {
                self.meanFreqLastK = await fxb.db.meanFrequency(for: dataStream)
                self.uploadAgg = await fxb.db.uploadAgg(for: dataStream)
            }
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
    
    func fetchDatabaseValuesForGraph(graphProperty: DataExplorerGraphPropertyViewModel) async -> [(mark: String, data: [(ts: Date, val: Double)])] {
        let readings = graphProperty.getSelectedReadings()
        let propertyValues = graphProperty.getSelectedValuesFromProperty(forKey: graphProperty.selectedProperty)
        var result: [(mark: String, data: [(ts: Date, val: Double)])] = []
        var graphMin = Double.greatestFiniteMagnitude
        var graphMax = -Double.greatestFiniteMagnitude
        if graphProperty.checkDependencyOfReadingsOnProperty(for: readings, selectedProperty: graphProperty.selectedProperty) {
            let queryLimit = 2000
            if graphProperty.selectedProperty == nil {
                if readings.count != 0 {
                    for eachReading in readings {
                        var sql = "SELECT ts, \(eachReading) "
                        sql.append("FROM \(dataStream.name)_data ")
                        if graphProperty.getConfigName() == "accelerometry" {
                            sql.append("WHERE \(eachReading) <> 0 ")
                        }
                        
                        if graphProperty.shouldFilterByTimestamp {
                            sql.append(" AND created_at BETWEEN '\(graphProperty.startTimestamp.SQLiteDateFormat())' AND '\(graphProperty.endTimestamp.SQLiteDateFormat())' ")
                        }
                        sql.append("ORDER BY created_at DESC ")
                        sql.append("LIMIT \(queryLimit)")
                        let res = await fxb.read.getDatabaseValuesWithQuery(sqlQuery: sql, columnName: eachReading, propertyName: "")
                        graphMax = max(graphMax, res.maxVal)
                        graphMin = min(graphMin, res.minValue)
                        if res.queryData.isEmpty {
                            continue
                        }
                        result.append(res.queryData[0])
                    }
                    graphProperty.setYMinAndMax(yMin: graphMin, yMax: graphMax)
                    return result
                } else {
                    print("No reading selected. Choose default ?")
                }
            } else {
                guard let propertyValues = propertyValues, let selectedKey = graphProperty.selectedProperty else {
                    return []
                }
                for eachReading in readings {
                    for eachPropertyValue in propertyValues {
                        var sql = "SELECT ts, \(eachReading) "
                        sql.append("FROM \(dataStream.name)_data ")
                        sql.append("WHERE \(selectedKey) = \(eachPropertyValue) ")
                        if graphProperty.shouldFilterByTimestamp {
                            sql.append(" AND created_at BETWEEN \(graphProperty.startTimestamp) AND \(graphProperty.endTimestamp) ")
                        }
                        sql.append("ORDER BY created_at DESC ")
                        sql.append("LIMIT \(queryLimit) ")
                        let res = await fxb.read.getDatabaseValuesWithQuery(sqlQuery: sql, columnName: eachReading, propertyName: eachPropertyValue)
                        graphMax = max(graphMax, res.maxVal)
                        graphMin = min(graphMin, res.minValue)
                        if res.queryData.isEmpty {
                            continue
                        }
                        result.append(res.queryData[0])
                    }
                }
                graphProperty.setYMinAndMax(yMin: graphMin, yMax: graphMax)
                return result
            }
        }
        return []
    }
}
