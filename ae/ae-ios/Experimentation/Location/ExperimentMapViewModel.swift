//
//  ExperimentMapViewModel.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import Foundation
import Combine
import MapKit
import FlexiBLE

@MainActor class ExperimentMapViewModel: ObservableObject {
    
    @Published var experiment: FXBExperiment
    @Published var region: MKCoordinateRegion = MKCoordinateRegion.placeholder()
    @Published var locations: [FXBLocation] = []
    
    init(_ experiment: FXBExperiment) {
        self.experiment = experiment
        fetchLocations()
    }
    
    private func fetchLocations() {
        Task {
            
            let allLocations = try await FlexiBLE.shared.dbAccess?.location.get(
                from: experiment.start,
                to: experiment.end,
                limit: 1000
            ) ?? []
            
            self.locations = [allLocations[0]]
            
            var lastLoc = CLLocation(latitude: allLocations[0].latitude, longitude: allLocations[0].longitude)
            for loc in allLocations[1...] {
                let clLoc = CLLocation(latitude: loc.latitude, longitude: loc.longitude)
                if clLoc.distance(from: lastLoc) > 25 {
                    self.locations.append(loc)
                    lastLoc = clLoc
                }
            }
            
            
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
