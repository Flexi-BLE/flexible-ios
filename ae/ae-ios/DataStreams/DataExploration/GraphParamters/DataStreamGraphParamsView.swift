//
//  DataStreamGraphParamsView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 9/29/22.
//

import SwiftUI
import FlexiBLE

struct DataStreamGraphParamsView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var vm: DataStreamGraphParamsViewModel
    
    @State var dependendSelectionPopover: Bool = false
    
    var body: some View {
        VStack {
            Text("\(vm.spec.name.capitalized) Graph Parameters")
                .font(.title2)
                .padding()
            List {
                HStack {
                    Text("Live:").bold()
                    Spacer()
                    Toggle(isOn: $vm.isLive) {
                        Text("Live")
                    }
                    .labelsHidden()
                }
                
                Section("Time Series") {
                    switch vm.isLive {
                    case true:
                        VStack {
                            HStack {
                                Text("Graph View:").bold()
                                Spacer()
                                Text("\(vm.model.liveInterval.uiReadable(precision: 0)) seconds")
                            }
                            Slider(value: $vm.model.liveInterval, in: 5...120, step: 5)
                        }
                    case false:
                        HStack {
                            Text("Start Date:").bold()
                            Spacer()
                            DatePicker(
                                "",
                                selection: $vm.model.start,
                                displayedComponents: [.date,.hourAndMinute]
                            )
                            .datePickerStyle(.compact)
                            .labelsHidden()
                        }
                        HStack {
                            Text("End Date:").bold()
                            Spacer()
                            DatePicker(
                                "",
                                selection: $vm.model.end,
                                displayedComponents: [.date,.hourAndMinute]
                            )
                            .datePickerStyle(.compact)
                            .labelsHidden()
                        }
                    }
                }
                
                if vm.dependentOptions.count > 0 {
                    Section("Dependent Variables") {
                        ForEach(vm.dependentOptions, id: \.name) { option in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("\(option.name)").bold()
                                    Spacer()
                                    Button {
                                        dependendSelectionPopover = true
                                    } label: {
                                        Text("Select")
                                    }.popover(isPresented: $dependendSelectionPopover) {
                                        MultiSelectionView(
                                            title: option.name,
                                            selections: vm.dependentSelections[option.name] ?? [],
                                            options: option.valueOptions ?? [],
                                            didSelect: { vm.dependentSelections[option.name]?.append($0) },
                                            didDeselect: { opt in vm.dependentSelections[option.name]?.removeAll(where: { $0 == opt }) }
                                        )
                                    }
                                }
                                if (vm.dependentSelections[option.name] ?? []).count > 0 {
                                    Divider()
                                    Text("\((vm.dependentSelections[option.name] ?? []).joined(separator: ", "))")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
                
                Section("Independent Variables") {
                    ForEach(vm.independentOptions, id: \.name) { option in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(option.name)")
                                if let dependsOn = option.dependsOn, dependsOn.count > 0 {
                                    Text("Depends on: \(dependsOn.joined(separator: ", "))")
                                        .foregroundColor(.gray)
                                }
                            }
                            Spacer()
                            if vm.independentSelections.contains(option.name) {
                                Image(systemName: "checkmark.circle.fill")
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if vm.independentSelections.contains(option.name) {
                                vm.independentSelections.removeAll(where: { $0 == option.name })
                            } else {
                                vm.independentSelections.append(option.name)
                            }
                        }
                    }
                }
                
                Button(
                    action: {
                        dismiss()
                    },
                    label: { Text("Apply Parameters") }
                )
            }
        }
    }
}

struct DataStreamGraphParamsView_Previews: PreviewProvider {
    static var previews: some View {
        DataStreamGraphParamsView(
            vm: DataStreamGraphParamsViewModel(
                with: DataStreamGraphParameters(),
                dataStream: FXBSpec.mock.devices[0].dataStreams[0]
            )
        )
    }
}
