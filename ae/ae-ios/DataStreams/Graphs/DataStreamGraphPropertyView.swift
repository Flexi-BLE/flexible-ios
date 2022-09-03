//
//  DataStreamGraphPropertyView.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 9/2/22.
//

import SwiftUI

struct DataStreamGraphPropertyView: View {
    @StateObject var propertyVM: DataExplorerGraphPropertyViewModel
    @State private var presentYMinAlert = false
    @State private var presentYMaxAlert = false
    
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
                    Text("Currently -: \(propertyVM.getCurrentConfigLabel())")
                    Spacer()
                }
                
                List {
                    if propertyVM.propertyDict.keys.count != 0 {
                        Section(header: Text("Property Options")) {
                            Picker("Property to select:", selection: $propertyVM.selectedProperty) {
                                ForEach(propertyVM.supportedProperty ?? [], id: \.self) { property in
                                    Text(property).tag(property)
                                }
                            }
                        }
                        Section(header: Text("Property Values")) {
                            ForEach(propertyVM.propertyDict.keys.sorted(), id: \.self) { key in
                                NavigationLink(
                                    destination: GraphParameterValueSelectionView(vm: DataValueOptionsListModel(withValues: propertyVM.propertyDict[key]?.values ?? [])),
                                    label: {
                                        Text(key)
                                    }
                                )
                            }
                        }
                    }
                    
                    Section(header: Text("Readings Values")) {
                        ForEach(propertyVM.supportedReading.values, id: \.id) { reading in
                            FXBCheckboxEntry(vm: reading)
                        }
                    }
                    
                    Section(header: Text("Timestamp Range Filters")) {
                        VStack {
                            HStack {
                                Text("X-axis enabled ?")
                                Spacer()
                                Toggle("Show welcome message", isOn: $propertyVM.shouldFilterByTimestamp)
                                    .labelsHidden()
                            }
                            if propertyVM.shouldFilterByTimestamp {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Start")
                                            .bold()
                                        Spacer()
                                        DatePicker("", selection: $propertyVM.startTimestamp,displayedComponents: [.date,.hourAndMinute])
                                            .datePickerStyle(.compact)
                                            .labelsHidden()
                                    }
                                    
                                    HStack {
                                        Text("End")
                                            .bold()
                                        Spacer()
                                        DatePicker("", selection: $propertyVM.endTimestamp,displayedComponents: [.date,.hourAndMinute])
                                            .datePickerStyle(.compact)
                                            .labelsHidden()
                                    }
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Y-Axis Range Filters")) {
                        
                        HStack {
                            Text("Y-axis enabled ?")
                            Spacer()
                            Toggle("Show welcome message", isOn: $propertyVM.shouldFilterByYAxisRange)
                                .labelsHidden()
                        }
                        if propertyVM.shouldFilterByYAxisRange {
                            HStack {
                                Button("Minimum value") {
                                    presentYMinAlert = true
                                }
                                .alert("Y-Axis Minimum value", isPresented: $presentYMinAlert, actions: {
                                    TextField("Y-min value", text: $propertyVM.userYMin)
                                        .keyboardType(.numbersAndPunctuation)
                                }, message: {
                                    Text("Enter the Y-axis minimum value for the graph.")
                                })
                                Spacer()
                                Text(propertyVM.userYMin)
                            }
                            HStack {
                                Button("Maximum value") {
                                    presentYMaxAlert = true
                                }
                                .alert("Y-Axis Maximum value", isPresented: $presentYMaxAlert, actions: {
                                    TextField("Y-max value", text: $propertyVM.userYMax)
                                        .keyboardType(.numbersAndPunctuation)
                                    
                                }, message: {
                                    Text("Enter the Y-axis maximum value for the graph.")
                                })
                                Spacer()
                                Text(propertyVM.userYMax)
                            }
                        }
                    }
                    
                    Section(header: Text("Options")) {
                        Button("Apply Configurations", action: {
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
