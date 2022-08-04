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
            self.locations = try await aeble.read.GetLocations(
                startDate: experiment.start,
                endDate: experiment.end,
                limit: nil,
                offset: nil
            )
            if self.locations.count > 0 {
                self.region = MKCoordinateRegion(coordinates: self.locations)
            }
        }
    }
    
    func points() -> [Point] {
        return locations.map({ Point(lat: $0.latitude, long: $0.longitude) })
    }
    
    struct Point: Identifiable {
        let id: UUID
        let location: CLLocationCoordinate2D
        
        init(id: UUID=UUID(), lat: Double, long: Double) {
            self.id = id
            self.location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
    }
}
