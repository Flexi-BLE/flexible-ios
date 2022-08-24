//
//  DataExplorerTableView.swift
//  ntrain-exthub
//
//  Created by Blaine Rothrock on 1/11/22.
//

import SwiftUI

struct DataExplorerTableView: View {
    @StateObject var vm: DataExplorerTableViewModel
    
    var body: some View {
        List(vm.data) { row in
            VStack {
                ForEach(0..<row.columns.count) { i in
                    HStack {
                        Text("\(row.metadata[i].name):").bold()
                        Spacer()
                        Text(String(describing: row.columns[i].value))
                    }
                }
            }
            
        }
        .task() {
            await vm.refreshTableMetadata()
        }
        .refreshable {
            await vm.refreshTableMetadata()
        }
        .navigationBarTitle(vm.tableName, displayMode: .inline)
    }
}

struct DataExplorerTableView_Previews: PreviewProvider {
    static var previews: some View {
        DataExplorerTableView(
            vm: DataExplorerTableViewModel(tableName: "dynamic_table")
        )
    }
}
