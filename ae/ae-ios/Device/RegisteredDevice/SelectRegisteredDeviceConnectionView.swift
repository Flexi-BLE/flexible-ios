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
    @EnvironmentObject var profile: FlexiBLEProfile
    var deviceSpec: FXBRegisteredDeviceSpec
    
    var body: some View {
        List(profile.conn.foundRegisteredDevices + profile.conn.connectedRegisteredDevices) {
            RegisteredDeviceConnectionCellView(vm: RegisteredDeviceViewModel(profile: profile, device: $0))
        }
    }
}

struct SelectRegisteredDeviceConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        SelectRegisteredDeviceConnectionView(deviceSpec: FXBSpec.mock.bleRegisteredDevices.first!)
    }
}
