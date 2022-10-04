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
    var parameters: DataStreamGraphParameters = DataStreamGraphParameters()
    
    static var dataStreamParamsKeyPrefix: String = "fxb_ds_graph_params"
    
    var dataService: DataStreamDataService
    
    @Published var data: [String: [DataStreamDataService.Point]] = [:]
    @Published var xRange: ClosedRange<Date> = Date.now.addingTimeInterval(-1)...Date.now
    
    private var observers = Set<AnyCancellable>()
    
    init(dataStream: FXBDataStream, deviceName: String) {
        self.deviceName = deviceName
        self.spec = dataStream
        self.dataService = DataStreamDataService(dataStream: dataStream, deviceName: deviceName)
        
        // TODO: load from disk
        self.parameters = self.defaultParams()
        parametersUpdated()
        
        subscribe()
    }
    
    func parametersUpdated() {
        data = [:]
        state = .loading
        try? UserDefaults.standard.setCustomObject(
            self.parameters,
            forKey: "\(Self.dataStreamParamsKeyPrefix)_\(spec.name)"
        )
        dataService.set(params: self.parameters)
    }
    
    private func subscribe() {
        dataService
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
                    
                    self.state = .graphing
                    
                    data.forEach { (key, values) in
                        if self.data[key] == nil {
                            self.data[key] = values
                        } else {
                            self.data[key]?.append(contentsOf: values)
                        }
                        
                        self.data[key] = self.data[key]?.filter({ point in
                            switch self.parameters.state {
                            case .live:
                                let oldestTs = Date.now.addingTimeInterval(-self.parameters.liveInterval)
                                return point.x > oldestTs
                            case .timeboxed:
                                return point.x >= self.parameters.start && point.x < self.parameters.end
                            case .unspecified: return false
                            }
                        })
                    }
                
                    DispatchQueue.main.async {
                        switch self.parameters.state {
                        case .live:
                            self.xRange = Date.now.addingTimeInterval(-self.parameters.liveInterval)...Date.now
                        case .timeboxed:
                            self.xRange = self.parameters.start...self.parameters.end
                        case .unspecified: break
                        }
                    }
                    
                }
            )
            .store(in: &observers)

    }
    
    private func defaultParams() -> DataStreamGraphParameters {
        let key = "\(Self.dataStreamParamsKeyPrefix)_\(spec.name)"
        
        if let params: DataStreamGraphParameters = try? UserDefaults
            .standard
            .getCustomObject(forKey: key) { // load existing parameters for data stream
            
            return params
            
        } else { // setup defaults for data stream
            let params = DataStreamGraphParameters()
            
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
