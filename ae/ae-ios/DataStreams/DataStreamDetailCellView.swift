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
                NavigationLink(destination: DataStreamGraphVisualizerView(vm: vm, graphPropertyVM: DataExplorerGraphPropertyViewModel(dataStream: vm.dataStream))) {
                    Text("View Graph")
                }
                .buttonStyle(FCBButtonStyle(bgColor: .indigo, fontColor: .white))
                
                NavigationLink(destination: DataExplorerTableView(vm: DataExplorerTableViewModel(tableName: "\(vm.dataStream.name)_data"))) {
                    Text("View Table")
                }
                .buttonStyle(FCBButtonStyle(bgColor: .indigo, fontColor: .white))
                Spacer()
            }
            
            Divider()
            
            ForEach(vm.configVMs, id: \.config.name) { configVM in
                ConfigValueView(vm: configVM)
            }
            HStack {
                NavigationLink(destination: ConfigEditView(vm: vm)) {
                    Text("Edit Parameters")
                }
                .buttonStyle(FCBButtonStyle(bgColor: .indigo, fontColor: .white))
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
