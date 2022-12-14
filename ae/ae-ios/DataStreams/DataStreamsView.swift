//
//  DataStreamsView.swift
//  ae
//
//  Created by blaine on 4/26/22.
//

import SwiftUI
import FlexiBLE

struct DataStreamsView: View {
    
    var deviceSpec: FXBDeviceSpec
    var deviceName: String
    @State var pageIndex = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                ForEach(deviceSpec.dataStreams, id: \.name) { ds in
                    DataStreamDetailCellView(
                        vm: AEDataStreamViewModel(ds, deviceName: deviceName)
                    ).modifier(Card())
                }
            }
        }
    }
}
