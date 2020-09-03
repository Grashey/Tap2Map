//
//  MapViewController.swift
//  Tap2Map
//
//  Created by Aleksandr Fetisov on 02.09.2020.
//  Copyright © 2020 Aleksandr Fetisov. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Realm

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    //Moscow center
    let mskCoordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    
    var locationManager: CLLocationManager?
    let geocoder = CLGeocoder()
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    var isTracking = false
    
    @IBOutlet weak var mapView: GMSMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        configureMap(with: mskCoordinate)
        configureLocationManager()
    }

    func configureMap(with coordinate: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
        mapView.camera = camera
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.requestAlwaysAuthorization()
    }
    
    @IBAction func updateLocation(_ sender: UIBarButtonItem) {
        if !isTracking {
            startTracking(sender: sender)
            locationManager?.startMonitoringSignificantLocationChanges()
        } else {
            stopTracking(sender: sender)
            locationManager?.stopMonitoringSignificantLocationChanges()
        }
        
    }
    
    @IBAction func currentLocation(_ sender: UIBarButtonItem) {
        locationManager?.requestLocation()
    }
    
    func startTracking(sender: UIBarButtonItem) {
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
        locationManager?.startUpdatingLocation()
        sender.title = "Stop Tracking"
        isTracking = true
    }
    
    func stopTracking(sender: UIBarButtonItem) {
        locationManager?.stopUpdatingLocation()
        sender.title = "Start Tracking"
        isTracking = false
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        geocoder.reverseGeocodeLocation(location) { places, error in
            print(places?.last ?? "oops")
        }
        routePath?.add(location.coordinate)
        route?.path = routePath
        let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
        mapView.animate(to: position)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

