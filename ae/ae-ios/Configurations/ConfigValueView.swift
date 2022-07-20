//
//  ConfigValueView.swift
//  ae-ios
//
//  Created by blaine on 7/20/22.
//

import SwiftUI
import aeble

struct ConfigValueView: View {
    @StateObject var vm: ConfigViewModel
    
    var body: some View {
        KeyValueView(
            key: "\(vm.config.name) (\(vm.is_updated ? "" : "default"))",
            value: vm.selectedValue
        )
    }
}

struct ConfigValueView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigValueView(
            vm: ConfigViewModel(config: AEDeviceConfig.mock.things[0].dataStreams[0].configValues[0])
        )
    }
}
