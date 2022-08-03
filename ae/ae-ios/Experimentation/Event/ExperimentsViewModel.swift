//
//  ExperimentsViewModel.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 8/1/22.
//

import Foundation
import aeble

@MainActor class ExperimentsViewModel: ObservableObject {
    @Published var state: ExperimentState
    @Published var experiments: [ExperimentViewModel]
    
    init() {
        self.state = .noExperiment
        self.experiments = []
        Task {
            await self.getExperiments()
        }
    }
    
    
    func getExperiments() async {
        self.state = .loading
        let res = await aeble.exp.activeEvent()
        
        switch res {
        case .success(let e):
            if let fetchedExps = e {
                if fetchedExps.count == 0 {
                    self.state = .noExperiment
                } else {
                    for experiment in fetchedExps {
                        let exp = ExperimentViewModel(
                            id: experiment.id,
                            name: experiment.name,
                            description: experiment.description,
                            start: experiment.start,
                            end: experiment.end,
                            active: experiment.active
                        )
                        self.experiments.append(exp)
                    }
                    self.state = .fetched
                }
            } else {
                self.state = .noExperiment
            }
        case .failure(let e):
            self.state = .error(error: e)
        }
    }
    
    
    func createExperiment(name: String, description: String?, startDate: Date, hasEndDate: Bool, endDate: Date?, tracksGPS: Bool) async {
        self.state = .loading
        let end = hasEndDate ? endDate : nil
        let res = await aeble.exp.createExperiment(name: name, description: description, start: startDate, end: end, active: true)
        
        switch res {
        case .success(let exp):
            self.state = .fetched
            let expo = ExperimentViewModel(
                id: exp.id,
                name: exp.name,
                description: exp.description,
                start: exp.start,
                end: exp.end,
                active: exp.active
            )
            self.experiments.append(expo)
            
        case .failure(let err):
            self.state = .error(error: err)
        }
    }
}

extension ExperimentsViewModel {
    enum ExperimentState {
        case loading
        case fetched
        case noExperiment
        case error(error: Error)
    }
}
