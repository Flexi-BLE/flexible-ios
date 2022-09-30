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
    
    @State var editConfigPopover: Bool = false
    @State var dataExplorerPopover: Bool = false
    
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
            
            if vm.isActive, let device = vm.deviceVM?.device {
                Divider()
                
                ForEach(vm.configVMs, id: \.config.name) { configVM in
                    ConfigValueView(vm: configVM)
                }
                HStack {
                    FXBButton(action: { editConfigPopover.toggle() }) {
                        Text("Edit Parameters")
                    }
                    .fullScreenCover(isPresented: $editConfigPopover) {
                        NavigationView {
                            ConfigEditView(vm: vm)
                        }
                    }
                    Spacer()
                    FXBButton(action: { dataExplorerPopover.toggle() }) {
                        Text("View Graph")
                    }
                    .fullScreenCover(isPresented: $dataExplorerPopover) {
                        NavigationView {
                            DataStreamGraphView(
                                vm: DataStreamGraphViewModel(
                                    device: device,
                                    dataStream: vm.dataStream
                                )
                            )
                        }
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
