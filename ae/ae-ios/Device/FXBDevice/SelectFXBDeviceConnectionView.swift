//
//  ConntectFXBDeviceView.swift
//  Flexi-BLE
//
//  Created by Blaine Rothrock on 9/22/22.
//

import SwiftUI
import Combine
import FlexiBLE

struct SelectFXBDeviceConnectionView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var connection: FXBConnectionManager
    var deviceSpec: FXBDeviceSpec
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach((connection.fxbConnectedDevices + connection.fxbFoundDevices)
                    .sorted(by: { $0.deviceName < $1.deviceName })) {
                        
                        DeviceConnectionCellView(vm: FXBDeviceViewModel(connection: connection, device: $0))
                            .modifier(Card())
                    }
                Spacer()
            }
        }
    }
}
