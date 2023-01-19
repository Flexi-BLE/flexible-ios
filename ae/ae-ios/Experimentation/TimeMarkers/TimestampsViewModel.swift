//
//  NewTimestampsViewModel.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import Foundation
import FlexiBLE
import UIKit

@MainActor class TimestampsViewModel: ObservableObject {
    @Published var timestamps: [FXBTimestamp]
    @Published var errorMsg: String?=nil
    
    private let experimentId: Int64?
    
    init(with experimentId: Int64?) {
        self.timestamps = []
        self.experimentId = experimentId
        Task {
            await self.getTimestamps(forID: experimentId)
        }
    }
    
    func getTimestamps(forID: Int64?) async {
        guard let id = forID else {
            return
        }
        
        do {
            if let timestamps = try await FlexiBLE.shared.dbAccess?.experiment.getTimestamps(for: id) {
                self.timestamps = timestamps
            }
        } catch {
            errorMsg = error.localizedDescription
        }
    }
    
    
    func createTimemarker() async {
        let name = "Timestamp - \(Date().getDetailedDate())"
        
        do {
            if let ts = try await FlexiBLE.shared.dbAccess?.experiment.createTimestamp(
                name: name,
                experimentId: experimentId
            ) {
                timestamps.append(ts)
            }
        } catch {
            errorMsg = error.localizedDescription
        }
    }
    
}
