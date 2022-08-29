//
//  MapKit+Utils.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import Foundation
import MapKit
import FlexiBLE

extension MKCoordinateRegion {
    
    init(coordinates: [FXBLocation]) {
        var minLat: CLLocationDegrees = 90.0
        var maxLat: CLLocationDegrees = -90.0
        var minLong: CLLocationDegrees = 180.0
        var maxLong: CLLocationDegrees = -180.0
        
        for loc in coordinates {
            if loc.latitude < minLat { minLat = loc.latitude }
            if loc.longitude < minLong { minLong = loc.longitude }
            if loc.latitude > maxLat { maxLat = loc.latitude }
            if loc.longitude > maxLong { maxLong = loc.longitude }
        }
        
        let minDelta = 0.01
        
        let latDelta = maxLat - minLat
        let longDelta = maxLong - minLong
        
        let span = MKCoordinateSpan(
            latitudeDelta: max(latDelta, minDelta),
            longitudeDelta: max(longDelta, minDelta)
        )
        
        let center = CLLocationCoordinate2D(
            latitude: latDelta < minDelta ? coordinates[0].latitude : (maxLat - span.latitudeDelta / 2),
            longitude: longDelta < minDelta ? coordinates[0].longitude : (maxLong - span.longitudeDelta / 2)
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
