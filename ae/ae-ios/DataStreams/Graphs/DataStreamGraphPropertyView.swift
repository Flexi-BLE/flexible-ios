//
//  DataStreamGraphPropertyView.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 9/2/22.
//

import SwiftUI
import FlexiBLE

struct DataStreamGraphPropertyView: View {
    @StateObject var propertyVM: DataExplorerGraphPropertyViewModel
    var onConfigurationSelected: (() -> Void)?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 13.0) {
                HStack {
                    Text("Configure Graph Parameters")
                        .bold()
                        .font(.title2)
                    Spacer()
                }
                HStack {
//                    Text("Currently -: \(propertyVM.getCurrentConfigLabel())")
                    Spacer()
                }
                
                List {
                    
                    Section(header: Text("Graph")) {
                        Picker("Graph View", selection: $propertyVM.visualModel.graphState) {
                            ForEach(GraphVisualStateInfo.allCases) {
                                Text($0.rawValue).tag($0)
                            }
                        }
                    }
                    
                    switch propertyVM.visualModel.graphState {
                    case .live:
                        Section(header: Text("Live Interval")) {
                            VStack {
                                Slider(value: $propertyVM.visualModel.liveInterval, in: 5...90, step: 5)
                                Text("\(propertyVM.visualModel.liveInterval)")
                            }
                        }
                    case .highlights:
                        EmptyView()
                    }
                    
                    
                    
                    if propertyVM.variableModel.propertyDict.keys.count != 0, !propertyVM.variableModel.supportedProperty.isEmpty {
                        Section(header: Text("Property Options")) {
                            Picker("Property to select:", selection: $propertyVM.variableModel.selectedProperty) {
                                ForEach(propertyVM.variableModel.supportedProperty) { property in
                                    Text(property).tag(property as String?)
                                }
                            }
                        }
                        
                        Section(header: Text("Property Values")) {
                            ForEach(propertyVM.variableModel.propertyDict.keys.sorted(), id: \.self) { key in
                                NavigationLink(destination: {
                                    GraphParameterValueSelectionView(vm: propertyVM.variableModel.propertyDict[key] ?? [])
                                }, label: {
                                    Text(key)
                                })
                            }
                        }
                    }
                    
                    Section(header: Text("Readings Values")) {
                        ForEach(propertyVM.variableModel.supportedReadings, id: \.value) { reading in
                            FXBCheckboxEntry(vm: reading)
                        }
                    }
                    
                    Section(header: Text("Range Filters")) {
                        VStack {
                            HStack {
                                Text("Enable Timestamp Filters")
                                Spacer()
                                Toggle("Show welcome message", isOn: $propertyVM.visualModel.shouldFilterByTimestamp)
                                    .labelsHidden()
                            }
                            if propertyVM.visualModel.shouldFilterByTimestamp {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Start")
                                            .bold()
                                        Spacer()
                                        DatePicker("", selection: $propertyVM.visualModel.startTimestamp,displayedComponents: [.date,.hourAndMinute])
                                            .datePickerStyle(.compact)
                                            .labelsHidden()
                                    }

                                    HStack {
                                        Text("End")
                                            .bold()
                                        Spacer()
                                        DatePicker("", selection: $propertyVM.visualModel.endTimestamp,displayedComponents: [.date,.hourAndMinute])
                                            .datePickerStyle(.compact)
                                            .labelsHidden()
                                    }
                                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                            }
                            
                            HStack {
                                Text("Enable Range filters ")
                                Spacer()
                                Toggle("Show welcome message", isOn: $propertyVM.visualModel.shouldFilterByYAxisRange)
                                    .labelsHidden()
                            }
                            if propertyVM.visualModel.shouldFilterByYAxisRange {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Min Y-axis Value").bold()
                                        TextField("Min Y-axis Value", text: $propertyVM.visualModel.userYMin)
                                            .textFieldStyle(.roundedBorder)
                                            .keyboardType(.default)
                                    }
                                    HStack {
                                        Text("Max Y-axis Value").bold()
                                        TextField("Max Y-axis Value", text: $propertyVM.visualModel.userYMax)
                                            .textFieldStyle(.roundedBorder)
                                            .keyboardType(.default)
//                                            .toolbar(content: {
//                                                ToolbarItem(placement: .keyboard) {
//                                                    Button("+/-") {
//                                                        propertyVM.visualModel.toggleUserMaxYSign()
//                                                    }
//                                                }
//                                            })
                                    }
                                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                            }
                        }
                    }
                    
                    Section(header: Text("Options")) {
                        Button("Apply Configurations", action: {
                            propertyVM.saveSelectedConfigurationForGraph()
                            onConfigurationSelected?()
                            dismiss()
                        })
                    }
                }
                .listStyle(.inset)
            }
            .padding()
        }
//        .onAppear() {
//            Task {
//                await propertyVM.parsePropertyAndReadingsFromStream()
//            }
//        }
    }
}


struct DataStreamGraphPropertyView_Previews: PreviewProvider {
    static var previews: some View {
        let ds = FXBSpec.mock.devices[0].dataStreams[1]
        let vmNK = DataExplorerGraphPropertyViewModel(dataStream: ds)
        DataStreamGraphPropertyView(propertyVM: vmNK)
    }
}
