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
    private let profile: FlexiBLEProfile
    
    init(profile: FlexiBLEProfile, with experimentId: Int64?) {
        self.profile = profile
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
            let timestamps = try await profile.database.experiment.getTimestamps(for: id)
            self.timestamps = timestamps
        } catch {
            errorMsg = error.localizedDescription
        }
    }
    
    
    func createTimemarker() async {
        let name = "Timestamp - \(Date().getDetailedDate())"
        
        do {
            let ts = try await profile.database.experiment.createTimestamp(
                name: name,
                experimentId: experimentId
            )
            timestamps.append(ts)
        } catch {
            errorMsg = error.localizedDescription
        }
    }
    
}
