//
//  DataStreamDataService.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 10/4/22.
//

import Foundation
import FlexiBLE
import FlexiBLESignal
import Combine

class DataStreamDataService {
    var profile: FlexiBLEProfile
    var dataStream: FXBDataStream
    var deviceName: String
    var chartParams: ChartParameters?
    
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
    
    typealias Point = (x: Date, y: Float)
    var ts: TimeSeries<Float>
    var tsPublisher = PassthroughSubject<TimeSeries<Float>, Error>()
    
    private var tsObserver: AnyCancellable?
    private var queryObserver: AnyCancellable?
    
    init(profile: FlexiBLEProfile, dataStream: FXBDataStream, deviceName: String) {
        self.profile = profile
        self.dataStream = dataStream
        self.deviceName = deviceName
        self.ts = TimeSeries(persistence: 5000) // FIXME: Manage Persistence
    }
    
    func set(chartParams: ChartParameters) {
        self.chartParams = chartParams
        stop()
        
        switch chartParams.state {
        case .live:
            queryDataTS(
                start: Date.now.addingTimeInterval(-chartParams.liveInterval),
                end: Date.now
            )
            liveFeed()
        case .timeboxed, .livePaused:
            queryDataTS(start: chartParams.start, end: chartParams.end)
        case .unspecified: break
        }
    }

    func setPersistence(_ persistence: Int) {
        self.ts.setPersistence(persistence)
    }
    
    func stop() {
        tsObserver?.cancel()
        tsObserver = nil
        
        queryObserver?.cancel()
        queryObserver = nil
    }
    
    private func liveFeed() {
        guard let device = profile.conn?.fxbConnectedDevices.first(where: { $0.deviceName == self.deviceName }) else {
            tsPublisher.send(completion: .failure(CustomError.deviceNotConnected))
            return
        }
        
        guard let dataStreamHandler = device.dataHandler(for: dataStream.name) else {
            tsPublisher.send(completion: .failure(CustomError.dataStreamNotFound))
            return
        }

        tsObserver = dataStreamHandler
            .firehose
            .collect(Publishers.TimeGroupingStrategy.byTime(DispatchQueue.main, 0.01))
            .sink { [weak self] records in
                guard let self = self else { return }

                records.forEach { (date: Date, values: [AEDataValue]) in
                    let vector = values
                        .enumerated()
                        .compactMap{ i, val -> Float? in
                            // FIXME: better type handling (at the database level).
                            // -- OR: infer it from the database
                            if let val = val as? Double {
                                return Float(val)
                            } else if let val = val as? Int {
                                return Float(val)
                            }
                            return nil
                        }

                    self.ts.add(
                        date: date,
                        values: vector
                    )
                }

                self.tsPublisher.send(self.ts)
            }
    }

    private func queryDataTS(start: Date, end: Date) {
        Task {
            do {
                let records = try await profile.database.dataStream.records(
                        for: self.dataStream.name,
                        from: start,
                        to: end,
                        deviceName: self.deviceName,
                        uploaded: nil
                )

                records.forEach { row in
                    guard let timestamp: Int64 = row.getValue(for: "ts") else {
                        return
                    }
                    let date = Date(timeIntervalSince1970: Double(timestamp) / 1_000_000.0)
                    
                    let values = dataStream.dataValues.compactMap({ dv -> Float? in
                        // FIXME: everything is a double
                        if let raw: Double = row.getValue(for: dv.name) {
                            return Float(raw)
                        }
                        return nil
                    })
                    ts.add(date: date, values: values)
                }
                tsPublisher.send(self.ts)

            } catch { self.tsPublisher.send(completion: .failure(error)) }
        }
    }
}
