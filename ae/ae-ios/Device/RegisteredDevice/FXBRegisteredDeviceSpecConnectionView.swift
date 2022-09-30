//
//  FXBRegisteredDeviceSpecConnectionView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 9/21/22.
//

import SwiftUI
import FlexiBLE

struct FXBRegisteredDeviceSpecConnectionView: View {
    var spec: FXBRegisteredDeviceSpec
    @StateObject var conn: FXBConnectionManager
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(spec.name)
                    .font(.title2)
                Spacer()
                Image(systemName: "applewatch.side.right")
                    .font(.title2)
            }
            Spacer(minLength: 8.0)
            Text(spec.description)
                .font(.body)
            Divider()
            HStack {
                VStack(alignment: .leading) {
                    switch conn.foundRegisteredDevices.count {
                    case let count where count == 1: Text("\(count) device found").font(.body)
                    case let count where count > 1: Text("\(count) devices found").font(.body)
                    default: Text("No devices found").font(.body)
                    }
                    switch conn.connectedRegisteredDevices.count {
                    case let count where count == 1: Text("\(count) device connected").font(.body)
                    case let count where count > 1: Text("\(count) devices connected").font(.body)
                    default: Text("No devices connected").font(.body)
                    }
                }
                Spacer()
                NavigationLink(destination: {
                    SelectRegisteredDeviceConnectionView(deviceSpec: spec)
                }, label: {
                    Text("Manage").buttonStyle(.bordered)
                })
            }
            
        }.padding()
    }
}

struct FXBRegisteredDeviceSpecConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        FXBRegisteredDeviceSpecConnectionView(spec: FXBSpec.mock.bleRegisteredDevices.first!, conn: fxb.conn)
    }
}
