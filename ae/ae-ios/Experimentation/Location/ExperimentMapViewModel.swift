//
//  ExperimentMapViewModel.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import Foundation
import Combine
import MapKit
import aeble

@MainActor class ExperimentMapViewModel: ObservableObject {
    
    @Published var experiment: Experiment
    @Published var region: MKCoordinateRegion = MKCoordinateRegion.placeholder()
    @Published var locations: [Location] = []
    
    init(_ experiment: Experiment) {
        self.experiment = experiment
        fetchLocations()
    }
    
    private func fetchLocations() {
        Task {
            self.locations = try await aeble.read.GetLocations()
            self.region = MKCoordinateRegion(coordinates: self.locations)
        }
    }
}
