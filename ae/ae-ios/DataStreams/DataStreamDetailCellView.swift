//
//  DataStreamDetailCellView.swift
//  ae
//
//  Created by blaine on 4/26/22.
//

import SwiftUI
import FlexiBLE

struct DataStreamDetailCellView: View {
    @StateObject var vm: AEDataStreamViewModel
    @State private var dataTabularViewPopover = false
    @State private var dataGraphViewPopover = false
    @State private var editConfigPopover = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(vm.dataStream.name)")
                .font(.custom("Arvo-Bold", size: 19))
            
            Text("\(vm.dataStream.description ?? "")")
                .lineLimit(0)
                .font(.custom("Arvo", size: 13))
            
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
                FXBButton(action: { dataGraphViewPopover.toggle() }) {
                    Text("View Graph")
                }
                .fullScreenCover(isPresented: $dataGraphViewPopover) {
                    NavigationView {
                        DataStreamGraphVisualizerView(vm: vm, graphPropertyVM: DataExplorerGraphPropertyViewModel(vm.dataStream))
                    }
                }
                
                FXBButton(action: { dataTabularViewPopover.toggle() }) {
                    Text("View Table")
                }
                .fullScreenCover(isPresented: $dataTabularViewPopover) {
                    NavigationView {
                        DataExplorerTableView(vm: DataExplorerTableViewModel(tableName: "\(vm.dataStream.name)_data"))
                    }
                }
                Spacer()
            }
            
            Divider()
            
            ForEach(vm.configVMs, id: \.config.name) { configVM in
                ConfigValueView(vm: configVM)
            }
            HStack {
                FXBButton(action: {editConfigPopover.toggle()}) {
                    Text("Edit Parameters")
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

//struct DataStreamDetailCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        let ds = FXBSpec.mock.devices[0].dataStreams[0]
//        let vm = AEDataStreamViewModel(ds, deviceName: "none")
//        DataStreamDetailCellView(vm: vm)
//            .previewLayout(.sizeThatFits)
//    }
//}
