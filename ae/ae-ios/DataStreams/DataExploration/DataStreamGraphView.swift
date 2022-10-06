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
                Spacer()
                ProgressView().progressViewStyle(.circular)
                Spacer()
            case .graphing:
                DataStreamChartView(vm: vm)
            case .noRecords:
                Spacer()
                Text("No Records Found")
                Spacer()
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
                    vm.editingParameters()
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
    }
}
