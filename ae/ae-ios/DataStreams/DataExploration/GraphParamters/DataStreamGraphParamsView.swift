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
                                }
                                .fullScreenCover(isPresented: $dependendSelectionPopover) {
                                    MultiSelectionView(
                                        title: option.name,
                                        selections: vm.readabletagSelections(for: option.name),
                                        options: vm.readableOptions(for: option.name),
                                        didSelect: { vm.selectFilterOption(value: option, option: $0) },
                                        didDeselect: { vm.deselectFilterOption(value: option, option: $0) }
                                    )
                                }
                            }
                            if (vm.tagSelections[option.name] ?? []).count > 0 {
                                Divider()
                                Text("\(vm.readabletagSelections(for: option.name).joined(separator: ", "))")
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
                dsParams: DataStreamChartParameters(),
                dataStream: FXBSpec.mock.devices[0].dataStreams[0]
            )
        )
    }
}
