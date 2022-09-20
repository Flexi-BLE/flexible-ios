//
//  DataStreamsView.swift
//  ae
//
//  Created by blaine on 4/26/22.
//

import SwiftUI
import FlexiBLE

struct DataStreamsView: View {
    
    @StateObject var vm: FXBDeviceViewModel
    @State var pageIndex = 0
    
    var body: some View {
        VStack {
//            HelpHeaderView(title: "Data Streams", helpText: "todo ...")
            AEThingBannerView(vm: vm)
            VStack(alignment: .leading) {
                ScrollView {
                    ForEach(vm.thing.dataStreams, id: \.name) { ds in
                        ScrollView {
                            DataStreamDetailCellView(
                                vm: AEDataStreamViewModel(
                                    ds,
                                    deviceName: vm.thing.name,
                                    deviceVM: vm
                                )
                            )
                                .modifier(Card())
                        }
                    }
                }
            }
        }
    }
}

struct DataStreamsView_Previews: PreviewProvider {
    static var previews: some View {
        DataStreamsView(vm: FXBDeviceViewModel(with: FXBSpec.mock.devices.first!))
    }
}
