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
    
    private var foundDeviceCount: Int {
        return conn.fxbFoundDevices.filter({ $0.deviceName.hasPrefix(spec.name) }).count
    }
    
    private var connectedDeviceCount: Int {
        return conn.fxbConnectedDevices.filter({ $0.deviceName.hasPrefix(spec.name) }).count
    }
    
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
                    value: foundDeviceCount,
                    text: "Found"
                )   
                Spacer()
                ValueView(
                    value: connectedDeviceCount,
                    text: "Connected"
                )
            }
            
            Spacer()
            
            if (foundDeviceCount + connectedDeviceCount > 0) {
                NavigationLink(destination: {
                    SelectFXBDeviceConnectionView(deviceSpec: spec)
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle("\(spec.name) Devices")
                }, label: {
                    CenteredView(
                        Text("Manage Devices")
                            .padding(11)
                            .background(Color(UIColor.systemIndigo))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .frame(height: 45.0)
                    )
                })
            }
        }
        .padding()
    }
}

struct FXBDeviceSpecConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        FXBDeviceSpecConnectionView(spec: FXBSpec.mock.devices.first!)
    }
}
