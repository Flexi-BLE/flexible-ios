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
    
    @State private var connectedSince: String = "00:00:00"
    private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
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
                    KeyValueView(key: "Connection Time", value: "\(connectedSince)")
                        .onReceive(timer) { _ in
                            self.connectedSince = connectionRecord.connectedAt?.timeSinceHumanReadable() ?? "--invalid date--"
                        }
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
                    NavigationLink(destination: {
                        DeviceManagementView(vm: vm)
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle("\(vm.device.deviceName)")
                    }, label: {
                        Text("Manage Device")
                            .padding(11)
                            .background(Color(UIColor.systemIndigo))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .frame(height: 45.0)
                    })
                    Spacer()
                    NavigationLink(destination: {
                        DataStreamsView(deviceSpec: vm.device.spec, deviceName: vm.device.deviceName)
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle("\(vm.device.deviceName)")
                    }, label: {
                        Text("Data Streams")
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
