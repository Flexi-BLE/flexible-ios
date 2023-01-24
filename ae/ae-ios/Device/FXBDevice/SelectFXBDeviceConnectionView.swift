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
    
    var deviceSpec: FXBDeviceSpec
    @StateObject private var conn = fxb.conn
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach((fxb.conn.fxbConnectedDevices + fxb.conn.fxbFoundDevices)
                .sorted(by: { $0.deviceName < $1.deviceName })) {
                
                    DeviceConnectionCellView(vm: FXBDeviceViewModel(with: $0))
                    .modifier(Card())
            }
            Spacer()
        }
    }
}

struct ConntectFXBDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        SelectFXBDeviceConnectionView(deviceSpec: FXBSpec.mock.devices.first!)
    }
}
