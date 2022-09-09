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
    @State private var presentYMinAlert = false
    @State private var presentYMaxAlert = false
    @State private var selectedAnimal = GraphVisualStateInfo.live
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
                    case .parameterized:
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
                    
                    Section(header: Text("Timestamp Filters")) {
                        VStack {
                            HStack {
                                Text("Enable Range Filters")
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
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Readings Range Filters")) {

                        HStack {
                            Text("Enable Range filters ")
                            Spacer()
                            Toggle("Show welcome message", isOn: $propertyVM.visualModel.shouldFilterByYAxisRange)
                                .labelsHidden()
                        }
                        if propertyVM.visualModel.shouldFilterByYAxisRange {
                            HStack {
                                Button("Minimum value") {
                                    presentYMinAlert = true
                                }
                                .alert("Y-Axis Minimum value", isPresented: $presentYMinAlert, actions: {
                                    TextField("Y-min value", text: $propertyVM.visualModel.userYMin)
                                        .keyboardType(.numbersAndPunctuation)
                                }, message: {
                                    Text("Enter the Y-axis minimum value for the graph.")
                                })
                                Spacer()
                                Text(propertyVM.visualModel.userYMin)
                            }
                            HStack {
                                Button("Maximum value") {
                                    presentYMaxAlert = true
                                }
                                .alert("Y-Axis Maximum value", isPresented: $presentYMaxAlert, actions: {
                                    TextField("Y-max value", text: $propertyVM.visualModel.userYMax)
                                        .keyboardType(.numbersAndPunctuation)

                                }, message: {
                                    Text("Enter the Y-axis maximum value for the graph.")
                                })
                                Spacer()
                                Text(propertyVM.visualModel.userYMax)
                            }
                        }
                    }
                    
                    Section(header: Text("Options")) {
                        Button("Apply Configurations", action: {
//                            propertyVM.checkAndRetrieveUserDefaults()
                            //                            propertyVM.saveInUserDefault(storeObject: propertyVM)
                            dismiss()
                        })
                    }
                }
                .listStyle(.inset)
            }
            .padding()
        }
    }
}


struct DataStreamGraphPropertyView_Previews: PreviewProvider {
    static var previews: some View {
        let ds = FXBSpec.mock.devices[0].dataStreams[1]
        let vmNK = DataExplorerGraphPropertyViewModel(dataStream: ds)
        DataStreamGraphPropertyView(propertyVM: vmNK)
    }
}
