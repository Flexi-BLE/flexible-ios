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
    @State var isShowingDataStream = false
    
    
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
            AEButton {
                isShowingDataStream = true
            } content: {
                Text("Data Streams")
            }


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
