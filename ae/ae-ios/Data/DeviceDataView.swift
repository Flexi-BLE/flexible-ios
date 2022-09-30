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
            DeviceSelectionView(vm: vm).padding()
            if let cd = vm.connectedDevice, !cd.isSpecVersionMatched {
                Text("⚠️ device version mismatch")
            }
            Divider()
            Spacer()
            if let deviceSpec = vm.deviceSpec {
                DataStreamsView(deviceSpec: deviceSpec, deviceName: vm.deviceName)
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
