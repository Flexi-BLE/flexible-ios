//
//  DataStreamDetailCellView.swift
//  ae
//
//  Created by blaine on 4/26/22.
//

import SwiftUI
import aeble

struct DataStreamDetailCellView: View {
    @StateObject var vm: AEDataStreamViewModel
    @State private var dataExplorePopover = false
    @State private var editConfigPopover = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(vm.dataStream.name)")
                .font(.title2)
            
            Text("\(vm.dataStream.description ?? "")")
                .lineLimit(0)
                .font(.body)
            
            Divider()
            
            KeyValueView(key: "Number of Records", value: "\(vm.recordCount.fuzzy)")
            
//            KeyValueView(
//                key: "Freq. (\(1000 / vm.dataStream.intendedFrequencyMs)Hz)",
//                value: "\(String(format: "%.2f", vm.meanFreqLastK))Hz"
//            )
//
//            KeyValueView(key: "Awaiting Upload", value: "\(vm.unUploadCount.fuzzy)")
//
//            KeyValueView(
//                key: "Uploads",
//                value: "\(vm.uploadAgg.totalRecords.fuzzy) (✅\(vm.uploadAgg.success), ❌\(vm.uploadAgg.failures))"
//            )
            
            HStack {
                Spacer()
                AEButton(action: { dataExplorePopover.toggle() }) {
                    Text("Explore Data")
                }
                .fullScreenCover(isPresented: $dataExplorePopover) {
                    NavigationView {
                        DataStreamDataView(vm: vm)
                    }
                }
                Spacer()
            }
            
            Divider()
            
            ForEach(vm.configVMs, id: \.config.name) { configVM in
                ConfigValueView(vm: configVM)
            }
            HStack {
                Spacer()
                AEButton(action: {editConfigPopover.toggle()}) {
                    Text("Edit Configuration")
                }
                .fullScreenCover(isPresented: $editConfigPopover) {
                    NavigationView {
                        ConfigEditView(vm: vm)
                    }
                }
                Spacer()
            }
        }
        .padding()
    }
}

struct DataStreamDetailCellView_Previews: PreviewProvider {
    static var previews: some View {
        let ds = AEDeviceConfig.mock.things[0].dataStreams[0]
        let vm = AEDataStreamViewModel(ds, deviceName: "none")
        DataStreamDetailCellView(vm: vm)
            .previewLayout(.sizeThatFits)
    }
}
