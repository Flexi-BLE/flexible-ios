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
        if let options = vm.config.options {
            VStack {
                HStack {
                    
                    VStack(alignment: .leading) {
                        Text(vm.config.name)
                            .bold()
                        Text(vm.config.description)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    Picker("Options", selection: $vm.selectedValue) {
                        ForEach(options, id: \.value) { option in
                            Text(option.name).tag(option.value)
                        }
                    }
                }
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
