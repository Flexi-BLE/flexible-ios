//
//  AEThingsView.swift
//  ae
//
//  Created by blaine on 4/29/22.
//

import SwiftUI
import FlexiBLE

struct DevicesView: View {
    @EnvironmentObject var flexiBLE: FlexiBLE
    @EnvironmentObject var profile: FlexiBLEProfile
    
    var body: some View {
        NavigationView {
            VStack {
                ProfileSelectionHeader(vm: ProfileSelectionViewModel(flexiBLE: flexiBLE))
                    .padding()
                Divider()
                
                Spacer()
                
                ScrollView {
                    FXBLEConnectionView()
                        .modifier(Card())
                
                    if let connection = profile.conn {
                        
                        ForEach(profile.specification.devices, id: \.id) { deviceSpec in
                            FXBDeviceSpecConnectionView(spec: deviceSpec, connection: connection)
                                .modifier(Card())
                        }
                        ForEach(profile.specification.bleRegisteredDevices, id: \.name) { deviceSpec in
                            FXBRegisteredDeviceSpecConnectionView(spec: deviceSpec, connection: connection)
                                .modifier(Card())
                        }
                        
                        UnknownFlexibleDeviceConnectionView(connection: connection)
                            .modifier(Card())
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView()
            .environmentObject(FlexiBLE())
            .environmentObject(FlexiBLEProfile(name: "test", spec: nil))
    }
}
