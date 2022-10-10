//
//  DataStreamDataService.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 10/4/22.
//

import Foundation
import FlexiBLE
import Combine

class DataStreamDataService {
    var dataStream: FXBDataStream
    var deviceName: String
    var parameters: DataStreamGraphParameters?
    
    enum CustomError: Error, LocalizedError {
        case deviceNotConnected
        case dataStreamNotFound
        case parametersNotSet
        
        var errorDescription: String? {
            switch self {
            case .parametersNotSet: return "Parameters not set."
            case .deviceNotConnected: return "The device is not connected, cannot query live data."
            case .dataStreamNotFound: return "No data stream found on device."
            }
        }
    }
    
    typealias Point = (x: Date, y: Double)
    
    var data = PassthroughSubject<[String:[Point]], Error>()
    
    private var liveObserver: AnyCancellable?
    private var queryObserver: AnyCancellable?
    
    init(dataStream: FXBDataStream, deviceName: String) {
        self.dataStream = dataStream
        self.deviceName = deviceName
    }
    
    func set(params: DataStreamGraphParameters) {
        self.parameters = params
        stop()
        
        switch params.state {
        case .live:
            queryData(
                start: Date.now.addingTimeInterval(-params.liveInterval),
                end: Date.now
            )
            liveFeed()
        case .timeboxed, .livePaused: queryData(start: params.start, end: params.end)
        case .unspecified: break
        }
    }
    
    func stop() {
        liveObserver?.cancel()
        liveObserver = nil
        
        queryObserver?.cancel()
        queryObserver = nil
    }
    
    private func liveFeed() {
        guard let params = self.parameters else {
            data.send(completion: .failure(CustomError.parametersNotSet))
            return
        }
        
        guard let device = fxb.conn.fxbConnectedDevices.first(where: { $0.deviceName == self.deviceName }) else {
            data.send(completion: .failure(CustomError.deviceNotConnected))
            return
        }
        
        guard let dataStreamHandler = device.dataHandler(for: dataStream.name) else {
            data.send(completion: .failure(CustomError.dataStreamNotFound))
            return
        }
        
        liveObserver = dataStreamHandler
            .firehose
            .collect(Publishers.TimeGroupingStrategy.byTime(DispatchQueue.main, 0.1))
            .sink(receiveValue: { [weak self] records in // organize in to points by tags
                guard let ds = self?.dataStream,
                    let params = self?.parameters else { return }
                
                var data = [String: [Point]]()
            
                records.forEach { record in
                    record.values.enumerated().forEach { i, val in
                        let dv = ds.dataValues[i]
                        
                        guard
                            dv.variableType == .value,
                            params.dependentSelections.contains(dv.name) else { return }
                        
                        var doubleVal: Double = 0.0
                        switch dv.type {
                        case .float: doubleVal = Double(val as! Float)
                        case .int, .unsignedInt: doubleVal = Double(val as! Int)
                        case .string: doubleVal = Double(val as! String) ?? 0.0
                        }
                        
                        if let dependents = dv.dependsOn, dependents.count > 0 {
                            dependents.forEach { dependent in
                                (params.filterSelections[dependent] ?? []).forEach { dependentSelection in
                                    
                                    // check if point is part of the selection
                                    guard let tagDv = ds.dataValue(for: dependent),
                                          let selectionName = tagDv.valueOptions?[dependentSelection],
                                          let tagIdx = ds.dataValues.firstIndex(where: { $0.name == tagDv.name }),
                                          let tagValue = record.values[tagIdx] as? Int else { return }
                                    
                                    
                                    if tagValue == dependentSelection {
                                        let point = Point(x: record.ts, y: doubleVal)
                                        if data["\(selectionName)-\(dv.name)"] == nil {
                                            data["\(selectionName)-\(dv.name)"] = [point]
                                        } else {
                                            data["\(selectionName)-\(dv.name)"]?.append(point)
                                        }
                                    }
                                }
                            }
                        } else {
                            let point = Point(x: record.ts, y: doubleVal)
                            if data[dv.name] != nil {
                                data[dv.name]?.append(point)
                            } else {
                                data[dv.name] = [point]
                            }
                        }
                    }
                }
                
                self?.data.send(data)
            })
    }
    
    private func queryData(start: Date, end: Date) {
        guard let params = parameters else { return }
        
        Task {
            do {
                let records = try await fxb.read.getRecords(
                    for: "\(dataStream.name)_data",
                    from: start,
                    to: end,
                    deviceName: deviceName,
                    uploaded: nil
                )
                
                var data: [String: [Point]] = [:]
                
                records.forEach { row in
                    params.dependentSelections.forEach { selection in
                        
                        guard let dv = dataStream.dataValue(for: selection),
                              dv.variableType == .value,
                              let tsStr: String  = row.getValue(for: "ts"),
                              let ts: Date = Date.fromSQLString(tsStr),
                                let val: Double = row.getValue(for: selection) else { return }
                        
                        if let dependents = dv.dependsOn, dependents.count > 0 {
                            dependents.forEach { dependent in
                                (params.filterSelections[dependent] ?? []).forEach { dependentSelection in
                                    
                                    guard let tagDv = dataStream.dataValue(for: dependent),
                                          let selectionName = tagDv.valueOptions?[dependentSelection],
                                          let tagValue: Double = row.getValue(for: dependent) else { return }
                                    
                                    if Int(tagValue) == dependentSelection {
                                        let point = Point(x: ts, y: val)
                                        if data["\(selectionName)-\(dv.name)"] == nil {
                                            data["\(selectionName)-\(dv.name)"] = [point]
                                        } else {
                                            data["\(selectionName)-\(dv.name)"]?.append(point)
                                        }
                                    }
                                }
                            }
                        } else {
                            let point = Point(x: ts, y: val)
                            if data[dv.name] != nil {
                                data[dv.name]?.append(point)
                            } else {
                                data[dv.name] = [point]
                            }
                        }
                    }
                }
                
                self.data.send(data)
            } catch {
                self.data.send(completion: .failure(error))
            }
        }
    }
}
