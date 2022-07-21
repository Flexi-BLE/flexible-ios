//
//  ConfigEditView.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 7/18/22.
//

import SwiftUI
import aeble

struct ConfigEditView: View {
    @StateObject var vm: AEDataStreamViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ForEach(vm.configVMs, id: \.config.name) { configVM in
                
                if configVM.config.options != nil {
                    ConfigOptionEditView(vm: configVM)
                }
                
                if configVM.config.range != nil {
                    ConfigRangeEditView(vm: configVM)
                }
                
                Divider()
            }
            HStack {
                AEButton(action: {dismiss() }) {
                    Text("Dismiss")
                }
                AEButton(action: { vm.updateConfigs() }) {
                    Text("Save")
                }
            }
            Spacer()
        }
        .padding()
        .navigationBarTitle("Edit Configuration")
    }
}

struct DataStreamConfigEditView_Previews: PreviewProvider {
    static var previews: some View {
        let ds = AEDeviceConfig.mock.things[0].dataStreams[0]
        let vm = AEDataStreamViewModel(ds, deviceName: "none")
        ConfigEditView(vm: vm)
    }
}
