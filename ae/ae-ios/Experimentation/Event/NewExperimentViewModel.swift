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
    @Published var hasStartDate = false
    @Published var hasEndDate = false
    @Published var trackGPS = false
    
    @Published var errorMsg: String?=nil
    
    func createExperiment() async {
        
        do {
            if let exp = try await FlexiBLE.shared.dbAccess?.experiment.start(
                name: name,
                description: description,
                start: hasStartDate ? startDate : Date.now,
                end: hasEndDate ? endDate : nil,
                active: true,
                trackGPS: trackGPS
            ) {
                if exp.trackGPS {
                    LocationManager.sharedInstance.trackGPS(status: exp.trackGPS)
                }
            }
        } catch {
            errorMsg = error.localizedDescription
        }
    }
}
