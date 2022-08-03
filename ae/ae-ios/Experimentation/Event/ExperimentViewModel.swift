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
    @Published var endDate: Date?
    @Published var isActive: Bool
    
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
        case .success(let exp):
            self.isActive = exp.active
            self.endDate = exp.end
        case .failure(let e):
            print(e.localizedDescription)
        }
    }
    

    func deleteExperiment() async -> Bool {
        guard let id = self.id else { return false}
        let res = await aeble.exp.deleteExperiment(id: id)
        switch res {
        case .success(let status):
            print(status)
            return status
        case .failure(let error):
            print(error.localizedDescription)
            return false
        }
    }
}
