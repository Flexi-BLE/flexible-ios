//
//  DataStreamGraphView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 9/29/22.
//

import SwiftUI
import FlexiBLE
import Combine

class DataStreamGraphParameters: Codable {
    enum State: String, Codable {
        case live
        case timeboxed
        case unspecified
    }
    
    var state: State = .unspecified
    
    var filterSelections: [String:[Int]] = [:]
    
    var dependentSelections: [String] = []
    
    var liveInterval: TimeInterval = 25.0
    var start: Date = Date.now
    var end: Date = Date.now.addingTimeInterval(-25.0)
}

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
    
    typealias Point = (y: Date, x: Double)
    // map by line (e.g. blue-green) and point
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
        case .live: liveFeed()
        case .timeboxed: queryData()
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
            .compactMap({ [weak self] record -> DataStreamHandler.RawDataStreamRecord? in // filter by tag selections
                guard let self = self, record.values.count == self.dataStream.dataValues.count else { return nil }

                var incl = true
                for (i, ds) in self.dataStream.dataValues.enumerated() {
                    switch ds.variableType {
                    case .tag:
                        if let val = record.values[i] as? Int,
                           let selections = params.filterSelections[ds.name],
                           selections.count > 0,
                           !selections.contains(val) {

                            incl = false
                        }
                    default: break
                    }
                }

                return incl ? record : nil
            })
            .collect(Publishers.TimeGroupingStrategy.byTime(DispatchQueue.main, 0.25))
            .sink(receiveValue: { [weak self] records in // organize in to points by tags
                guard let ds = self?.dataStream else { return }
                
                var data = [String: [Point]]()
                
//                records.forEach({ record in
//                    for (i, val) in record.values?.enumerated() {
//                        let dv = ds.dataValues[i]
//                        guard params.dependentSelections.contains(dv.name) else { continue }
//
//                        if dv.variableType = .value {
//                            for dependent in dv.dependsOn {
//
//                            }
//                        }
//                    }
//                })
                
                print("🔥 live records streamed: \(records.count)")
            })
    }
    
    private func queryData() {
        // TODO: query database and filter
    }
}

@MainActor class DataStreamGraphViewModel: ObservableObject {
    enum State {
        case loading
        case graphing
        case error(msg: String)
    }
    
    var state: State = .loading
    var deviceName: String
    var spec: FXBDataStream
    var parameters: DataStreamGraphParameters
    
    var dataService: DataStreamDataService
    
    @Published var data: [DataStreamHandler.RawDataStreamRecord] = []
    
    private var observers = Set<AnyCancellable>()
    
    init(dataStream: FXBDataStream, deviceName: String) {
        self.deviceName = deviceName
        self.spec = dataStream
        self.dataService = DataStreamDataService(dataStream: dataStream, deviceName: deviceName)
        
        // TODO: load from disk
        self.parameters = DataStreamGraphParameters()
        
        subscribe()
    }
    
    func parametersUpdated() {
        state = .loading
        dataService.set(params: self.parameters)
    }
    
    private func subscribe() {
        
    }
    
}

struct DataStreamGraphView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var vm: DataStreamGraphViewModel
    @State var isParametersPresented: Bool = false
    
    var body: some View {
        VStack {
            switch vm.state {
            case .loading:
                Spacer()
                ProgressView().progressViewStyle(.circular)
                Spacer()
            case .graphing:
                Text("I am graph")
            case .error(let msg):
                Spacer()
                Text("⚠️ error: \(msg)")
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("\(vm.spec.name.capitalized) Plot")
        .toolbar(content: {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button(action: {
                    vm.state = .loading
                    isParametersPresented.toggle()
                }) {
                    Image(systemName: "slider.vertical.3")
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                }
            }
        })
        .fullScreenCover(
            isPresented: $isParametersPresented,
            onDismiss: { vm.parametersUpdated() },
            content: {
                NavigationView {
                    DataStreamGraphParamsView(
                        vm: DataStreamGraphParamsViewModel(with: vm.parameters, dataStream: vm.spec)
                    )
                }
            }
        )
//        .sheet(
//            isPresented: $isParametersPresented,
//            onDismiss: { isParametersPresented = false },
//            content: {
//                DataStreamGraphParamsView(
//                    vm: DataStreamGraphParamsViewModel(with: vm.parameters, dataStream: vm.spec)
//                )
//                .presentationDragIndicator(.visible)
//            }
//        )
    }
}
