//
//  DataStreamDetailCellView.swift
//  ae
//
//  Created by blaine on 4/26/22.
//

import SwiftUI
import Combine
import FlexiBLE

struct DataStreamDetailCellView: View {
    @ObservedObject var vm: AEDataStreamViewModel
    
    @State var editConfigPopover: Bool = false
    @State var dataExplorerPopover: Bool = false
    @State var uploadRecordsPopover: Bool = false
    @State private var isEnabled: Bool = false
    
    var enabledObs: AnyCancellable?
    
    var body: some View {
        VStack(alignment: .leading) {
            
            switch vm.state {
            case .loading:
                HStack {
                    VStack(alignment: .leading) {
                        Text("Loading Data \(vm.dataStream.name)")
                            .font(.title2)
                        Text("Please wait ...")
                    }
                    Spacer()
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            case .error(let msg):
                Text("Error: \(msg)")
                    .font(.title2)
            case .connected:
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(vm.dataStream.name)")
                            .font(.title2)
                        
                        Text("\(vm.dataStream.description ?? "")")
                            .lineLimit(0)
                            .font(.body)
                    }
                    Spacer()

                    if vm.hasConfigurations {
                        Toggle("Enabled", isOn: $vm.isOn)
                            .toggleStyle(.switch)
                            .labelsHidden()
                    }
                }
                    
                
                Divider()
                
                KeyValueView(key: "Number of Records", value: "\(vm.recordCount?.formatted() ?? "...")")
                
                if vm.hasVariableFrequency, let frequency = vm.frequency {
                    KeyValueView(key: "Data Frequency", value: "\(frequency.uiReadable())Hz")
                    if let rel = vm.reliability {
                        KeyValueView(key: "Data Reliability", value: "\((rel * 100.0).uiReadable())%")
                    }
                }
                
                if let device = vm.deviceVM?.device {
                    Divider()
                    
                    ForEach(vm.configVMs, id: \.config.name) { configVM in
                        ConfigValueView(vm: configVM)
                    }
                    HStack {
                        FXBButton(action: { uploadRecordsPopover.toggle() }) {
                            Text("View Upload Records")
                        }
                        .fullScreenCover(isPresented: $uploadRecordsPopover) {
                            NavigationView {
                                FullScreenModal {
                                    UploadRecordsView(
                                        vm: UploadRecordsViewModel(dataStream: vm.dataStream.name)
                                    )
                                }
                            }
                        }
                        Spacer()
                        if vm.hasConfigurations {
                            FXBButton(action: { editConfigPopover.toggle() }) {
                                Text("Edit Parameters")
                            }
                            .fullScreenCover(isPresented: $editConfigPopover) {
                                NavigationView {
                                    ConfigEditView(vm: vm)
                                }
                            }
                        }
                        FXBButton(action: { dataExplorerPopover.toggle() }) {
                            Text("View Graph")
                        }
                        .fullScreenCover(isPresented: $dataExplorerPopover) {
                            NavigationView {
                                DataStreamGraphView(
                                    vm: DataStreamGraphViewModel(
                                        dataStream: vm.dataStream,
                                        deviceName: device.deviceName
                                    )
                                )
                            }
                        }
                        .fullScreenCover(isPresented: $editConfigPopover) {
                            NavigationView {
                                ConfigEditView(vm: vm)
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
}
