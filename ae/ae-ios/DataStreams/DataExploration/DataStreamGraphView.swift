//
//  DataStreamGraphView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 9/29/22.
//

import SwiftUI
import FlexiBLE
import Combine

struct DataStreamGraphView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var vm: DataStreamGraphViewModel
    @State var isParametersPresented: Bool = false
    
    var body: some View {
        VStack {
            switch vm.state {
            case .loading:
                ZStack {
                    VStack {
                        Spacer()
                        ProgressView().progressViewStyle(.circular)
                        Spacer()
                    }
                    ChartControls(vm: vm)
                }
            case .graphing:
                ZStack {
                    DataStreamChartView(vm: vm)
                    ChartControls(vm: vm)
                }
            case .noRecords:
                ZStack {
                    VStack {
                        Spacer()
                        Text("No Records Found")
                        Spacer()
                    }
                    ChartControls(vm: vm)
                }
            case .error(let msg):
                ZStack {
                    VStack {
                        Spacer()
                        Text("⚠️ error: \(msg)")
                        Spacer()
                    }
                    ChartControls(vm: vm)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("\(vm.spec.name.capitalized) Plot")
        .toolbar(content: {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button(action: {
                    vm.editingParameters()
                    isParametersPresented.toggle()
                }) {
                    Image(systemName: "slider.vertical.3")
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    vm.stop()
                    dismiss()
                }) {
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
                        vm: DataStreamGraphParamsViewModel(dsParams: vm.dataStreamParameters, dataStream: vm.spec)
                    )
                }
            }
        )
    }
}
