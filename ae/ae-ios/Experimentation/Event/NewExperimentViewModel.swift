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
    
    private var profile: FlexiBLEProfile?
    private var locationManager: LocationManager?
    
    func set(profile: FlexiBLEProfile, locationManager: LocationManager) {
        self.profile = profile
        self.locationManager = locationManager
    }
    
    func createExperiment() async {
        
        guard let profile = self.profile,
              let locationManager = self.locationManager else { return }
        
        do {
            let exp = try await profile.database.experiment.start(
                name: name,
                description: description,
                start: hasStartDate ? startDate : Date.now,
                end: hasEndDate ? endDate : nil,
                active: true,
                trackGPS: trackGPS
            )
            
            if exp.trackGPS {
                locationManager.trackGPS(status: exp.trackGPS)
            }
        } catch {
            errorMsg = error.localizedDescription
        }
    }
}
