//
//  DataStreamGraphVisualizerView.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 9/2/22.
//

import SwiftUI
import Charts
import Combine
import FlexiBLE

struct DataStreamGraphVisualizerView: View {
    @StateObject var vm: DataStreamGraphVisualizerViewModel
    @StateObject var graphPropertyVM: DataExplorerGraphPropertyViewModel
    
    @State var databaseResults: [(mark: String, data: [(ts: Date, val: Double)])] = []
    @State var presentSheet = false
    
    var timer: Publishers.Autoconnect<Timer.TimerPublisher> = Timer.publish(
        every: 0.25,
        on: .main,
        in: .common
    ).autoconnect()
    
    var body: some View {
        VStack {
            switch vm.state {
            case.loading:
                ProgressView()
            
            case .graphing:
                Chart {
                    ForEach(self.databaseResults, id: \.mark) { series in
                        ForEach(series.data, id: \.ts) {
                            LineMark(
                                x: .value("Time", $0.ts),
                                y: .value("Value", $0.val)
                            )
                        }
                        .foregroundStyle(by: .value("mark", series.mark))
                    }
                }
                .chartYScale(domain: graphPropertyVM.getGraphRange())
                .chartYAxis {
                    AxisMarks(preset: .extended, position: .leading) { value in
                        AxisGridLine()
                            .foregroundStyle(.gray)
                        AxisValueLabel()
                            .foregroundStyle(.black)
                    }
                }
                .chartXAxis {
                    AxisMarks(preset: .automatic, position: .bottom) { value in
                        AxisGridLine()
                            .foregroundStyle(.clear)
                        if UIDevice.current.orientation == .landscapeRight {
                            AxisValueLabel(horizontalSpacing: 5.0)
                        }
                    }
                }
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .padding()

            case .editing:
                EmptyView()
            case .error(let errMsg):
                VStack {
                    Spacer()
                    Text("⚠️ Error: \(errMsg)")
                    Spacer()
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .sheet(isPresented: $presentSheet, onDismiss: {
            presentSheet = false
        }, content: {
            DataStreamGraphPropertyView(propertyVM: graphPropertyVM, onConfigurationSelected: {
                Task {
                    self.databaseResults = await vm.fetchDatabaseValuesForGraph(graphProperty: graphPropertyVM)
                    vm.state = .graphing
//                    UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                }
            })
            .presentationDragIndicator(.visible)
        })
        .toolbar(content: {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    vm.state = .editing
                    presentSheet.toggle()
                }) {
                   Image(systemName: "slider.vertical.3")
                }
            }
        })
        .onReceive(timer) { _ in
            guard !presentSheet else { return }
            Task {
                if graphPropertyVM.shouldReloadGraphData {
                    graphPropertyVM.shouldReloadGraphData = false
                    self.databaseResults = await vm.fetchDatabaseValuesForGraph(graphProperty: graphPropertyVM)
                    vm.state = .graphing
//                    UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                }
                
                if graphPropertyVM.visualModel.graphState == .live {
                    self.databaseResults = await vm.fetchDatabaseValuesForGraph(graphProperty: graphPropertyVM)
                    vm.state = .graphing
//                    UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                }
            }
        }
    }
}
