//
//  NewTimestampsViewModel.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import Foundation
import aeble
import UIKit

@MainActor class TimestampsViewModel: ObservableObject {
    @Published var timestamps: [Timestamp]
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
        
        let res = await aeble.exp.getTimestampForExperiment(withID: id)
        switch res {
        case .success(let ts): self.timestamps = ts ?? []
        case .failure(let err): self.errorMsg = err.localizedDescription
        }
    }
    
    
    func createTimemarker() async {
        let name = "Timestamp - \(Date().getDetailedDate())"
        let res = await aeble.exp.createTimeMarker(name: name, experimentId: experimentId)
        
        switch res {
        case .success(let ts): self.timestamps.append(ts)
        case .failure(let err): self.errorMsg = err.localizedDescription
        }
    }
    
}
