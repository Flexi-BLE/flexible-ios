//
//  DataExplorerViewModel.swift
//  ntrain-exthub
//
//  Created by Blaine Rothrock on 1/11/22.
//

import Foundation
import Combine
import SwiftUI
import FlexiBLE

class DataExplorerViewModel: ObservableObject {
    @Published var tables: [String] = []
    
    init() {
        refreshTables()
    }
    
    func refreshTables() {
        // TODO: refactor table view
//        self.tables = fxb.db.getTableNames()
//        DBManager.shared.getTableMetadata(for: "dynamic_table")
    }
}
