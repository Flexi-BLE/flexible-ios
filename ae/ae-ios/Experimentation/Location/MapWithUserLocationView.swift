//
//  MapWithUserLocationView.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 8/3/22.
//

import SwiftUI
import MapKit

struct MapWithUserLocationView: View {
    
    @StateObject var locationManager = LocationManager()
    
    let MapLocations = [
            MapLocation(name: "St Francis Memorial Hospital", latitude: 42.037230, longitude: -87.706624),
            MapLocation(name: "The Ritz-Carlton, San Francisco", latitude: 42.011471, longitude: -87.679140),
            MapLocation(name: "Honey Honey Cafe & Crepery", latitude: 42.042712, longitude: -87.673815)
            ]
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    var region: Binding<MKCoordinateRegion>? {
            guard let location = locationManager.lastLocation else {
                return MKCoordinateRegion.goldenGateRegion().getBinding()
            }
            
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
            
            return region.getBinding()
        }
    
    var body: some View {
        VStack {
            Text("location status: \(locationManager.statusString)")
            HStack {
                Text("latitude: \(userLatitude)")
                    .font(.caption)
                Text("longitude: \(userLongitude)")
                    .font(.caption)
            }
            if let region = region {
                Map(coordinateRegion: region,
                    interactionModes: .all,
                    showsUserLocation: true,
                    userTrackingMode: .constant(.follow),
                    annotationItems: MapLocations,
                    annotationContent: { location in
                    MapPin(coordinate: location.coordinate, tint: .red)
                })
            }
        }
    }
}


struct MapWithUserLocationView_Previews: PreviewProvider {
    static var previews: some View {
        MapWithUserLocationView()
    }
}


extension MKCoordinateRegion {
    
    static func goldenGateRegion() -> MKCoordinateRegion {
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.819527098978355, longitude:  -122.47854602016669), latitudinalMeters: 5000, longitudinalMeters: 5000)
    }
    
    func getBinding() -> Binding<MKCoordinateRegion>? {
        return Binding<MKCoordinateRegion>(.constant(self))
    }
}


struct MapLocation: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
