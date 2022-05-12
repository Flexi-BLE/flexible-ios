//
//  DataStreamsView.swift
//  ae
//
//  Created by blaine on 4/26/22.
//

import SwiftUI
import aeble

struct DataStreamsView: View {
    
    @StateObject var vm: AEThingViewModel
    @State var pageIndex = 0
    
    var body: some View {
        VStack {
            HelpHeaderView(title: "Data Streams", helpText: "todo ...")
            AEThingBannerView(vm: vm)
            VStack(alignment: .leading) {
                TabView {
                    ForEach(vm.thing.dataStreams, id: \.name) { ds in
                        ScrollView {
                            DataStreamDetailCellView(vm: AEDataStreamViewModel(ds))
                                .modifier(Card())
                        }
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            }
        }
    }
}

struct DataStreamsView_Previews: PreviewProvider {
    static var previews: some View {
        DataStreamsView(vm: AEThingViewModel(with: AEDeviceConfig.mock.things.first!))
    }
}
