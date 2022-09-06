//
//  AERegisteredDeviceDetailCellView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/1/22.
//

import SwiftUI
import FlexiBLE

struct AERegisteredDeviceDetailCellView: View {
    @StateObject var vm: AERegisteredDeviceViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(vm.metadata.name)")
                    .font(.custom("Arvo-Bold", size: 19))
                Spacer()
                Toggle("Enabled", isOn: vm.isEnabled!)
                    .labelsHidden()
            }
            Text("\(vm.metadata.description)")
                .fixedSize(horizontal: false, vertical: true)
                .font(.custom("Arvo", size: 13))
            
            Divider()
            KeyValueView(key: "Status", value: "\(vm.connectionStatus)")
        }
        .padding()
    }
}

struct AERegisteredDeviceDetailCellView_Previews: PreviewProvider {
    static var previews: some View {
        AERegisteredDeviceDetailCellView(vm: AERegisteredDeviceViewModel(with: FXBSpec.mock.bleRegisteredDevices.first!))
    }
}
