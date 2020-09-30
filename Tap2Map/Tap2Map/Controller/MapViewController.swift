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
    
    var locationManager = LocationManager.instance
    let geocoder = CLGeocoder()
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    var isTracking = false
    var lastTrack = [Coordinate]()
    var marker: GMSMarker?
   
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMap(with: mskCoordinate)
        configureLocationManager()
        configureNavigationBar()
    }

    func configureMap(with coordinate: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
        mapView.camera = camera
    }
    
    func configureLocationManager() {
        locationManager
            .location
            .asObservable()
            .bind { [weak self] location in
                guard let location = location else { return }
                self?.route?.path = self?.routePath
                let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
                self?.mapView.animate(to: position)
        }
    }
    
    //MARK: Start/Stop Tracking
    @objc func updateLocation() {
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
        locationManager.startUpdatingLocation()
        
        locationManager
            .location
            .asObservable()
            .bind { [weak self] location in
                guard let location = location else { return }
                let coordinate = Coordinate()
                coordinate.latitude = location.coordinate.latitude
                coordinate.longitude = location.coordinate.longitude
                coordinate.id = "\(self?.lastTrack.count ?? 0)"
                self?.lastTrack.append(coordinate)
                self?.routePath?.add(location.coordinate)
                self?.route?.path = self?.routePath
                self?.showMarker(at: location.coordinate)
        }
        
        let item = self.navigationItem.rightBarButtonItems?.last // trackingButton
        item?.title = "Stop Tracking"
        isTracking = true
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
        let item = self.navigationItem.rightBarButtonItems?.last // trackingButton
        if item?.title == "Stop Tracking" {
            item?.title = "Start Tracking"
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
    @objc func getLastPath() {
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
    //MARK: Navigation Bar & Items
    func configureNavigationBar() {
        let lastTrackButton = UIBarButtonItem(title: "Get Last Track", style: .plain, target: self, action: #selector(getLastPath))
        let trackingButton = UIBarButtonItem(title: "Start Tracking", style: .plain, target: self, action: #selector(updateLocation))
        self.navigationItem.rightBarButtonItems = [lastTrackButton, trackingButton]
    }
    //MARK: Marker Setup
    private func showMarker(at coordinate: CLLocationCoordinate2D) {
        self.marker?.map = nil
        self.marker = nil
        
        let marker = GMSMarker(position: coordinate)
        let rect = CGRect(x: 0, y: 0, width: 40, height: 40)
        let view = UIView(frame: rect)
        let imageView = UIImageView()
        if let savedPhoto = try? Data(contentsOf: makeUrl()) {
            imageView.image = UIImage(data: savedPhoto)
        }
        view.addSubview(imageView)
        marker.iconView = view
        imageView.bounds = view.bounds
        imageView.frame.origin = view.frame.origin
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = view.frame.height/2
        marker.map = mapView
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        self.marker = marker
    }
    
    private func makeUrl() -> URL {
        var documentDirectoryURL: URL {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
        let dataURL = documentDirectoryURL.appendingPathComponent(UserDefaults.standard.value(forKey: "userName") as! String).appendingPathExtension("jpeg")
        return dataURL
    }
}
