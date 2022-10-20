//
//  DataStreamGraphViewModel.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 10/4/22.
//

import Foundation
import FlexiBLE
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
    
    @Published var dataStreamParameters: DataStreamGraphParameters = DataStreamGraphParameters()
    @Published var chartParameters: ChartParameters = ChartParameters()
    
    static var dataStreamParamsKeyPrefix: String = "fxb_data_stream_chart_params"
    static var chartParamsKeyPrefix: String = "fxb_chart_params"
    
    var dataService: DataStreamDataService
    
    @Published var data: [String: [DataStreamDataService.Point]] = [:]
    
//    @Published var xRange: ClosedRange<Date> = Date.now.addingTimeInterval(-1)...Date.now
//
//    @Published var yRange: ClosedRange<Double> = 0.0...1000.0
    private var intermediateYRange: ClosedRange<Double>?
    private var intermediateYDiff: Double?
    
    private var dataObserver: AnyCancellable?
    
    init(dataStream: FXBDataStream, deviceName: String) {
        self.deviceName = deviceName
        self.spec = dataStream
        self.dataService = DataStreamDataService(dataStream: dataStream, deviceName: deviceName)
        
        // TODO: load from disk
        self.dataStreamParameters = self.defaultDSParams()
        self.chartParameters = self.defaultChartParams()
        parametersUpdated()
        
        subscribeData()
    }
    
    func editingParameters() {
        dataObserver?.cancel()
        state = .loading
    }
    
    func parametersUpdated() {
        try? UserDefaults.standard.setCustomObject(
            self.dataStreamParameters,
            forKey: "\(Self.dataStreamParamsKeyPrefix)_\(spec.name)"
        )
        try? UserDefaults.standard.setCustomObject(
            self.chartParameters,
            forKey: "\(Self.chartParamsKeyPrefix)_\(spec.name)"
        )
        subscribeData()
        dataService.set(
            dsParams: self.dataStreamParameters,
            chartParams: self.chartParameters
        )
    }
    
    func resetYRange() {
        let points = data.map({ $1 }).reduce([], +)
        let yMin = points.reduce(Double.infinity, { $0 < $1.y ? $0 : $1.y })
        let yMax = points.reduce(-Double.infinity, { $0 > $1.y ? $0 : $1.y })
        
        if yMin < Double.infinity, yMax > -Double.infinity {
            let diffOffset = (yMax - yMin) * 0.15
            self.chartParameters.yMin = (yMin - diffOffset)
            self.chartParameters.yMax = (yMax + diffOffset)
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
        dataObserver?.cancel()
    }
    
    func resume() {
        guard chartParameters.state == .livePaused else { return }
        chartParameters.state = .live
        parametersUpdated()
    }
    
    func stop() {
        dataObserver?.cancel()
        dataObserver = nil
        dataService.stop()
    }
    
    func updateRange(amount: Double, end: Bool = false) {
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
        self.dataObserver = dataService
            .data
            .sink(
                receiveCompletion: { comp in
                    switch comp {
                    case .failure(let error):
                        self.state = .error(msg: error.localizedDescription)
                    case .finished: break
                    }
                },
                receiveValue: { [weak self] data in
                    guard let self = self else { return }
                    guard data.reduce(0, { $0 + $1.value.count}) > 0 else {
                        self.state = .noRecords
                        return
                    }

                    data.forEach { (key, values) in
                        if self.data[key] == nil {
                            self.data[key] = values
                        } else {
                            self.data[key]?.append(contentsOf: values)
                        }

                        self.data[key] = self.data[key]?.filter({ point in
                            switch self.chartParameters.state {
                            case .live:
                                let oldestTs = Date.now.addingTimeInterval(-self.chartParameters.liveInterval)
                                return point.x > oldestTs
                            case .timeboxed, .livePaused:
                                return point.x >= self.chartParameters.start && point.x < self.chartParameters.end
                            case .unspecified: return false
                            }
                        }).sorted(by: { $0.x > $1.x })
                    }
                    
                    if self.chartParameters.shouldAutoScale {
                        DispatchQueue.main.async {
                            self.resetYRange()
                        }
                    }

//                    DispatchQueue.main.async {
//                        switch self.chartParameters.state {
//                        case .live:
//                            self.chartParameters.xRange = Date.now.addingTimeInterval(-self.chartParameters.liveInterval)...Date.now
//                        case .timeboxed, .livePaused:
//                            self.xRange = self.chartParameters.start...self.chartParameters.end
//                        case .unspecified: break
//                        }
//                    }
                    
                    switch self.state {
                    case .loading:
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
                            self.state = .graphing
                        })
                    default: break
                    }

                }
            )

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
    
    private func defaultDSParams() -> DataStreamGraphParameters {
        let key = "\(Self.dataStreamParamsKeyPrefix)_\(spec.name)"
        
        if let params: DataStreamGraphParameters = try? UserDefaults
            .standard
            .getCustomObject(forKey: key) { // load existing parameters for data stream
            
            return params
            
        } else { // setup defaults for data stream
            let params = DataStreamGraphParameters()
            
            self.spec.dataValues.forEach { dv in
                switch dv.variableType {
                case .value: params.dependentSelections.append(dv.name)
                case .tag: params.filterSelections[dv.name] = [0]
                case .none: break
                }
            }
            return params
        }
    }
    
}
