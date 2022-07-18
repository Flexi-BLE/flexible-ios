//
//  DataStreamConfigDataView.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 7/15/22.
//

import SwiftUI
import aeble


struct DataStreamConfigDataView: View {
    @StateObject var vm: AEDataStreamConfigViewModel
    var body: some View {
        if vm.config.options != nil {
            VStack {
                AEPickerView(selectedValue: $vm.selectedValue, values: vm.config.options!, name: vm.config.name)
                Text("New Value - \(vm.selectedValue)")
            }
        }
        
        if vm.config.range != nil {
            VStack {
                AERangeSlider(vm: vm)
                Text("\(String(format: "%.0f", vm.selectedRangeValue)) Hz")
            }
        }
    }
}

struct DataStreamConfigDataView_Previews: PreviewProvider {
    static var previews: some View {
        let ds = AEDeviceConfig.mock.things[0].dataStreams[0]
        let vm = AEDataStreamViewModel(ds)
        DataStreamConfigDataView(vm: AEDataStreamConfigViewModel(config: vm.dataStream.configValues[0]))
    }
}
