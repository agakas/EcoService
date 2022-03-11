//
//  MapViewController.swift
//  Recycle
//
//  Created by Dima Savelyev on 11.03.2022.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIScrollViewDelegate {
    
    private let map = MKMapView()
    private var manager = CLLocationManager()
    private var localButton: UIButton!
    private var annotationView: MKAnnotationView!
    private var scrollView: UIScrollView!
    private var filtersView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(map)
        map.largeContentImageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        map.frame = view.bounds
        
        self.scrollView = {
            let v = UIScrollView()
            v.delegate = self
            v.sizeToFit()
            v.backgroundColor = .cyan
            v.showsHorizontalScrollIndicator = false
            v.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            self.map.addSubview(v)
            v.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(self.view.snp.bottom).offset(-20)
                make.width.equalToSuperview()
                make.height.equalToSuperview().dividedBy(10)
            }
            return v
        }()
        
        self.filtersView = {
            let v = UIStackView()
            v.sizeToFit()
            v.alignment = .center
            v.spacing = 10
            v.axis = .horizontal
            v.distribution = .fill
            self.scrollView.addSubview(v)
            v.snp.makeConstraints { make in
                make.edges.equalTo(self.scrollView)
                make.height.equalToSuperview()
            }
            return v
        }()
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
        
        map.delegate = self
        
        // MARK: Add database
        addCustomPin(coordinate: coordinate)
        
        map.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        annotationView?.annotation = annotation
        return annotationView
    }
    
    private func addCustomPin(coordinate: CLLocationCoordinate2D){
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = "Jopa"
        pin.subtitle = "Che to"
        map.addAnnotation(pin)
    }
}
