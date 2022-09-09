//
//  DataStreamGraphVisualizerView.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 9/2/22.
//

import SwiftUI
import Charts

struct DataStreamGraphVisualizerView: View {
    @StateObject var vm: AEDataStreamViewModel
    @StateObject var graphPropertyVM: DataExplorerGraphPropertyViewModel
    @State var databaseResults: [(mark: String, data: [(ts: Date, val: Double)])] = []
    @State var presentSheet = true
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
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
            .sheet(isPresented: $presentSheet) {
                DataStreamGraphPropertyView(propertyVM: graphPropertyVM, onConfigurationSelected: {
                    Task {
                        self.databaseResults = await vm.fetchDatabaseValuesForGraph(graphProperty: graphPropertyVM)
                    }
                })
                .presentationDetents([.fraction(0.15), .large])
                .presentationDragIndicator(.visible)
                //                .interactiveDismissDisabled()
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrowshape.backward.fill")
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            self.databaseResults = await vm.fetchDatabaseValuesForGraph(graphProperty: graphPropertyVM)
                        }
                    }) {
                        Image(systemName: "circle.hexagonpath")
                    }
                    Button(action: {
                        presentSheet.toggle()
                    }) {
                        Image(systemName: "slider.vertical.3")
                    }
                }
            })
        }
    }
}
