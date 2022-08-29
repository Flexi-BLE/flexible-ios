//
//  DataStreamDataView.swift
//  ae
//
//  Created by Blaine Rothrock on 4/27/22.
//

import SwiftUI
import FlexiBLE

struct DataStreamDataView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var vm: AEDataStreamViewModel
    @State var viewSelection = 0
    
    var body: some View {
        VStack {
            switch viewSelection {
            case 0:
                // TODO: maybe? switch between config values aswell
                DataExplorerTableView(
                    vm: DataExplorerTableViewModel(
                        tableName: "\(vm.dataStream.name)_data"
                    )
                )
            case 1:
                VStack {
                    Spacer()
                    DataExplorerLineGraphView(vm: vm)
                    Spacer()
                }
                
            default: Text("You cannot be here.")
            }
            Spacer()
            Picker(selection: $viewSelection) {
                Text("Table").tag(0)
                Text("Visual").tag(1)
            } label: {
                Text("")
            }
            .pickerStyle(.segmented)
            AEButton(action: { dismiss() }){
                Text("Dismiss")
            }
        }
    }
}

struct DataStreamDataView_Previews: PreviewProvider {
    static var previews: some View {
        let ds = FXBSpec.mock.devices[0].dataStreams[0]
        let vm = AEDataStreamViewModel(ds, deviceName: "none")
        DataStreamDataView(vm: vm)
    }
}
