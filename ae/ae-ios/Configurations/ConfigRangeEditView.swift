//
//  ConfigRangeEditView.swift
//  ae-ios
//
//  Created by blaine on 7/20/22.
//

import SwiftUI
import aeble

struct ConfigRangeEditView: View {
    @StateObject var vm: ConfigViewModel
    
    var body: some View {
        
        if let range = vm.config.range {
            VStack(alignment: .leading) {
                Text(String(vm.config.name))
                    .bold()
                
                HStack {
                    Spacer()
                    Text("\(String(format: "%.0f", vm.selectedRangeValue)) \(vm.config.unit ?? "")")
                    Spacer()
                }
                
                Slider(
                    value: $vm.selectedRangeValue,
                    in: Double(range.start)...Double(range.end),
                    step: Double(range.step),
                    minimumValueLabel: Text("\(range.start) \(vm.config.unit ?? "")"),
                    maximumValueLabel: Text("\(range.end) \(vm.config.unit ?? "")"),
                    label: { Text("Config Slider") }
                )
            }
        }
    }
}

struct ConfigRangeEditView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigRangeEditView(
            vm: ConfigViewModel(config: AEDeviceConfig.mock.things[0].dataStreams[0].configValues[0])
        )
    }
}
