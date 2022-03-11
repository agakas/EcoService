//
//  MapViewController.swift
//  Recycle
//
//  Created by Dima Savelyev on 11.03.2022.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    let map = MKMapView()
    var manager = CLLocationManager()
    var localButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(map)
        map.largeContentImageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        map.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            manager.stopUpdatingLocation()
            render(location)
        }
    }
    
    func render(_ location: CLLocation){
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        map.setRegion(region, animated: true)
    }
}
