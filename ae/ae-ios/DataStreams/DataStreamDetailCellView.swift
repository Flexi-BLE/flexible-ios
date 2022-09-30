//
//  DataStreamDetailCellView.swift
//  ae
//
//  Created by blaine on 4/26/22.
//

import SwiftUI
import FlexiBLE

struct DataStreamDetailCellView: View {
    @StateObject var vm: AEDataStreamViewModel
    @State private var dataExplorePopover = false
    @State private var editConfigPopover = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(vm.dataStream.name)")
                        .font(.title2)
                    
                    Text("\(vm.dataStream.description ?? "")")
                        .lineLimit(0)
                        .font(.body)
                }
                Spacer()
                if vm.isActive {
                    Toggle("Enabled", isOn: $vm.isOn)
                        .toggleStyle(.switch)
                        .labelsHidden()
                }
            }
                
            
            Divider()
            
            KeyValueView(key: "Number of Records", value: "\(vm.recordCount.fuzzy)")
            KeyValueView(key: "Data Frequency", value: "\(vm.frequency.uiReadable())Hz")
            if let rel = vm.reliability {
                KeyValueView(key: "Data Reliability", value: "\((rel * 100.0).uiReadable())%")
            }
            
            HStack {
                FXBButton(action: { dataExplorePopover.toggle() }) {
                    Text("View Data")
                }
                .fullScreenCover(isPresented: $dataExplorePopover) {
                    NavigationView {
                        DataStreamDataView(vm: vm)
                    }
                }
                Spacer()
            }
            
            if vm.isActive {
                Divider()
                
                ForEach(vm.configVMs, id: \.config.name) { configVM in
                    ConfigValueView(vm: configVM)
                }
                HStack {
                    FXBButton(action: {editConfigPopover.toggle()}) {
                        Text("Edit Parameters")
                    }
//                    .disabled(!(vm.deviceVM?.device.specMatched ?? false))
                    .fullScreenCover(isPresented: $editConfigPopover) {
                        NavigationView {
                            ConfigEditView(vm: vm)
                        }
                    }
                    Spacer()
                }
            }
        }
        .padding()
        .onAppear() { vm.checkActive() }
    }
}
