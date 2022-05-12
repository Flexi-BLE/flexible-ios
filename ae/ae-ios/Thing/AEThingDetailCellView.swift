//
//  AEThingDetailCellView.swift
//  ae
//
//  Created by blaine on 4/29/22.
//

import SwiftUI
import aeble

struct AEThingDetailCellView: View {
    @StateObject var vm: AEThingViewModel
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(vm.thing.name)")
                    .font(.title2)
                Spacer()
                Toggle("Enabled", isOn: vm.isEnabled!)
                    .labelsHidden()
            }
            Text("\(vm.thing.description)")
                .fixedSize(horizontal: false, vertical: true)
                .font(.body)
            
            Divider()
            KeyValueView(key: "Status", value: "\(vm.connectionStatus)")
        }
        .padding()
    }
}

struct AEThingDetailCellView_Previews: PreviewProvider {
    static var previews: some View {
        AEThingDetailCellView(vm: AEThingViewModel(with: AEDeviceConfig.mock.things.first!))
    }
}
