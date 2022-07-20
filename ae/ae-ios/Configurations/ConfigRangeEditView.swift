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
        
        if vm.config.range != nil {
            VStack {
                AEDataStreamConfigSlider(vm: vm)
                Text("\(String(format: "%.0f", vm.selectedRangeValue)) \(vm.config.unit ?? "")")
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
