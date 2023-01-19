//
//  DataExplorerTableViewModel.swift
//  ntrain-exthub
//
//  Created by Blaine Rothrock on 1/11/22.
//

import Foundation
import Combine
import SwiftUI
import GRDB
import FlexiBLE


@MainActor class DataExplorerTableViewModel: ObservableObject {
    @Published var metadata: [FXBTableInfo]?
    @Published var data: [GenericRow] = [GenericRow]()
    @Published var tableName: String
    
    init(tableName: String) {
        self.tableName = tableName
    }
    
    func refreshTableMetadata() async {
        metadata = try? FlexiBLE.shared.dbAccess?.dataStream.tableInfo(for: tableName)
        await self.refreshData()
    }
    
    func refreshData() async {
        if let data = try? await FlexiBLE.shared.dbAccess?.dataStream.records(for: self.tableName, limit: 100) {
            DispatchQueue.main.async {
                self.data = data
            }
        }
    }
}
