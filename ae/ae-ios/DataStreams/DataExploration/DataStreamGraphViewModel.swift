//
//  DataStreamGraphViewModel.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 10/4/22.
//

import Foundation
import SwiftUI
import FlexiBLE
import FlexiBLESignal
import Combine

@MainActor class DataStreamGraphViewModel: ObservableObject {
    enum State {
        case loading
        case graphing
        case noRecords
        case error(msg: String)
    }
    
    var state: State = .loading
    var deviceName: String
    var spec: FXBDataStream
    
    @Published var dataStreamParameters: DataStreamChartParameters = DataStreamChartParameters()
    @Published var chartParameters: ChartParameters = ChartParameters()
    
    static var dataStreamParamsKeyPrefix: String = "fxb_data_stream_chart_params"
    static var chartParamsKeyPrefix: String = "fxb_chart_params"
    
    typealias Point = (x: Date, y: Float)
    var dataService: DataStreamDataService
    
    @Published var data: [String: [Point]]

    private var intermediateYRange: ClosedRange<Float>?
    private var intermediateYDiff: Float?
    
    private var tsObserver: AnyCancellable?
    
    init(dataStream: FXBDataStream, deviceName: String) {
        self.deviceName = deviceName
        self.spec = dataStream
        self.dataService = DataStreamDataService(dataStream: dataStream, deviceName: deviceName)
        self.data = [:]

        self.dataStreamParameters = self.defaultDSParams()
        self.chartParameters = self.defaultChartParams()
        parametersUpdated()
    }
    
    func editingParameters() {
        tsObserver?.cancel()
        state = .loading
    }
    
    func saveParameters() {
        try? UserDefaults.standard.setCustomObject(
            self.dataStreamParameters,
            forKey: "\(Self.dataStreamParamsKeyPrefix)_\(spec.name)"
        )
        try? UserDefaults.standard.setCustomObject(
            self.chartParameters,
            forKey: "\(Self.chartParamsKeyPrefix)_\(spec.name)"
        )
    }
    
    func parametersUpdated() {
        subscribeData()
        saveParameters()
        dataService.set(chartParams: self.chartParameters)
        dataService.setPersistence(10000)
    }
    
    func resetYRange() {
        let points = data.map({ $1 }).reduce([], +)
        let yMin = points.reduce(Float.infinity, { $0 < $1.y ? $0 : $1.y })
        let yMax = points.reduce(-Float.infinity, { $0 > $1.y ? $0 : $1.y })
        
        if yMin < Float.infinity, yMax > -Float.infinity {
            let diffOffset = (yMax - yMin) * 0.15
            var yMin = (yMin - diffOffset)
            var yMax = (yMax + diffOffset)
            if yMin == yMax {
                yMin -= 1
                yMax += 1
            }
            chartParameters.yMin = yMin
            chartParameters.yMax = yMax
        }
    }
        
    func yRangeFilter(_ points: [DataStreamDataService.Point]) -> [DataStreamDataService.Point] {
        return points.filter({ point in
            return point.y > (chartParameters.yMin) && point.y < (chartParameters.yMax)
        })
    }
    
    func pause() {
        guard chartParameters.state == .live else { return }
        chartParameters.state = .livePaused
        chartParameters.start = Date.now.addingTimeInterval(-chartParameters.liveInterval)
        chartParameters.end = Date.now
        tsObserver?.cancel()
    }
    
    func resume() {
        guard chartParameters.state == .livePaused else { return }
        chartParameters.state = .live
        parametersUpdated()
    }
    
    func stop() {
        tsObserver?.cancel()
        tsObserver = nil
        dataService.stop()
    }
    
    func updateRange(amount: Float, end: Bool = false) {
        guard let irange = intermediateYRange,
        let mid = intermediateYDiff else {
            intermediateYRange = chartParameters.yRange
            intermediateYDiff = (chartParameters.yRange.lowerBound + chartParameters.yRange.upperBound) / 2.0
            return
        }
        let newLower = min((irange.lowerBound + (mid * (amount-1))), mid)
        let newUpper = max((irange.upperBound - (mid * (amount-1))), mid)
        print("ZOOM: mid: \(mid): \(newLower) -> \(newUpper)")
        chartParameters.yMin = newLower
        chartParameters.yMax = newUpper
        if end { intermediateYRange = nil }
    }
    
    private func subscribeData() {
        self.tsObserver = dataService
            .tsPublisher
            .throttle(for: 0.1, scheduler: RunLoop.main, latest: true)
            .compactMap(self.trimTimeSeriesToChartParams)
            .sink(
                receiveCompletion: { comp in
                    switch comp {
                    case .failure(let error):
                        self.state = .error(msg: error.localizedDescription)
                    case .finished: break
                    }
                },
                receiveValue: self.parseTimeSeries
            )
        
        parseTimeSeries(ts: dataService.ts)
    }

    private func trimTimeSeriesToChartParams(ts: TimeSeries<Float>) -> TimeSeries<Float>? {
        switch self.chartParameters.state {
        case .live:
            return ts.cut(
                    before: Date.now.addingTimeInterval(-self.chartParameters.liveInterval),
                    after: Date.now
            )
        case .timeboxed, .livePaused:
            return ts.cut(
                    before: self.chartParameters.start,
                    after: self.chartParameters.end
            )
        default: return nil
        }
    }
    
    private func parseTimeSeries(ts timeseries: TimeSeries<Float>) {
        guard !timeseries.isEmpty else { return }

        let conditions: [TimeSeriesSortCondition<Float>] = self.buildChartParamFilterConditions()
        
        let tss = timeseries.splitSort(criteria: conditions)
        var _data: [String: [Point]] = [:]
        
        for ts in tss {
            for (i, column) in ts.columns.enumerated() {
    
                let points = zip(ts.indexDates(), column.vector).map {
                    Point(x: $0, y: $1)
                }
                _data[column.name ?? "\(i)"] = points
            }
        }

        // single update to the graph
        DispatchQueue.main.async {
            self.state = .graphing
            self.data = _data
            if self.chartParameters.shouldAutoScale {
                self.resetYRange()
            }
        }
    }

    private func buildChartParamFilterConditions() -> [TimeSeriesSortCondition<Float>] {
        return self.spec.dataValues.enumerated().map({ idx, dv -> [TimeSeriesSortCondition<Float>] in
            switch dv.variableType {
            case .tag:
                guard let selections = self.dataStreamParameters
                        .tagSelections[dv.name] else { break }

                if selections.isEmpty {
                    return [TimeSeriesSortCondition.none(idx)]
                }

                let includes = spec.dataValues
                    .enumerated()
                    .compactMap { i, dep in
                        // check dependence to current tag data value, then if the value is selected.
                        if dep.dependsOn?.contains(dv.name) ?? false &&
                                   self.dataStreamParameters.dependentSelections.contains(dep.name) {
                            return i
                        }
                        return nil
                    }

                var conds = [TimeSeriesSortCondition<Float>]()
                for selection in selections {
                    conds.append(
                            TimeSeriesSortCondition(
                                    colIdx: idx,
                                    filter: { [selection] val in
                                        return selection == Int(val)
                                    },
                                    include: includes,
                                    names: includes.map { "\(spec.dataValues[$0].name)-\(selection)" }
                            )
                    )
                }
                return conds
            case .value:
                guard dv.dependsOn == nil || dv.dependsOn?.isEmpty ?? true else { break }
                if self.dataStreamParameters
                           .dependentSelections.contains(self.spec.dataValues[idx].name) {
                    return [TimeSeriesSortCondition.all(idx, name: dv.name, include: [idx])]
                } else {
                    return [TimeSeriesSortCondition.none(idx)]
                }
            default: break
            }
            return [TimeSeriesSortCondition.none(idx)]
        })
                .flatMap({ $0 })
    }
    
    private func defaultChartParams() -> ChartParameters {
        let key = "\(Self.chartParamsKeyPrefix)_\(spec.name)"
        
        if let params: ChartParameters = try? UserDefaults
            .standard
            .getCustomObject(forKey: key) {
            
            return params
        } else {
            let params = ChartParameters()
            
            if let device = fxb.conn.fxbConnectedDevices.first(where: { $0.deviceName == self.deviceName }) {
                if device.connectionState == .connected {
                    params.state = .live
                    params.liveInterval = 10
                }
            } else {
                params.state = .timeboxed
                params.start = Date.now.addingTimeInterval(-30)
                params.end = Date.now
            }
            
            return params
        }
    }
    
    private func defaultDSParams() -> DataStreamChartParameters {
        let key = "\(Self.dataStreamParamsKeyPrefix)_\(spec.name)"
        
        if let params: DataStreamChartParameters = try? UserDefaults
            .standard
            .getCustomObject(forKey: key) { // load existing parameters for data stream
            
            return params
            
        } else { // setup defaults for data stream
            let params = DataStreamChartParameters()
            
            self.spec.dataValues.forEach { dv in
                switch dv.variableType {
                case .value: params.dependentSelections.append(dv.name)
                case .tag: params.tagSelections[dv.name] = [0]
                case .none: break
                }
            }
            return params
        }
    }
    
}
