//
//  TimeMarkerViewModel.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 8/2/22.
//

import Foundation
import aeble

@MainActor class TimeMarkerViewModel: ObservableObject {
    var id: Int64?
    @Published var name: String
    @Published var description: String
    var experimentID: Int64?
    var datetime: Date

    init(id: Int64?, name: String, description: String, experimentID: Int64?, datetime: Date) {
        self.id = id
        self.name = name
        self.description = description
        self.experimentID = experimentID
        self.datetime = datetime
    }
    
    func updateTimeMarkerDetails(withName: String, withDescription: String, forID: Int64?) async {
        guard let id = forID else {
            return
        }
        let res = await aeble.exp.updateTimemarker(forID: id, name: withName, description: withDescription)
        print(res)
    }
}
