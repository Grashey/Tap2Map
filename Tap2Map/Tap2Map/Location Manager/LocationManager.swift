//
//  LocationManager.swift
//  Tap2Map
//
//  Created by Aleksandr Fetisov on 15.09.2020.
//  Copyright © 2020 Aleksandr Fetisov. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

final class LocationManager: NSObject {
    
    static let instance = LocationManager()
    
    private override init() {
        super.init()
        configureLocationManager()
    }
    
    let locationManager = CLLocationManager()
    
    let location: Variable<CLLocation?> = Variable(nil)
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestAlwaysAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location.value = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
