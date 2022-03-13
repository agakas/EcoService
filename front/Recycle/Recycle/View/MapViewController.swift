//
//  MapViewController.swift
//  Recycle
//
//  Created by Dima Savelyev on 11.03.2022.
//

import UIKit
import MapKit
import CoreLocation
import Charts

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIScrollViewDelegate, ChartViewDelegate {
    
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
        
        CompanyInfo.getInfo { com, err in
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
            
            guard let coms = com else {return}
            
            for i in coms{
                    let coordinate = CLLocationCoordinate2D(latitude: i.long, longitude: i.lati)
                    self.addCustomPin(coordinate: coordinate, name: i.name, address: i.address)
//                    i.materials.count
            }
        }
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
        map.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        var annotationView = map.dequeueReusableAnnotationView(withIdentifier: "circle")
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "circle")
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.addSubview(addPie(count: 5))
        return annotationView
    }
    
    private func addCustomPin(coordinate: CLLocationCoordinate2D, name: String, address: String){
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = name
        pin.subtitle = address
        map.addAnnotation(pin)
    }
    
    func addPie(count: Int)->PieChartView{
        let pieChart: PieChartView! = {
            let pie = PieChartView()
            pie.delegate = self
            pie.holeColor = .clear
            pie.legend.enabled = false
            pie.data?.setDrawValues(false)
            pie.isUserInteractionEnabled = false
            self.map.addSubview(pie)
            pie.snp.makeConstraints { make in
                make.width.equalTo(70)
                make.height.equalTo(70)
                make.center.equalToSuperview()
            }
            var entries = [ChartDataEntry]()
            
            for x in 0...count{
                entries.append(ChartDataEntry(x: Double(x), y: Double(x)))
            }
            let set = PieChartDataSet(entries: entries)
            set.drawValuesEnabled = false
            set.colors = [UIColor.green, UIColor.yellow, UIColor.red, UIColor.blue, UIColor.gray]
            let data = PieChartData(dataSet: set)
            pie.data = data
            return pie
        }()
        return pieChart
    }
    
}

