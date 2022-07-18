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
            
            KeyValueView(key: "Awaiting Upload", value: "\(vm.unUploadCount.fuzzy)")
            
            KeyValueView(
                key: "Uploads",
                value: "\(vm.uploadAgg.totalRecords.fuzzy) (✅\(vm.uploadAgg.success), ❌\(vm.uploadAgg.failures))"
            )
            
            Button(
                action: { dataExplorePopover.toggle() },
                label: { Text("Explore Data") }
            )
            .frame(width: 200, height: 30)
            .foregroundColor(.white)
            .background(.gray)
            .cornerRadius(10.0)
            .fullScreenCover(isPresented: $dataExplorePopover) {
                NavigationView {
                    DataStreamDataView(vm: vm)
                }
            }
            Divider()
            
            ForEach(vm.dataStream.configValues, id: \.name) { config in
                KeyValueView(
                    key: config.name,
                    value: config.defaultValue
                )
            }
            Button(
                action: { editConfigPopover.toggle() },
                label: { Text("Edit Configuration") }
            )
            .frame(width: 200, height: 30)
            .foregroundColor(.white)
            .background(.gray)
            .cornerRadius(10.0)
            .fullScreenCover(isPresented: $editConfigPopover) {
                NavigationView {
                    DataStreamConfigEditView(vm: vm)
                }
            }
            
        }
        .padding()
    }
}

struct DataStreamDetailCellView_Previews: PreviewProvider {
    static var previews: some View {
        let ds = AEDeviceConfig.mock.things[0].dataStreams[0]
        let vm = AEDataStreamViewModel(ds)
        DataStreamDetailCellView(vm: vm)
            .previewLayout(.sizeThatFits)
    }
}
