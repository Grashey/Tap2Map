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
import RealmSwift

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    //Moscow center
    let mskCoordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    
    var locationManager: CLLocationManager?
    let geocoder = CLGeocoder()
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    var isTracking = false
    var lastTrack = [[CLLocationDegrees]]()
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var trackingButton: UIBarButtonItem!
    
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
            startTracking()
        } else {
            stopTracking()
        }
    }
    
    @IBAction func getLastPath(_ sender: UIBarButtonItem) {
        if !lastTrack.isEmpty {
            if !isTracking {
                showLastTrack()
            } else {
                isTrackingAlert()
            }
        } else {
            let alert = UIAlertController(title: "", message: "TrackPath is Empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func startTracking() {
        route?.map = nil
        route = GMSPolyline()
        route?.strokeColor = .black
        route?.strokeWidth = 3
        routePath = GMSMutablePath()
        route?.map = mapView
        locationManager?.startMonitoringSignificantLocationChanges()
        locationManager?.startUpdatingLocation()
        trackingButton.title = "Stop Tracking"
        isTracking = true
        lastTrack.removeAll()
    }
    
    func stopTracking() {
        locationManager?.stopUpdatingLocation()
        locationManager?.stopMonitoringSignificantLocationChanges()
        if trackingButton.title == "Stop Tracking" {
            trackingButton.title = "Start Tracking"
        }
        isTracking = false
    }
    
    func isTrackingAlert() {
        let alert = UIAlertController(title: "Tracking is active", message: "Please stop tracking to show the last track.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.stopTracking()
            self.showLastTrack()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func showLastTrack() {
        let startPoint = CLLocationCoordinate2D(latitude: (lastTrack.first?.first)!, longitude: (lastTrack.first?.last)!)
        let finishPoint = CLLocationCoordinate2D(latitude: (lastTrack.last?.first)!, longitude: (lastTrack.last?.last)!)
        let bounds = GMSCoordinateBounds(coordinate: startPoint, coordinate: finishPoint)
        let camera = mapView.camera(for: bounds, insets: UIEdgeInsets())
        mapView.camera = camera!
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
//        geocoder.reverseGeocodeLocation(location) { places, error in
//            print(places?.last ?? "oops")
//        }
        lastTrack.append([location.coordinate.latitude, location.coordinate.longitude])
        routePath?.add(location.coordinate)
        route?.path = routePath
        let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
        mapView.animate(to: position)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

