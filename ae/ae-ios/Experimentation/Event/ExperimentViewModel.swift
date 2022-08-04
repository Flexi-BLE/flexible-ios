//
//  NewExperimentViewModel.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import Foundation
import Combine
import aeble
import SwiftUI


@MainActor class ExperimentViewModel: ObservableObject {
    @State var experiment: Experiment
    @State var errorMsg: String?=nil
    
    init(_ experiment: Experiment) {
        self.experiment = experiment
    }
    
    func stopExperiment() async {
        guard let id = self.experiment.id else { return }
        
        let res = await aeble.exp.stopExperiment(id: id)
        
        switch res {
        case .success(let exp):
            self.experiment = exp
        case .failure(let e):
            errorMsg = e.localizedDescription
        }
    }
    
    func deleteExperiment() async -> Bool {
        guard let id = self.experiment.id else { return false}
        
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
