//
//  NewTimestampViewModel.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import Foundation
import aeble

@MainActor class TimestampViewModel: ObservableObject {
    @Published var timestamp: Timestamp
    
    @Published var newName: String = ""
    @Published var newDescription: String = ""
    
    init(timestamp: Timestamp) {
        self.timestamp = timestamp
        self.newName = timestamp.name ?? ""
        self.newDescription = timestamp.description ?? ""
    }
    
    func updateTimeMarkerDetails() async {
        guard let id = self.timestamp.experimentId else {
            return
        }
        let res = await aeble.exp.updateTimemarker(
            forID: id,
            name: newName,
            description: newDescription
        )
        print(res)
    }
}
