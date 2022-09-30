//
//  DataStreamGraphVisualizerViewModel.swift
//  Flexi-BLE
//
//  Created by Blaine Rothrock on 9/19/22.
//

import Foundation
import FlexiBLE
import Combine

typealias GraphRecord = (ts: Date, val: Double)
typealias GraphResult = (mark: String, data: [GraphRecord])

typealias GraphResultNK = [String: [GraphRecord]]


@MainActor class DataStreamGraphVisualizerViewModel: ObservableObject {
    
    enum State {
        case loading
        case graphing
        case editing
        case error(message: String)
    }
    
    var timer: Timer? = nil
    
    typealias SQLQueryResults = (queryData:[GraphResult], maxVal: Double, minValue: Double, lastRecordTime: Date)
    
    @Published var databaseResults: [GraphResult] = []
    @Published var databResults = GraphResultNK()
    var dbResults: [GenericRow] = []
    
    private var lastTimestampRecorded: Date?
    let dataStream: FXBDataStream
    var state: State = .loading
    
    init(with dataStream: FXBDataStream) {
        self.dataStream = dataStream
    }
    
    func fetchDBValuesForGraph(graphModel: DataExplorerGraphPropertyViewModel) async {
        let readings = graphModel.getSelectedReadings()
        let selectedProperty = graphModel.variableModel.selectedProperty
        let propertyValues = graphModel.getSelectedValuesFromProperty(forKey: selectedProperty)
        
        let tableName = "\(dataStream.name)_data"
        if graphModel.checkDependencyOfReadingsOnProperty(for: readings, selectedProperty: selectedProperty) {
            if selectedProperty == nil {
                if readings.count != 0 {
                    let endTime = Date.now
                    var startTime = Date.now
                    if timer == nil {
                        startTime = endTime.getEarlierDateBySeconds(interval: Int(graphModel.visualModel.liveInterval))
                    } else {
                        guard let last = dbResults.last,
                              let timeStr: String = last.getValue(for: "ts"),
                              let time: Date = Date.fromSQLStringNK(timeStr) else {
                            return
                        }
                        startTime = time
                    }
                    await getDBResultsForReadings(
                        graphProperty: graphModel,
                        readings: readings,
                        tableName: tableName,
                        startTime: startTime,
                        endTime: endTime,
                        completion: { [self] value in
                        guard let sqlResult = value else {
                            return
                        }
                            if self.timer == nil {
                            timer = Timer.scheduledTimer(
                                withTimeInterval: 0.5,
                                repeats: true,
                                block: { _ in
                                    Task { [weak self] in
                                        guard let self = self else { return }
                                        await self.fetchDBValuesForGraph(graphModel: graphModel)
                    //                    self.lastWrite = await fxb.db.lastDataStreamDate(for: thing)
                                    }
                                }
                            )
                        }
                        DispatchQueue.main.async { [self] in
                            
                            let timeD = Date.now.timeIntervalSince1970 - endTime.timeIntervalSince1970
                            print("NK_DEBUG : OLD DB-RESULT = \(dbResults.count) AND NEW RECORDS = \(sqlResult.count) - TIME DIFF = \(timeD)")
//                            dbResults.append(contentsOf: sqlResult)
                            filterAndBuildRecordModel(
                                graphModel: graphModel,
                                readings: readings,
                                endTime: endTime,
                                result: sqlResult
                            )
                        }
                    })
                }
            }
        }
    }
    
    private func getDBResultsForReadings(graphProperty: DataExplorerGraphPropertyViewModel,
                                         readings: [String],
                                         tableName: String,
                                         startTime: Date,
                                         endTime: Date,
                                         completion: @escaping (_ value: [GenericRow]?)->()
    ) async {
        let columns = readings.joined(separator: ",")
        var sql = "SELECT ts, \(columns) "
        sql.append("FROM \(tableName) ")
        sql.append("WHERE ts BETWEEN '\(startTime.SQLiteDateFormat())' AND '\(endTime.SQLiteDateFormat())' ")
        sql.append(" ORDER BY ts ASC")
        completion(await fxb.read.getRecordsForQuery(sqlQuery: sql, tableName: tableName))
        
        
//        return await fxb.read.getRecordsForQuery(sqlQuery: sql, tableName: tableName)
    }
    
    private func filterAndBuildRecordModel(graphModel: DataExplorerGraphPropertyViewModel, readings: [String], endTime: Date, result: [GenericRow]) {
//        var filtered: [GenericRow] = []
        var finalRecords = [String: [GraphRecord]]()
        let startTime = endTime.getEarlierDateBySeconds(interval: Int(graphModel.visualModel.liveInterval))
        graphModel.visualModel.startTimestamp = startTime
        graphModel.visualModel.endTimestamp = endTime

        let startIndex = dbResults.firstIndex(where: {
            guard let timeStr: String = $0.getValue(for: "ts"),
                  let time = Date.fromSQLStringNK(timeStr) else {
                return false
            }
            return time > startTime
        })
        
        if graphModel.visualModel.graphState == .live, let index = startIndex {
//            dbResults = dbResults.filter {
//                guard let tsStr: String = $0.getValue(for: "ts"),
//                      let ts = Date.fromSQLStringNK(tsStr) else {
//                    return false
//                }
//                return ts >= startTime && ts < endTime
//            }
            dbResults.removeFirst(index)
            
        }
        dbResults.append(contentsOf: result)
//        dbResults = filtered
        
        for eachRecord in dbResults {
            guard let tsStr: String = eachRecord.getValue(for: "ts"),
                  let ts = Date.fromSQLStringNK(tsStr) else {
                return
            }
//            if ts >= start && ts < cursorTime {
                for eachReading in readings {
                    guard let readValue: Double = eachRecord.getValue(for: eachReading) else {
                        return
                    }
                    let dataEntry = (ts: ts, val: readValue)
                    //                var values = finalRecords[eachReading] ?? [GraphRecord]()
                    finalRecords[eachReading, default: [GraphRecord]()].append(dataEntry)
                    //                finalRecords[eachReading]?.append(dataEntry)
                }
//            }
        }
        
//        print(finalRecords)
        databResults = finalRecords
//        print(databResults)
            
//            guard let tsStr: String = eachResult.getValue(for: "ts"),
//                  let ts = Date.fromSQLStringNK(tsStr),
//                  let accel_x: Double = eachResult.getValue(for: "accel_x") else {
//                return
//            }
//            print(tsStr)
//            print(ts)
//            print(accel_x)
    }
    
    
    // FIXME: refactor for readability
    func fetchDatabaseValuesForGraph(
        graphProperty: DataExplorerGraphPropertyViewModel
    ) async {
        let readings = graphProperty.getSelectedReadings()
        let selectedProperty = graphProperty.variableModel.selectedProperty
        let propertyValues = graphProperty.getSelectedValuesFromProperty(forKey: selectedProperty)
        
        var result: [GraphResult] = []
        var graphMin: Double = Double.greatestFiniteMagnitude
        var graphMax: Double = -Double.greatestFiniteMagnitude
        
        let endTimestamp = Date.now
        let startTimestamp = endTimestamp.getEarlierDateBySeconds(interval: Int(graphProperty.visualModel.liveInterval))
        
        
        if graphProperty.checkDependencyOfReadingsOnProperty(for: readings, selectedProperty: selectedProperty) {
            if selectedProperty == nil {
                if readings.count != 0 {
                    for reading in readings {
                        let sqlResult = await retrieveReadingSQLRecords(reading: reading, propertyVM: graphProperty, startTime: startTimestamp, endTime: endTimestamp)
                        graphMax = max(graphMax, sqlResult.maxVal)
                        graphMin = min(graphMin, sqlResult.minValue)
                        if sqlResult.queryData.isEmpty {
                            continue
                        }
                        lastTimestampRecorded = sqlResult.lastRecordTime
                        result.append(sqlResult.queryData[0])
                    }
                } else {
                    self.state = .error(message: "No reading selected. Choose default ?")
                }
            } else {
                guard let propertyValues = propertyValues, let selectedKey = graphProperty.variableModel.selectedProperty else {
//                    return []
                    return
                }
                for reading in readings {
                    for eachPropertyValue in propertyValues {
                        let sqlResult = await retrievePropertyReadingSQLRecords(reading: reading, property: eachPropertyValue, selectedKey: selectedKey, propertyVM: graphProperty)
                        graphMax = max(graphMax, sqlResult.maxVal)
                        graphMin = min(graphMin, sqlResult.minValue)
                        if sqlResult.queryData.isEmpty {
                            continue
                        }
                        lastTimestampRecorded = sqlResult.lastRecordTime
                        result.append(sqlResult.queryData[0])
                    }
                }
            }
            DispatchQueue.main.async { [self] in
                graphProperty.setYMinAndMax(yMin: graphMin, yMax: graphMax)
                filterDatasetValues(graph: graphProperty, forResult: result, startTime: startTimestamp, endTime: endTimestamp)
            }
//            graphProperty.lastReceivedTimeRecord = result.first?.data.last?.ts
//            return result
        }
        self.state = .error(message: "Another error ?")
//        return []
        return
    }
    
    private func filterDatasetValues(graph: DataExplorerGraphPropertyViewModel, forResult: [GraphResult], startTime: Date, endTime: Date) {
//        var processingData = databaseResults
//        processingData.append(contentsOf: forResult)
        if databaseResults.count == 0 {
            databaseResults = forResult
            graph.visualModel.endTimestamp = endTime
            graph.visualModel.startTimestamp = startTime
        }
        
        var newData = [GraphResult]()
        for eachOldResult in databaseResults {
            for eachNewResult in forResult {
                if  eachOldResult.mark == eachNewResult.mark {
                    var tempData = eachOldResult.data
                    tempData.append(contentsOf: eachNewResult.data)
                    let filtered = tempData.filter { $0.ts >= startTime && $0.ts <= endTime }
                    newData.append((mark: eachOldResult.mark, data: filtered))
                }
//                let filtered = eachOldResult
            }
//            let filtered = eachGraphResult.data.filter { $0.ts >= startTime && $0.ts <= endTime }
//            newData.append((mark: eachGraphResult.mark, data: filtered))
        }
        databaseResults = newData
        graph.visualModel.endTimestamp = endTime
        graph.visualModel.startTimestamp = startTime
    }
    
    func retrieveReadingSQLRecords(reading: String, propertyVM: DataExplorerGraphPropertyViewModel, startTime: Date, endTime: Date) async -> SQLQueryResults {
        let queryLimit = 2000
        var sql = "SELECT ts, \(reading) "
        sql.append("FROM \(dataStream.name)_data ")
        
        if let lastRecord = lastTimestampRecorded {
            sql.append("WHERE ts BETWEEN '\(lastRecord.SQLiteDateFormat())' AND '\(endTime.SQLiteDateFormat())' ")
        } else {
            if propertyVM.visualModel.graphState == .live {
                sql.append(" WHERE ts BETWEEN '\(startTime.SQLiteDateFormat())' AND '\(endTime.SQLiteDateFormat())' ")
            } else if propertyVM.visualModel.graphState == .highlights {
                if propertyVM.visualModel.shouldFilterByTimestamp {
                    sql.append(" WHERE ts BETWEEN '\(propertyVM.visualModel.startTimestamp.SQLiteDateFormat())' AND '\(propertyVM.visualModel.endTimestamp.SQLiteDateFormat())' ")
                }
            }
        }
        if propertyVM.getConfigName() == "accelerometry" {
            sql.append("AND \(reading) <> 0 ")
        }

        
        sql.append("ORDER BY ts DESC ")
        if propertyVM.visualModel.graphState == .highlights {
            sql.append("LIMIT \(queryLimit)")
        }
        return await fxb.read.getDatabaseValuesWithQuery(sqlQuery: sql, columnName: reading, propertyName: "")
    }
    
    
    func retrievePropertyReadingSQLRecords(reading: String, property: String, selectedKey: String, propertyVM: DataExplorerGraphPropertyViewModel) async -> SQLQueryResults {
        let queryLimit = 2000
        var sql = "SELECT ts, \(reading) "
        sql.append("FROM \(dataStream.name)_data ")
        sql.append("WHERE \(selectedKey) = \(property) ")
        
        if propertyVM.visualModel.graphState == .live {
            sql.append(" AND ts BETWEEN '\(propertyVM.visualModel.startTimestamp.SQLiteDateFormat())' AND '\(propertyVM.visualModel.endTimestamp.SQLiteDateFormat())' ")
        } else {
            if propertyVM.visualModel.shouldFilterByTimestamp {
                sql.append(" AND ts BETWEEN '\(propertyVM.visualModel.startTimestamp.SQLiteDateFormat())' AND '\(propertyVM.visualModel.endTimestamp.SQLiteDateFormat())' ")
            }
        }
        sql.append("ORDER BY ts DESC ")
        if propertyVM.visualModel.graphState == .highlights {
            sql.append("LIMIT \(queryLimit) ")
        }
        return await fxb.read.getDatabaseValuesWithQuery(sqlQuery: sql, columnName: reading, propertyName: property)
    }
}
