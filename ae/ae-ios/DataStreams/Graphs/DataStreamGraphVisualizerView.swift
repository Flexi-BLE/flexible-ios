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
    @Environment(\.dismiss) var dismiss
    
    @StateObject var vm: DataStreamGraphVisualizerViewModel
    @StateObject var graphPropertyVM: DataExplorerGraphPropertyViewModel
    
//    @State var databaseResults: [(mark: String, data: [(ts: Date, val: Double)])] = []
    @State var presentSheet = false
    
//    var timer: Publishers.Autoconnect<Timer.TimerPublisher> = Timer.publish(
//        every: 2,
//        on: .main,
//        in: .common
//    ).autoconnect()
    
    var body: some View {
        VStack {
            switch vm.state {
            case.loading:
                ProgressView()
                
            case .graphing:
                DataStreamChartsView(vm: vm, graphPropertyVM: graphPropertyVM)
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
        .toolbar(content: {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button(action: {
                    vm.state = .editing
                    presentSheet.toggle()
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
        .sheet(isPresented: $presentSheet, onDismiss: {
            presentSheet = false
        }, content: {
            DataStreamGraphPropertyView(propertyVM: graphPropertyVM, onConfigurationSelected: {
                Task {
                    await vm.fetchDBValuesForGraph(graphModel:graphPropertyVM)
//                    await vm.fetchDatabaseValuesForGraph(graphProperty: graphPropertyVM)
                    
//                    self.databaseResults = await vm.fetchDatabaseValuesForGraph(graphProperty: graphPropertyVM)
                    vm.state = .graphing
                }
            })
            .presentationDragIndicator(.visible)
        })
//        .onReceive(timer) { _ in
//            guard !presentSheet else { return }
//            Task {
//                await vm.fetchDBValuesForGraph(graphModel: graphPropertyVM)
////                if graphPropertyVM.shouldReloadGraphData {
////                    graphPropertyVM.shouldReloadGraphData = false
////                    await vm.fetchDatabaseValuesForGraph(graphProperty: graphPropertyVM)
////                    self.databaseResults = await vm.fetchDatabaseValuesForGraph(graphProperty: graphPropertyVM)
//                    vm.state = .graphing
////                }
//
////                if graphPropertyVM.visualModel.graphState == .live {
//////                    self.databaseResults = await vm.fetchDatabaseValuesForGraph(graphProperty: graphPropertyVM)
////                    await vm.fetchDatabaseValuesForGraph(graphProperty: graphPropertyVM)
////                    vm.state = .graphing
////                }
//            }
//        }
    }
}
