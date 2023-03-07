//
//  ConfigValueView.swift
//  ae-ios
//
//  Created by blaine on 7/20/22.
//

import SwiftUI
import FlexiBLE

struct ConfigValueView: View {
    @StateObject var vm: ConfigViewModel
    
    private var key: String {
        return "\(vm.config.name)"
    }
    
    private var value: String {
        if let options = vm.config.options, !options.isEmpty, let i = Int(vm.selectedValue) {
            if let op = options[optional: i] {
                return "\(op.name) \(vm.config.unit ?? "")"
            }
        }
        return "\(vm.selectedValue) \(vm.config.unit ?? "")"
    }
    
    var body: some View {
        KeyValueView(
            key: key,
            value: value
        )
    }
}

struct ConfigValueView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigValueView(
            vm: ConfigViewModel(config: FXBSpec.mock.devices[0].dataStreams[0].configValues[0])
        )
    }
}
