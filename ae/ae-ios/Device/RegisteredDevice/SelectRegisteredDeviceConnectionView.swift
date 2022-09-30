//
//  SelectRegisteredDeviceConnectionView.swift
//  Flexi-BLE
//
//  Created by blaine on 9/26/22.
//

import SwiftUI
import Combine
import FlexiBLE

struct SelectRegisteredDeviceConnectionView: View {
    var deviceSpec: FXBRegisteredDeviceSpec
    
    var body: some View {
        List(fxb.conn.foundRegisteredDevices + fxb.conn.connectedRegisteredDevices) {
            RegisteredDeviceConnectionCellView(vm: RegisteredDeviceViewModel(with: $0))
        }
    }
}

struct SelectRegisteredDeviceConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        SelectRegisteredDeviceConnectionView(deviceSpec: FXBSpec.mock.bleRegisteredDevices.first!)
    }
}
