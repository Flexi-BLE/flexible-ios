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
            
            switch conn.fxbFoundDevices {
            case let ds where ds.count == 1: Text("\(ds.count) device found").font(.body)
            case let ds where ds.count > 1: Text("\(ds.count) devices found").font(.body)
            default: Text("No devices found").font(.body)
            }
            switch conn.fxbConnectedDevices {
            case let ds where ds.count == 1: Text("\(ds.count) device connected").font(.body)
            case let ds where ds.count > 1: Text("\(ds.count) devices connected").font(.body)
            default: Text("No devices connected").font(.body)
            }
            
            Spacer()
            
            HStack {
                Spacer()
                NavigationLink(destination: {
                    SelectFXBDeviceConnectionView(deviceSpec: spec)
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle("\(spec.name) Devices")
                }, label: {
                    Text("View Devices").buttonStyle(.bordered)
                })
            }
            
        }.padding()
    }
}

struct FXBDeviceSpecConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        FXBDeviceSpecConnectionView(spec: FXBSpec.mock.devices.first!)
    }
}
