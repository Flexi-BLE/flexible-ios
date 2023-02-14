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
    @ObservedObject var connection: FXBConnectionManager
    
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
                    switch connection.foundRegisteredDevices.count {
                    case let count where count == 1: Text("\(count) device found").font(.body)
                    case let count where count > 1: Text("\(count) devices found").font(.body)
                    default: Text("No devices found").font(.body)
                    }
                    switch connection.connectedRegisteredDevices.count {
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
