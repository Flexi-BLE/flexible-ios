//
//  UnknownFlexibleDeviceConnectionView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 2/14/23.
//

import SwiftUI
import Combine
import FlexiBLE

struct UnknownFlexibleDeviceConnectionView: View {
    
    @ObservedObject var connection: FXBConnectionManager
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Other FlexiBLE Devices")
                    .font(.title2)
                Spacer()
                Image(systemName: "cpu")
                    .font(.title2)
            }
            Spacer(minLength: 8.0)
            Text("Select device to add to profile")
                .font(.body)
            
            Divider()
            
            Text("\(connection.foundUnknownFlexiBLEDevices.count) device found")
            
            Spacer()
            
//            HStack {
//                Spacer()
//                NavigationLink(destination: {
//                    SelectFXBDeviceConnectionView(deviceSpec: spec)
//                        .navigationBarTitleDisplayMode(.inline)
//                        .navigationTitle("View Devices")
//                }, label: {
//                    Text("View Devices").buttonStyle(.bordered)
//                })
//            }
            
        }
        .padding()
    }
}
