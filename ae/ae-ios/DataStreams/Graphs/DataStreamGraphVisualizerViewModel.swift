//
//  DataStreamGraphVisualizerViewModel.swift
//  Flexi-BLE
//
//  Created by Blaine Rothrock on 9/19/22.
//

import Foundation
import FlexiBLE

@MainActor class DataStreamGraphVisualizerViewModel: ObservableObject {
    
    enum State {
        case loading
        case graph
        case error(message: String)
    }
    
    typealias GraphRecord = (ts: Date, val: Double)
    typealias GraphResult = (mark: String, data: [GraphRecord])
    
    let dataStream: FXBDataStream
    
    init(with dataStream: FXBDataStream) {
        self.dataStream = dataStream
    }
    
    
    // FIXME: refactor for readability
    func fetchDatabaseValuesForGraph(
        graphProperty: DataExplorerGraphPropertyViewModel
    ) async -> [GraphResult] {
        
        let readings = graphProperty.getSelectedReadings()
        let selectedProperty = graphProperty.variableModel.selectedProperty
        let propertyValues = graphProperty.getSelectedValuesFromProperty(forKey: selectedProperty)
        var result: [GraphResult] = []
        var graphMin: Double = 0
        var graphMax: Double = 0
        if graphProperty.checkDependencyOfReadingsOnProperty(for: readings, selectedProperty: selectedProperty) {
            let queryLimit = 2000
            if selectedProperty == nil {
                if readings.count != 0 {
                    for eachReading in readings {
                        var sql = "SELECT ts, \(eachReading) "
                        sql.append("FROM \(dataStream.name)_data ")
                        if graphProperty.getConfigName() == "accelerometry" {
                            sql.append("WHERE \(eachReading) <> 0 ")
                        }
                        
                        if graphProperty.visualModel.graphState == .live {
                            let endDate = Date()
                            let startDate = endDate.getEarlierDateBySeconds(interval: Int(graphProperty.visualModel.liveInterval))
                            sql.append(" AND ts BETWEEN '\(startDate.SQLiteDateFormat())' AND '\(endDate.SQLiteDateFormat())' ")
                        } else {
                            if graphProperty.visualModel.shouldFilterByTimestamp {
                                sql.append(" AND ts BETWEEN '\(graphProperty.visualModel.startTimestamp.SQLiteDateFormat())' AND '\(graphProperty.visualModel.endTimestamp.SQLiteDateFormat())' ")
                            }
                        }
                        
                        sql.append("ORDER BY ts DESC ")
                        if graphProperty.visualModel.graphState == .parameterized {
                            sql.append("LIMIT \(queryLimit)")
                        }
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
                guard let propertyValues = propertyValues, let selectedKey = graphProperty.variableModel.selectedProperty else {
                    return []
                }
                for eachReading in readings {
                    for eachPropertyValue in propertyValues {
                        var sql = "SELECT ts, \(eachReading) "
                        sql.append("FROM \(dataStream.name)_data ")
                        sql.append("WHERE \(selectedKey) = \(eachPropertyValue) ")
                        
                        if graphProperty.visualModel.graphState == .live {
                            let endDate = Date()
                            let startDate = endDate.getEarlierDateBySeconds(interval: Int(graphProperty.visualModel.liveInterval))
                            sql.append(" AND ts BETWEEN '\(startDate.SQLiteDateFormat())' AND '\(endDate.SQLiteDateFormat())' ")
                        } else {
                            if graphProperty.visualModel.shouldFilterByTimestamp {
                                sql.append(" AND ts BETWEEN '\(graphProperty.visualModel.startTimestamp.SQLiteDateFormat())' AND '\(graphProperty.visualModel.endTimestamp.SQLiteDateFormat())' ")
                            }
                        }
                        sql.append("ORDER BY ts DESC ")
                        if graphProperty.visualModel.graphState == .parameterized {
                            sql.append("LIMIT \(queryLimit) ")
                        }
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
