//
//  AEThingsView.swift
//  ae
//
//  Created by blaine on 4/29/22.
//

import SwiftUI
import aeble

struct AEThingsView: View {
    @StateObject var vm: AEViewModel
    
    
    
    var body: some View {
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
                    ForEach(config.things, id: \.name) { thing in
                        AEThingDetailCellView(vm: AEThingViewModel(with: thing))
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
    }
}

struct AEThingsView_Previews: PreviewProvider {
    static var previews: some View {
        AEThingsView(vm: AEViewModel())
    }
}
