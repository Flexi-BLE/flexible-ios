//
//  NewTimestampViewModel.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import Foundation
import FlexiBLE

@MainActor class TimestampViewModel: ObservableObject {
    @Published var timestamp: FXBTimestamp
    
    @Published var newName: String = ""
    @Published var newDescription: String = ""
    
    init(timestamp: FXBTimestamp) {
        self.timestamp = timestamp
        self.newName = timestamp.name ?? ""
        self.newDescription = timestamp.description ?? ""
    }
    
    func updateTimeMarkerDetails() async {
        guard let id = self.timestamp.experimentId else {
            return
        }
        
        do {
            if let timestamp = try await FlexiBLE.shared.dbAccess?.experiment.updateTimestamp(
                id: id,
                name: newName,
                description: newDescription
            ) {
                self.timestamp = timestamp
            }
        } catch {
            GeneralLogger.error("unable to update time stamp record: \(error.localizedDescription)")
        }
    }
}
