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
                            Text("\(vm.liveInterval.uiReadable(precision: 0)) seconds")
                        }
                        Slider(value: $vm.liveInterval, in: 5...120, step: 5)
                    }
                case false:
                    HStack {
                        Text("Start Date:").bold()
                        Spacer()
                        DatePicker(
                            "",
                            selection: $vm.start,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .datePickerStyle(.compact)
                        .labelsHidden()
                    }
                    HStack {
                        Text("End Date:").bold()
                        Spacer()
                        DatePicker(
                            "",
                            selection: $vm.end,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .datePickerStyle(.compact)
                        .labelsHidden()
                    }
                }
            }
            
            if vm.filterOptions.count > 0 {
                Section("Filter Variables") {
                    ForEach(vm.filterOptions, id: \.name) { option in
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
                                        selections: vm.readableFilterSelections(for: option.name),
                                        options: vm.readableOptions(for: option.name),
                                        didSelect: { vm.selectFilterOption(value: option, option: $0) },
                                        didDeselect: { vm.deselectFilterOption(value: option, option: $0) }
                                    )
                                }
                            }
                            if (vm.filterSelections[option.name] ?? []).count > 0 {
                                Divider()
                                Text("\(vm.readableFilterSelections(for: option.name).joined(separator: ", "))")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            
            Section("Dependent Variables") {
                ForEach(vm.dependentOptions, id: \.name) { option in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(option.name)")
                            if let dependsOn = option.dependsOn, dependsOn.count > 0 {
                                Text("Depends on: \(dependsOn.joined(separator: ", "))")
                                    .foregroundColor(.gray)
                            }
                        }
                        Spacer()
                        if vm.dependentSelections.contains(option.name) {
                            Image(systemName: "checkmark.circle.fill")
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if vm.dependentSelections.contains(option.name) {
                            vm.deselectDependentOption(option: option)
                        } else {
                            vm.selectDependentOption(option: option)
                        }
                    }
                }
            }
            
            Button(
                action: {
                    vm.save()
                    dismiss()
                },
                label: { Text("Apply Parameters") }
            )
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Edit \(vm.spec.name.capitalized) Parameters")
        .toolbar(content: {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    dismiss() // dismiss without saving
                }) {
                    Image(systemName: "xmark")
                }
            }
        })
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
