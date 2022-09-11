//
//  AEThingDetailCellView.swift
//  ae
//
//  Created by blaine on 4/29/22.
//

import SwiftUI
import FlexiBLE

struct AEThingDetailCellView: View {
    @StateObject var vm: AEThingViewModel
    @State var isShowingDataStream = false
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(vm.thing.name)")
                    .font(.custom("Arvo-Bold", size: 19))
                Spacer()
                Toggle("Enabled", isOn: vm.isEnabled!)
                    .labelsHidden()
            }
            Text("\(vm.thing.description)")
//                .fixedSize(horizontal: false, vertical: true)
                .font(.custom("Arvo", size: 13))

            
            Spacer().frame(height: 10.0)
            
            
            NavigationLink(destination: {
                DataStreamsView(vm: vm)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("Data Streams")
            }) {
                Text("Data Streams")
            }
            .buttonStyle(FCBButtonStyle(bgColor: .indigo, fontColor: .white))

//            NavigationLink(
//                isActive: $isShowingDataStream,
//                destination: {
//
//                    DataStreamsView(vm: vm)
//                        .navigationBarTitleDisplayMode(.inline)
//                        .navigationTitle("Data Streams")
//                },
//                label: { EmptyView() }
//            )
//            FXBButton {
//                isShowingDataStream = true
//            } content: {
//                Text("Data Streams")
//            }


            Divider()
            KeyValueView(key: "Status", value: "\(vm.connectionStatus)")
        }
        .padding()
    }
}

struct AEThingDetailCellView_Previews: PreviewProvider {
    static var previews: some View {
        AEThingDetailCellView(vm: AEThingViewModel(with: FXBSpec.mock.devices.first!))
    }
}
