//
//  MapKit+Utils.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import Foundation
import MapKit
import aeble

extension MKCoordinateRegion {
    
    init(coordinates: [Location]) {
        var minLat: CLLocationDegrees = 90.0
        var maxLat: CLLocationDegrees = -90.0
        var minLong: CLLocationDegrees = 180.0
        var maxLong: CLLocationDegrees = -180.0
        
        for loc in coordinates {
            if loc.latitude < minLat { minLat = loc.latitude }
            if loc.longitude < minLong { minLong = loc.longitude }
            if loc.latitude > maxLat { maxLat = loc.longitude }
            if loc.longitude > maxLong { maxLong = loc.longitude }
        }
        
        let span = MKCoordinateSpan(
            latitudeDelta: maxLat - minLat,
            longitudeDelta: maxLong - minLong
        )
        let center = CLLocationCoordinate2D(
            latitude: maxLat - span.latitudeDelta / 2,
            longitude: maxLong - span.longitudeDelta / 2
        )
        
        self.init(center: center, span: span)
    }
    
    static func placeholder() -> Self {
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 42.056458,
                longitude: -87.675270
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 0.05,
                longitudeDelta: 0.05
            )
        )
    }
}
