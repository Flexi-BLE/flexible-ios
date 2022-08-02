//
//  EventViewModel.swift
//  ntrain-exthub (iOS)
//
//  Created by blaine on 2/28/22.
//

import Foundation
import Combine
import aeble

@MainActor class ExperimentViewModel: ObservableObject {
    let id: Int64?
    let name: String
    let description: String?
    var startDate: Date
    var endDate: Date?
    var isActive: Bool
    
    init(id: Int64?, name: String, description: String?, start: Date, end: Date?, active: Bool) {
        self.id = id
        self.name = name
        self.description = description
        self.startDate = start
        self.endDate = end
        self.isActive = active
    }
    
    func stopExperiment() async {
        guard let id = self.id else { return }
        
        let res = await aeble.exp.stopExperiment(id: id)
        
        switch res {
        case .success(_):
            self.isActive = false
            self.endDate = Date.now
        case .failure(let e):
            print("FAIL")
        }
    }
}
