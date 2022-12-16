//
//  DeviceSelectionView.swift
//  Flexi-BLE
//
//  Created by Blaine Rothrock on 9/22/22.
//

import SwiftUI

struct DeviceSelectionView: View {
    @ObservedObject var vm: DeviceDataViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("DEVICE").font(.system(size: 10))
                Picker("Device", selection: $vm.selectedDeviceId) {
                    Text("--none--").tag(-1)
                    ForEach(Array(vm.deviceConnectionRecords.enumerated()), id: \.element.id) { i, conn in
                        Text("\(conn.deviceType): \(conn.deviceName)").tag(i)
                    }
                }.pickerStyle(.menu).onTapGesture {
                    vm.fetchConnectionRecords()
                }
            }
            Spacer()
        }
    }
}

struct DeviceSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceSelectionView(vm: DeviceDataViewModel())
    }
}
