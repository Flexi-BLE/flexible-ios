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
    @EnvironmentObject var profile: FlexiBLEProfile
    
    var deviceSpec: FXBDeviceSpec
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach((profile.conn.fxbConnectedDevices + profile.conn.fxbFoundDevices)
                    .sorted(by: { $0.deviceName < $1.deviceName })) {
                        
                        DeviceConnectionCellView(vm: FXBDeviceViewModel(profile: profile, device: $0))
                            .modifier(Card())
                    }
                Spacer()
            }
        }
    }
}

struct ConntectFXBDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        SelectFXBDeviceConnectionView(deviceSpec: FXBSpec.mock.devices.first!)
    }
}
