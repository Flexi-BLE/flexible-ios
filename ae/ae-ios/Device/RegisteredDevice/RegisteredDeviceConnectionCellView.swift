//
//  RegisteredDeviceConnectionCellView.swift
//  Flexi-BLE
//
//  Created by blaine on 9/26/22.
//

import SwiftUI

struct RegisteredDeviceConnectionCellView: View {
    @StateObject var vm: RegisteredDeviceViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(vm.device.deviceName)").font(.title3)
                Spacer()
                switch vm.connectionLoading {
                case true: ProgressView().progressViewStyle(.circular)
                case false:
                    Toggle("Connected", isOn: $vm.isEnabled)
                        .labelsHidden()
                        .disabled(!vm.bleIsPoweredOn)
                }
            }
            switch vm.device.connectionState {
            case .connected:
                KeyValueView(key: "Status", value: "Connected")
            case .connecting:
                KeyValueView(key: "Status", value: "Connecting")
            case .initializing:
                KeyValueView(key: "Status", value: "Initializing")
            case .disconnected:
                KeyValueView(key: "Status", value: "Disconnected")
            }
        }.padding()
    }
}
