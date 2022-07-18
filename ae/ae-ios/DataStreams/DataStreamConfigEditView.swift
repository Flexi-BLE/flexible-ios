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
            Spacer().frame(height: 11)
            ForEach(vm.dataStream.configValues, id: \.name) { config in
                DataStreamConfigDataView(vm: AEDataStreamConfigViewModel(config: config))
                Spacer().frame(height: 21)
            }
            Button(
                action: { dismiss() },
                label: { Text("Dismiss") }
            ).padding()
            Spacer()
        }
        .padding()
        .navigationBarTitle("Configurations")
    }
}

struct DataStreamConfigEditView_Previews: PreviewProvider {
    static var previews: some View {
        let ds = AEDeviceConfig.mock.things[0].dataStreams[0]
        let vm = AEDataStreamViewModel(ds)
        DataStreamConfigEditView(vm: vm)
    }
}
