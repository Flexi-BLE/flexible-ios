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
    
    var body: some View {
        
        if let range = vm.config.range {
            VStack(alignment: .leading) {
                
                Text(vm.config.name)
                    .bold()
                    .font(.title3)
                Text(vm.config.description)
                
                Spacer().frame(width: 16.0)
                
                HStack {
                    Spacer()
                    Text("\(String(format: "%.0f", vm.selectedRangeValue)) \(vm.config.unit ?? "")")
                    Spacer()
                }
                
                Slider(
                    value: $vm.selectedRangeValue,
                    in: Double(range.start)...Double(range.end),
                    step: Double(range.step),
                    minimumValueLabel: Text("\(range.start)"),
                    maximumValueLabel: Text("\(range.end)"),
                    label: { Text("Config Slider") }
                )
            }
        }
    }
}

struct ConfigRangeEditView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigRangeEditView(
            vm: ConfigViewModel(config: FXBSpec.mock.devices[0].dataStreams[0].configValues[0])
        )
    }
}
