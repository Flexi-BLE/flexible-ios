//
//  AEThingsView.swift
//  ae
//
//  Created by blaine on 4/29/22.
//

import SwiftUI
import FlexiBLE

struct DevicesView: View {
    @StateObject var vm: FlexiBLESpecViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                ConfigSelectionHeaderView(vm: vm)
                    .padding()
                Divider()
                Spacer()
                switch vm.state {
                case .loading:
                    Text("loading device config")
                    Spacer()
                case .unselected:
                    Text("no config selected")
                    Spacer()
                case .selected(let spec, _):
                    ScrollView {
                        FXBLEConnectionView(spec: spec)
                            .modifier(Card())
                        ForEach(spec.devices, id: \.id) { deviceSpec in
                            FXBDeviceSpecConnectionView(spec: deviceSpec, conn: fxb.conn)
                                .modifier(Card())
                        }
                        ForEach(spec.bleRegisteredDevices, id: \.name) { deviceSpec in
                            FXBRegisteredDeviceSpecConnectionView(spec: deviceSpec, conn: fxb.conn)
                                .modifier(Card())
                        }
                    }
                case .error(let message):
                    Text("😵 \(message)")
                    Spacer()
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView(vm: FlexiBLESpecViewModel())
    }
}
