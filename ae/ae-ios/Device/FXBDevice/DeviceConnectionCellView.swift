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
                EmptyView()
                KeyValueView(key: "Status", value: "Connected")
                if let connectionRecord = vm.device.connectionRecord {
                    KeyValueView(key: "Connection Time", value: "\(connectionRecord.connectedAt?.timeSinceHumanReadable() ?? "--none--")")
                    Divider()
                    KeyValueView(key: "Reference Date", value: "\(connectionRecord.latestReferenceDate?.getShortDateAndTime() ?? "--none--")")
                    KeyValueView(key: "Spec", value: "\(connectionRecord.specificationIdString ?? "--none--") (\(connectionRecord.specificationVersion ?? "--none--"))")
                }
                Divider()
                HStack {
                    Text("Auto Connect: ").font(.body).bold()
                    Spacer()
                    Toggle("Auto Connect", isOn: $vm.shouldAutoConnect)
                        .labelsHidden()
                }
                
                Divider()
                
                HStack {
                    Spacer()
                    NavigationLink(destination: {
                        DataStreamsView(deviceSpec: vm.device.spec, deviceName: vm.device.deviceName)
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle("\(vm.device.deviceName)")
                    }, label: {
                        Text("Manage Data Streams")
                            .padding(11)
                            .background(Color(UIColor.systemIndigo))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .frame(height: 45.0)
                    })
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
