//
//  AEBLESettings.swift
//  ntrain-exthub (iOS)
//
//  Created by blaine on 3/9/22.
//

import SwiftUI
import aeble

struct AEBLESettingsView: View {
    @ObservedObject var vm: AEBLESettingsViewModel = AEBLESettingsViewModel()
    
    @State private var configIndex = 0
    @State private var bucketIndex = 0
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section("Device Info") {
                HStack {
                    Text("Device Id:").bold()
                    TextField("Required", text: $vm.deviceId)
                        .disableAutocorrection(true)
                }
                HStack {
                    Text("User Id:").bold()
                    TextField("Required", text: $vm.userId)
                        .disableAutocorrection(true)
                }
            }
            
            Section("Remote Server") {
                Toggle("Enabled", isOn: $vm.isRemoteServerEnabled)
                if vm.isRemoteServerEnabled {
                    HStack {
                        Text("API URL:").bold()
                        TextField("Required", text: $vm.apiURL)
                            .disableAutocorrection(true)
                            .keyboardType(.URL)
                    }
                    HStack {
                        Text("Batch Upload:").bold()
                        TextField("Required", value: $vm.uploadBatch, formatter: NumberFormatter())
                            .disableAutocorrection(true)
                            .keyboardType(.numberPad)
                    }
                    
                    Picker(selection: $bucketIndex, label: Text("Sensor Data Bucket").bold()) {
                        ForEach(0 ..< $vm.bucketNames.count) {
                            Text(self.vm.bucketNames[$0])
                        }
                    }
                }
            }
            
            Section("BLE Configuration") {
                Toggle("Use Local Configuration", isOn: $vm.isLocalPeripheralConfig)
                if !vm.isLocalPeripheralConfig {
                    Picker(selection: $configIndex, label: Text("Available Configs").bold()) {
                        ForEach(0 ..< $vm.peripheralConfigNames.count) {
                            Text(self.vm.peripheralConfigNames[$0])
                        }
                    }
                }
            }
            
            Section {
                Button("Save") {
                    vm.save(configIndex: configIndex, bucketNameIndex: bucketIndex)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
            .navigationBarTitle(Text("AEBLE Settings"))
            .onAppear {
                Task {
                    await vm.refreshConfigNames()
                    await vm.refreshBucketNames()
                }
            }
    }
}

struct AEBLESettings_Previews: PreviewProvider {
    static var previews: some View {
        AEBLESettingsView()
    }
}
