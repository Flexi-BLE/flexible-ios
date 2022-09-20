//
//  AEThingDetailCellView.swift
//  ae
//
//  Created by blaine on 4/29/22.
//

import SwiftUI
import FlexiBLE

struct AEThingDetailCellView: View {
    @StateObject var vm: FXBDeviceViewModel
    @State var isShowingDataStream = false
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(vm.thing.name)")
                    .font(.title2)
                Spacer()
                Toggle("Enabled", isOn: vm.isEnabled!)
                    .labelsHidden()
                    .disabled(!(vm.isVersionMatched ?? true))
            }
            
            switch vm.isVersionMatched {
            case true :
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.title2)
                    Text("Schema Version Match").font(.body)
                }
            case false:
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                    Text("Specficiation Version Mismatch!").font(.body)
                }
            default:
                EmptyView()
            }
            
            Text("\(vm.thing.description)")
                .fixedSize(horizontal: false, vertical: true)
                .font(.body)
            
            Spacer().frame(height: 10.0)
            
            NavigationLink(
                isActive: $isShowingDataStream,
                destination: {
                    
                    DataStreamsView(vm: vm)
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle("Data Streams")
                },
                label: { EmptyView() }
            )
            FXBButton {
                isShowingDataStream = true
            } content: {
                Text("Data Streams")
            }


            Divider()
            KeyValueView(key: "Status", value: "\(vm.connectionStatusString)")
        }
        .padding()
    }
}

struct AEThingDetailCellView_Previews: PreviewProvider {
    static var previews: some View {
        AEThingDetailCellView(vm: FXBDeviceViewModel(with: FXBSpec.mock.devices.first!, specVersion: "0"))
    }
}
