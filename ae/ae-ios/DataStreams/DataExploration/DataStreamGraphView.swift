//
//  DataStreamGraphView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 9/29/22.
//

import SwiftUI
import FlexiBLE
import Combine

class DataStreamGraphParameters {
    enum State {
        case live
        case timeboxed
        case unspecified
    }
    
    var state: State = .unspecified
    
    var dependentSelections: [String:[String]] = [:]
    
    var independentSelections: [String] = []
    
    var liveInterval: TimeInterval = 25.0
    var start: Date = Date.now
    var end: Date = Date.now.addingTimeInterval(-25.0)
    
    var minY: Double = 0.0
    var minX: Double = 0.0
}

class DataStreamDataService {
    var dataStream: FXBDataStream
    var parameters: DataStreamGraphParameters?
    
    typealias Point = (y: Date, x: Double)
    var data = PassthroughSubject<[String:[Point]], Never>()
    
    private var observers = Set<AnyCancellable>()
    
    init(with dataStream: FXBDataStream) {
        self.dataStream = dataStream
    }
    
    func set(params: DataStreamGraphParameters) {
        self.parameters = params
        self.driver()
    }
    
    private func driver() {
        guard let params = self.parameters else { return }
        
        // TODO: swap settings
    }
    
    private func kickOffLiveFeed() {
        // TODO: subscribe to firehose and filter
    }
    
    private func queryData() {
        // TODO: query database and filter
    }
}

@MainActor class DataStreamGraphViewModel: ObservableObject {
    var device: FXBDevice
    var spec: FXBDataStream
    var parameters: DataStreamGraphParameters
    
    var dataService: DataStreamDataService
    
    @Published var data: [DataStreamHandler.RawDataStreamRecord] = []
    
    private var observers = Set<AnyCancellable>()
    
    init(device: FXBDevice, dataStream: FXBDataStream) {
        self.device = device
        self.spec = dataStream
        self.dataService = DataStreamDataService(with: dataStream)
        
        // TODO: load from disk
        self.parameters = DataStreamGraphParameters()
        
        subscribe()
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
            switch vm.parameters.state {
            case .unspecified:
                Text("No Parameters Specified")
            case .live, .timeboxed where !isParametersPresented:
                Text("Should be some data")
            default:
                Text("Loading")
            }
        }
        .toolbar(content: {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button(action: {
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
        .sheet(
            isPresented: $isParametersPresented,
            onDismiss: { isParametersPresented = false },
            content: {
                DataStreamGraphParamsView(
                    vm: DataStreamGraphParamsViewModel(with: vm.parameters, dataStream: vm.spec)
                )
            }
        ).presentationDragIndicator(.visible)
    }
}
