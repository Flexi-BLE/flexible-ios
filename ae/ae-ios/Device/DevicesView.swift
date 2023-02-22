//
//  AEThingsView.swift
//  ae
//
//  Created by blaine on 4/29/22.
//

import SwiftUI
import FlexiBLE

struct DevicesView: View {
    @StateObject var vm: ProfileSelectionViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                ProfileSelectionHeader(vm: vm)
                    .padding()
                Divider()
                Spacer()
                switch vm.state {
                case .loading(_):
                    Text("loading device config")
                    Spacer()
                case .noProfileSelected:
                    Text("no config selected")
                    Spacer()
                case .active(let profile):
                    ScrollView {
                        FXBLEConnectionView(spec: profile.specification)
                            .modifier(Card())
                        ForEach(profile.specification.devices, id: \.id) { deviceSpec in
                            FXBDeviceSpecConnectionView(spec: deviceSpec, conn: fxb.conn)
                                .modifier(Card())
                            
                        }
                        ForEach(profile.specification.bleRegisteredDevices, id: \.name) { deviceSpec in
                            FXBRegisteredDeviceSpecConnectionView(spec: deviceSpec, conn: fxb.conn)
                                .modifier(Card())
                        }
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
        DevicesView(vm: ProfileSelectionViewModel())
    }
}
