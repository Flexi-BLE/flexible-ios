//
//  DeviceConnectionCellView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 9/22/22.
//

import SwiftUI
import FlexiBLE

struct DeviceConnectionCellView: View {
    @StateObject var vm: FXBDeviceViewModel
    
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
                if let connectedAt = vm.device.connectionRecord?.connectedAt {
                    KeyValueView(key: "Connection Time", value: "\(connectedAt.timeSinceHumanReadable())")
                }
                if let infoData = vm.device.infoData {
                    Divider()
                    KeyValueView(key: "Reference Date", value: "\(infoData.referenceDate.getShortDateAndTime())")
                    KeyValueView(key: "Spec", value: "\(infoData.specId) (\(infoData.versionId))")
                }
            case .connecting:
                KeyValueView(key: "Status", value: "Connecting")
            case .initializing:
                KeyValueView(key: "Status", value: "Initializing")
            case .disconnected:
                KeyValueView(key: "Status", value: "Disconnected")
            }
            
            if !vm.device.isSpecVersionMatched {
                Divider()
                Text("⚠️ Specification Version Mismatch ⚠️")
            }
        }.padding()
    }
}
