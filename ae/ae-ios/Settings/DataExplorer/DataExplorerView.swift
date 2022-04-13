//
//  DataExplorerView.swift
//  ntrain-exthub
//
//  Created by Blaine Rothrock on 1/11/22.
//

import SwiftUI

struct DataExplorerView: View {
    @ObservedObject var vm = DataExplorerViewModel()
    
    var body: some View {
        List(vm.tables, id: \.self) { table in
            NavigationLink(
                destination: DataExplorerTableView(vm: DataExplorerTableViewModel(tableName: table)),
                label: {
                    Text(table)
                }
            )
        }
        .refreshable {
            vm.refreshTables()
        }
        .navigationBarTitle("DB Tables", displayMode: .inline)
    }
}

struct DataExplorerView_Previews: PreviewProvider {
    static var previews: some View {
        DataExplorerView()
    }
}
