//
//  DataView.swift
//  Flexi-BLE
//
//  Created by Blaine Rothrock on 9/22/22.
//

import SwiftUI

struct DeviceDataView: View {
    @StateObject var vm: DeviceDataViewModel = DeviceDataViewModel()
    
    var body: some View {
        VStack {
            HStack {
                DeviceSelectionView(vm: vm).padding()
                Spacer()
                if let _ = vm.connectedDevice {
                    FXBButton(action: { vm.reloadAllDefaults() }) {
                        Text("Load Defaults")
                    }.padding()
                }
            }
            if let cd = vm.connectedDevice, !cd.isSpecVersionMatched {
                Text("⚠️ device version mismatch")
            }
            Divider()
            if let deviceSpec = vm.deviceSpec {
                Spacer()
                DataStreamsView(deviceSpec: deviceSpec, deviceName: vm.deviceName)
            } else {
                Spacer()
                ProgressView().progressViewStyle(.circular)
                Spacer()
            }
        }
        .onAppear() {
            vm.fetchConnectionRecords()
        }
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceDataView()
    }
}
