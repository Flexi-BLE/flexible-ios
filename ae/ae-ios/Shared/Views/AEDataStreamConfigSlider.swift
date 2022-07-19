//
//  AEDataStreamConfigSlider.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 7/15/22.
//

import Foundation
import SwiftUI
import aeble

struct AEDataStreamConfigSlider: View {
    @StateObject var vm: AEDataStreamConfigViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(String(vm.config.name))
            
            Slider(value: $vm.selectedRangeValue,
                   in: Double(vm.config.range!.start)...Double(vm.config.range!.end),
                   step: 1.0,
                   minimumValueLabel: Text("\(vm.config.range!.start) \(vm.config.unit ?? "")"),
                   maximumValueLabel: Text("\(vm.config.range!.end) \(vm.config.unit ?? "")"),
                   label: { Text("Config Slider") })

        }
    }
}


struct RangeSlider_Previews: PreviewProvider {
    static var previews: some View {
        let ds = AEDeviceConfig.mock.things[0].dataStreams[0]
        let vm = AEDataStreamViewModel(ds)
        AEDataStreamConfigSlider(vm: AEDataStreamConfigViewModel(config: vm.dataStream.configValues[1]))
    }
}
