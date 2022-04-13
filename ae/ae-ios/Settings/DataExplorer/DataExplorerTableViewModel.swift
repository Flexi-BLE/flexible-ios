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


class DataExplorerTableViewModel: ObservableObject {
    @Published var metadata: [TableInfo]?
    @Published var data: [GenericRow] = [GenericRow]()
    @Published var tableName: String
    
    
    // TODO: push entire table to influxDB
    
    init(tableName: String) {
        self.tableName = tableName
        Task.init {
            await self.refreshTableMetadata()
        }
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
