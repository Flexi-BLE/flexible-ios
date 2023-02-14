//
//  NewExperimentsViewModel.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import Foundation
import FlexiBLE

@MainActor class ExperimentsViewModel: ObservableObject {
    private var profile: FlexiBLEProfile?
    
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
    }
    
    func set(profile: FlexiBLEProfile) {
        self.profile = profile
        Task {
            await self.getExperiments()
        }
    }
    
    func getExperiments() async {
        guard let profile = profile else {
            return
        }
        self.state = .loading
        
        do {
            let exps = try await profile.database.experiment.getActives()
            if exps.isEmpty {
                state = .noExperiment
                return
            }
            experiments = exps
            state = .fetched
        } catch {
            state = .error(error: error)
        }
    }
    
    func deleteExperiment(at index: Int) async {
        guard let profile = profile,
                let id = experiments[index].id else {
            return
        }
        
        self.state = .loading
        
        try? await profile.database.experiment.deleteExperiment(id: id)
        await self.getExperiments()
    }
}
