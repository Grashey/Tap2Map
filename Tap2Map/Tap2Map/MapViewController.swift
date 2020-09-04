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
    var lastTrack = [Coordinate]()
    
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
    
    //MARK: Start/Stop Tracking
    @IBAction func updateLocation(_ sender: UIBarButtonItem) {
        if !isTracking {
            startTracking()
        } else {
            stopTracking()
        }
    }
    
    func startTracking() {
        lastTrack.removeAll()
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
    }
    
    func stopTracking() {
        locationManager?.stopUpdatingLocation()
        locationManager?.stopMonitoringSignificantLocationChanges()
        if trackingButton.title == "Stop Tracking" {
            trackingButton.title = "Start Tracking"
        }
        isTracking = false
        
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.deleteAll()
            realm.add(lastTrack)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    //MARK: Show The Last Path
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
    
    func isTrackingAlert() {
        let alert = UIAlertController(title: "Tracking is active", message: "Please stop tracking to show the last track.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Stop", style: .default, handler: { action in
            self.stopTracking()
            self.showLastTrack()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func showLastTrack() {
        do {
            let realm = try Realm()
            let lastPath = realm.objects(Coordinate.self).map { $0.self }
            let mutablePath = GMSMutablePath()
            for coordinate in lastPath {
                mutablePath.addLatitude(coordinate.latitude, longitude: coordinate.longitude)
            }
            let route = GMSPolyline()
            route.path = mutablePath
            let bounds = GMSCoordinateBounds(path: route.path!)
            let camera = mapView.camera(for: bounds, insets: UIEdgeInsets())
            mapView.camera = camera!
        } catch {
            print(error)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
//        geocoder.reverseGeocodeLocation(location) { places, error in
//            print(places?.last ?? "oops")
//        }
        
        let coordinate = Coordinate()
        coordinate.latitude = location.coordinate.latitude
        coordinate.longitude = location.coordinate.longitude
        coordinate.id = "\(lastTrack.count)"
        lastTrack.append(coordinate)
        
        routePath?.add(location.coordinate)
        route?.path = routePath
        let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
        mapView.animate(to: position)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

