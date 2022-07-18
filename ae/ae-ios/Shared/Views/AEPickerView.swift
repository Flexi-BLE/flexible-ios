//
//  AEPickerView.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 7/17/22.
//

import SwiftUI
import aeble

struct AEPickerView: View {
    @Binding var selectedValue : String
    var values : [AEDataStreamConfigOption]
    var name : String
    var body: some View {
        HStack {
            Text(name)
            Spacer()
            Picker("Selection Options", selection: $selectedValue) {
                ForEach(values, id: \.value) { option in
                    Text(option.name).tag(option.value)
                }
            }
        }
    }
}

//struct PickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        let ds = AEDeviceConfig.mock.things[0].dataStreams[0]
//        let vm = AEDataStreamConfigViewModel(config: ds.configValues[0])
//        let options = vm.config.options
//        PickerView(selectedValue: vm.selectedValue, values: options!, name: "sensor-state")
//    }
//}
