//
//  AEThingsView.swift
//  ae
//
//  Created by blaine on 4/29/22.
//

import SwiftUI
import FlexiBLE

struct AEThingsView: View {
    @StateObject var vm: AEViewModel
    
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
                case .selected(let config, _):
                    ScrollView {
                        ForEach(config.devices, id: \.id) { device in
                            AEThingDetailCellView(vm: FXBDeviceViewModel(with: device, specVersion: config.schemaVersion))
                                .modifier(Card())
                        }
                        ForEach(config.bleRegisteredDevices, id: \.name) { device in
                            AERegisteredDeviceDetailCellView(
                                vm: AERegisteredDeviceViewModel(with: device)
                            ).modifier(Card())
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

struct AEThingsView_Previews: PreviewProvider {
    static var previews: some View {
        AEThingsView(vm: AEViewModel())
    }
}
