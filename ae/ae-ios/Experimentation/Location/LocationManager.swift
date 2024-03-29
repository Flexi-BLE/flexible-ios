//
//  LocationManager.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 8/3/22.
//

import Foundation
import CoreLocation
import Combine
import FlexiBLE
import UIKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    public static var sharedInstance = LocationManager()
    
    private var shouldTrackLocation = false
    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }
    
    func checkExperiments() {
        Task {
            if let exps = try? await fxb.dbAccess?.experiment.getActives() {
                self.trackGPS(status: exps.reduce(false, { $0 || $1.trackGPS }))
            } else {
                self.trackGPS(status: false)
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        if shouldTrackLocation {
            Task{
                await trackGPSLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func trackGPS(status: Bool) {
        shouldTrackLocation = status
        if shouldTrackLocation {
            startNow()
        } else {
            stopNow()
        }
    }
    
    func startNow() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func stopNow() {
        locationManager.stopUpdatingLocation()
    }
    
    func trackGPSLocation() async {
        guard let latest = lastLocation else {
            return
        }
        
        let deviceName = UserDefaults.standard.string(forKey: InfluxDBConnection.UserDefaultsKey.deviceId.rawValue) ?? "phone"
        var location = FXBLocation(
            ts: latest.timestamp,
            latitude: Double(latest.coordinate.latitude),
            longitude: Double(latest.coordinate.longitude),
            altitude: latest.altitude,
            horizontalAccuracy: latest.horizontalAccuracy,
            verticalAccuracy: latest.verticalAccuracy,
            deviceName: deviceName
        )
        
        do {
            try FlexiBLE.shared.dbAccess?.location.record(&location)
        } catch {
            GeneralLogger.error("unable to commit location to database: \(error.localizedDescription)")
        }
    }
}
