//
//  FXBDeviceSpecConnectionView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 9/21/22.
//

import SwiftUI
import FlexiBLE

struct FXBDeviceSpecConnectionView: View {
    var spec: FXBDeviceSpec
    @StateObject var conn: FXBConnectionManager = fxb.conn

    @State var isShowingConnectionManager: Bool = false
    @State var avaiableDevicesText: String = ""
    @State var connectedDevicesText: String = ""
    
    @State private var open: Int? = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(spec.name)
                    .font(.title2)
                Spacer()
                Image(systemName: "cpu")
                    .font(.title2)
            }
            Spacer(minLength: 8.0)
            Text(spec.description)
                .font(.body)
            
            Divider()
            
            HStack {
                ValueView(
                    value: conn.fxbFoundDevices.filter({ $0.deviceName.hasPrefix(spec.name) }).count,
                    text: "Found"
                )
                Spacer()
                ValueView(
                    value: conn.fxbConnectedDevices.filter({ $0.deviceName.hasPrefix(spec.name) }).count,
                    text: "Connected"
                )
            }
            
            Spacer()
            
            NavigationLink(
                destination: SelectFXBDeviceConnectionView(deviceSpec: spec)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("\(spec.name) Devices"),
                tag: 1,
                selection: $open
            ) {
                EmptyView()
            }
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            self.open = self.open == 1 ? 0 : 1
        }
        
    }
}

struct FXBDeviceSpecConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        FXBDeviceSpecConnectionView(spec: FXBSpec.mock.devices.first!)
    }
}
