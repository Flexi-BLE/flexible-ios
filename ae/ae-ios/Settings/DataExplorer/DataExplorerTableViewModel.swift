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
import aeble


@MainActor class DataExplorerTableViewModel: ObservableObject {
    @Published var metadata: [TableInfo]?
    @Published var data: [GenericRow] = [GenericRow]()
    @Published var tableName: String
    
    init(tableName: String) {
        self.tableName = tableName
    }
    
    func refreshTableMetadata() async {
        metadata = aeble.db.tableInfo(for: self.tableName)
        await self.refreshData()
    }
    
    func refreshData() async {
        guard let metadata = self.metadata else { return }
        if let data = await aeble.db.data(for: self.tableName, metadata: metadata) {
            DispatchQueue.main.async {
                self.data = data
            }
        }
    }
}
