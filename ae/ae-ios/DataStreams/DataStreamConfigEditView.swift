//
//  DataStreamConfigEditView.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 7/18/22.
//

import SwiftUI
import aeble

struct DataStreamConfigEditView: View {
    @StateObject var vm: AEDataStreamViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ForEach(vm.dataStream.configValues, id: \.name) { config in
                DataStreamConfigDataView(vm: AEDataStreamConfigViewModel(config: config))
                Divider()
            }
            HStack {
                AEButton(action: {dismiss() }) {
                    Text("Dismiss")
                }
                AEButton(action: { }) {
                    Text("Save")
                }
            }
            Spacer()
        }
        .padding()
        .navigationBarTitle("Edit Configuration")
    }
}

struct DataStreamConfigEditView_Previews: PreviewProvider {
    static var previews: some View {
        let ds = AEDeviceConfig.mock.things[0].dataStreams[0]
        let vm = AEDataStreamViewModel(ds)
        DataStreamConfigEditView(vm: vm)
    }
}
