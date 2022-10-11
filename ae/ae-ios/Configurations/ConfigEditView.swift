//
//  ConfigEditView.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 7/18/22.
//

import SwiftUI
import FlexiBLE

struct ConfigEditView: View {
    @StateObject var vm: AEDataStreamViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            ScrollView {
                FXBButton(action: { vm.loadDefaultConfigs() }) {
                    Text("Load Defaults")
                }
                ForEach(vm.configVMs, id: \.config.name) { configVM in
                    
                    if configVM.config.options != nil {
                        ConfigOptionEditView(vm: configVM)
                    }
                    
                    if configVM.config.range != nil {
                        ConfigRangeEditView(vm: configVM)
                    }
                    
                    Divider()
                }
            }
            
            HStack {
                FXBButton(action: {dismiss() }) {
                    Text("Dismiss")
                }
                FXBButton(action: {
                    vm.updateConfigs()
                    dismiss()
                }) {
                    Text("Save")
                }
            }
            Spacer()
        }
        .padding()
        .navigationBarTitle("Edit Configuration")
    }
}
