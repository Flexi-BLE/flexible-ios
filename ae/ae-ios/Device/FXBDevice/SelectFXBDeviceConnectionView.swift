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
        List(fxb.conn.fxbConnectedDevices + fxb.conn.fxbFoundDevices) {
            DeviceConnectionCellView(vm: FXBDeviceViewModel(with: $0))
        }
    }
}

struct ConntectFXBDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        SelectFXBDeviceConnectionView(deviceSpec: FXBSpec.mock.devices.first!)
    }
}
