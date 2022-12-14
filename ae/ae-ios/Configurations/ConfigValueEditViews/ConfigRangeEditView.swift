//
//  ConfigRangeEditView.swift
//  ae-ios
//
//  Created by blaine on 7/20/22.
//

import SwiftUI
import FlexiBLE

struct ConfigRangeEditView: View {
    @StateObject var vm: ConfigViewModel
    @State var textInputValue: String
    
    var body: some View {
        
        if let range = vm.config.range {
            VStack(alignment: .leading) {
                
                Text(vm.config.name)
                    .bold()
                    .font(.title3)
                Text(vm.config.description)
                
                Spacer().frame(height: 16.0)
                
                HStack {
                    Spacer()
                    TextField(
                        "\(vm.config.name)",
                        text: $textInputValue,
                        onEditingChanged: { isEditing in
                            if !isEditing {
                                if let v = Int(textInputValue),
                                   v <= Int(range.end),
                                   v >= Int(range.start) {
                                    
                                    vm.selectedRangeValue = Double(v)
                                } else {
                                    textInputValue = vm.selectedValue
                                }
                            }
                        }
                    )
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.default)
                    if let unit = vm.config.unit { Text("\(unit)") }
                    Spacer()
                }
                
                Slider(
                    value: $vm.selectedRangeValue,
                    in: Double(range.start)...Double(range.end),
                    step: Double(range.step),
                    minimumValueLabel: Text("\(range.start)"),
                    maximumValueLabel: Text("\(range.end)"),
                    label: { Text("Config Slider") }
                ).onChange(of: vm.selectedRangeValue) { newValue in
                    self.textInputValue = String(Int(newValue))
                }
            }
        }
    }
}
