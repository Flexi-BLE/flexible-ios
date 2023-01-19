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
        
        do {
            if let exps = try await FlexiBLE.shared.dbAccess?.experiment.getActives() {
                if exps.isEmpty {
                    state = .noExperiment
                    return
                }
                experiments = exps
                state = .fetched
            }
        } catch {
            state = .error(error: error)
        }
    }
    
    func deleteExperiment(at index: Int) async {
        guard let id = experiments[index].id else { return }
        self.state = .loading
        
        try? await FlexiBLE.shared.dbAccess?.experiment.deleteExperiment(id: id)
        await self.getExperiments()
    }
}
