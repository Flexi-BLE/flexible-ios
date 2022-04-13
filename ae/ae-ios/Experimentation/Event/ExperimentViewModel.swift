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
    @Published var state: State
    
    init() {
        self.state = .noExperiment
        Task {
            await self.getActiveEvent()
        }
    }
    
    func getActiveEvent() async {
        self.state = .loading
        let res = await aeble.exp.activeEvent()
    
        switch res {
        case .success(let e):
            if let exp = e {
                self.state = .activeExperiment(experiment: exp)
            } else {
                self.state = .noExperiment
            }
        case .failure(let e): self.state = .error(error: e)
        }
    }
    
    func createExperiment(name: String, description: String?=nil) async {
        self.state = .loading
        
        let res = await aeble.exp.startExperiment(
            name: name,
            description: description,
            start: Date.now
        )
        
        switch res {
        case .success(let e): self.state = .activeExperiment(experiment: e)
        case .failure(let e): self.state = .error(error: e)
        }
    }
    
    func endExperiment() async {
        guard case .activeExperiment(experiment: let exp) = self.state,
        let id = exp.id else { return }
        
        self.state = .loading
        
        let res = await aeble.exp.endExperiment(id: id)
        
        switch res {
        case .success(_): self.state = .noExperiment
        case .failure(let e): self.state = .error(error: e)
        }
    }
    
    func deleteExperiment() async {
        guard case .activeExperiment(experiment: let exp) = self.state,
              let id = exp.id else { return }
        
        let res = await aeble.exp.deleteExperiment(id: id)
        
        switch res {
        case .success(_): self.state = .noExperiment
        case .failure(let e): self.state = .error(error: e)
        }
    }
    
    func markTime(name: String, description: String?) async {
        let res: Result<Bool, Error>
        if case .activeExperiment(experiment: let exp) = self.state {
            res = await aeble.exp.markTime(name: name, description: description, experiment: exp)
        } else {
            res = await aeble.exp.markTime(name: name, description: description)
        }
        
        switch res {
        case .success: break
        case .failure(let e): self.state = .error(error: e)
        }
    }
}

extension ExperimentViewModel {
    enum State {
        case loading
        case activeExperiment(experiment: Experiment)
        case noExperiment
        case error(error: Error)
    }
}
