//
//  NewNewExperimentViewModel.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import Foundation
import Combine
import FlexiBLE

@MainActor class NewExperimentViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var hasEndDate = false
    @Published var trackGPS = false
    
    @Published var errorMsg: String?=nil
    
    func createExperiment() async {
        
        let res = await fxb.exp.createExperiment(
            name: name,
            description: description == "" ? nil : description,
            start: startDate,
            end: hasEndDate ? endDate : nil,
            active: true,
            trackGPS: trackGPS
        )
        
        switch res {
        case .success(let exp):
            if exp.trackGPS {
                LocationManager.sharedInstance.trackGPS(status: exp.trackGPS)
            }
            
        case .failure(let err):
            self.errorMsg = err.localizedDescription
        }
    }
}
