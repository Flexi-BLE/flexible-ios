//
//  DataStreamGraphVisualizerView.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 9/2/22.
//

import SwiftUI
import Charts
import Combine

struct DataStreamGraphVisualizerView: View {
    @StateObject var vm: AEDataStreamViewModel
    @StateObject var graphPropertyVM: DataExplorerGraphPropertyViewModel
    @State var databaseResults: [(mark: String, data: [(ts: Date, val: Double)])] = []
    @State var presentSheet = false
    
    var timer: Publishers.Autoconnect<Timer.TimerPublisher> = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    ).autoconnect()
    
    var body: some View {
        VStack {
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
            .chartYScale(domain: graphPropertyVM.getYMin() ... graphPropertyVM.getYMax())
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
                        .foregroundStyle(.black)
                    AxisValueLabel(horizontalSpacing: 5.0)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
        .sheet(isPresented: $presentSheet, onDismiss: {
            presentSheet = false
        }, content: {
            DataStreamGraphPropertyView(propertyVM: graphPropertyVM, onConfigurationSelected: {
                Task {
                    self.databaseResults = await vm.fetchDatabaseValuesForGraph(graphProperty: graphPropertyVM)
                }
            })
            .presentationDetents([.fraction(0.15), .large])
            .presentationDragIndicator(.visible)
        })
        .toolbar(content: {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    presentSheet = true
                }) {
                    HStack {
                        Text("Edit")
                        Image(systemName: "slider.vertical.3")
                    }
                }
            }
        })
        .onReceive(timer) { _ in
            Task {
                if graphPropertyVM.shouldReloadGraphData {
                    graphPropertyVM.shouldReloadGraphData = false
                    self.databaseResults = await vm.fetchDatabaseValuesForGraph(graphProperty: graphPropertyVM)
                }
                
                if graphPropertyVM.visualModel.graphState == .live {
                    self.databaseResults = await vm.fetchDatabaseValuesForGraph(graphProperty: graphPropertyVM)
                }
            }
        }
    }
}
