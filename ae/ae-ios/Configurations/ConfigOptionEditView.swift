//
//  ConfigOptionEditView.swift
//  ae-ios
//
//  Created by blaine on 7/20/22.
//

import SwiftUI
import aeble

struct ConfigOptionEditView: View {
    @StateObject var vm: ConfigViewModel
    
    var body: some View {
        if vm.config.options != nil {
            VStack {
                AEDataStreamConfigPickerView(
                    selectedValue: $vm.selectedValue,
                    values: vm.config.options!,
                    name: vm.config.name
                )
            }
        }
    }
}

struct ConfigOptionEditView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigOptionEditView(
            vm: ConfigViewModel(config: AEDeviceConfig.mock.things[0].dataStreams[0].configValues[0])
        )
    }
}
