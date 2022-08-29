//
//  NewExperimentsViewModel.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import Foundation
import FlexiBLE

@MainActor class ExperimentsViewModel: ObservableObject {
    
    enum State {
        case loading
        case fetched
        case noExperiment
        case error(error: Error)
    }
    
    @Published var state: State
    @Published var experiments: [FXBExperiment] = []
    
    init() {
        self.state = .noExperiment
        Task {
            await self.getExperiments()
        }
    }
    
    func getExperiments() async {
        self.state = .loading
        let res = await fxb.exp.activeEvent()
        
        switch res {
        case .success(let experiments):
            guard let experiments = experiments,
                  experiments.count > 0 else {
                
                self.state = .noExperiment
                return
            }
            
            self.experiments = experiments
            self.state = .fetched
            
        case .failure(let e):
            self.state = .error(error: e)
        }
    }
    
    func deleteExperiment(at index: Int) async {
        guard let id = experiments[index].id else { return }
        self.state = .loading
        
        let _ = await fxb.exp.deleteExperiment(id: id)
        await self.getExperiments()
    }
}
