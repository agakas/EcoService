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
import Alamofire

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIScrollViewDelegate, ChartViewDelegate {
    
    private let map = MKMapView()
    private var manager = CLLocationManager()
    private var localButton: UIButton!
    private var annotationView: MKAnnotationView!
    private var scrollView: UIScrollView!
    private var filtersView: UIStackView!
    private var alert: UIAlertController!
    private var array: [Company]!
    private var filtersArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(map)
        map.largeContentImageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        map.frame = view.bounds
        
        CompanyInfo.getInfo { com, err in
            guard err == nil else {
                self.alertAction(err!)
                return
            }

            guard let coms = com else {return}
            
            self.array = coms
            
            for i in coms{
                    let coordinate = CLLocationCoordinate2D(latitude: i.long, longitude: i.lati)
                    self.addCustomPin(coordinate: coordinate, name: i.name, address: i.address)
//                    i.materials.count
            }
            
            var set = Set<String>()
            for i in coms{
                for j in i.materials{
                    set.update(with: j.name)
                }
            }
            
            
            self.scrollView = {
                let v = UIScrollView()
                v.delegate = self
                v.sizeToFit()
                v.layer.cornerRadius = 15
                v.backgroundColor = .secondarySystemBackground
                v.layer.masksToBounds = true
                v.showsHorizontalScrollIndicator = false
                v.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
                self.map.addSubview(v)
                v.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.bottom.equalTo(self.view.snp.bottom).offset(-20)
                    make.width.equalToSuperview().dividedBy(1.02)
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
            
            for button in set{
                let _: UIButton = {
                    let lab = UIButton()
                    lab.setTitle(button, for: .normal)
                    lab.addTarget(self, action: #selector(self.filter), for: .touchUpInside)
                    lab.setTitleColor(.label, for: .normal)
                    lab.titleLabel?.font = UIFont.font(15, UIFont.FontType.main)
                    lab.layer.cornerRadius = 5
                    lab.layer.masksToBounds = true
                    lab.contentHorizontalAlignment = .center
                    lab.contentVerticalAlignment = .center
                    lab.sizeToFit()
                    lab.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
                    if (button == "Пластик"){
                        lab.backgroundColor = .systemYellow
                    }
                    if (button == "Тетра пак"){
                        lab.backgroundColor = .gray
                    }
                    if (button == "Стекло"){
                        lab.backgroundColor = .systemGreen
                    }
                    if (button == "Металл"){
                        lab.backgroundColor = .systemRed
                    }
                    if (button == "Макулатура"){
                        lab.backgroundColor = .systemBlue
                    }
                    self.filtersView.addArrangedSubview(lab)
                    lab.snp.makeConstraints { snap in
                        snap.height.equalToSuperview().dividedBy(2.7)
                    }
                    return lab
                }()
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
    
    func alertAction(_ er: AFError){
        alert = UIAlertController(title: er.responseCode?.description, message: er.errorDescription!, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel", style: .destructive, handler: nil))
        present(self.alert, animated: true)
    }
    
    @objc func filter(_ sender: UIButton){
        map.removeAnnotations(map.annotations)
        
        var filtAr = [Company]()
        for i in array{
            for j in i.materials{
                if sender.titleLabel?.text == j.name{
                    filtAr.append(i)
                }
            }
        }
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            filtersArray.append(sender.titleLabel!.text!)
        } else {
            filtersArray = filtersArray.filter({ i in
                i != sender.titleLabel!.text!
            })
        }
        if sender.isSelected{
            sender.backgroundColor = .quaternaryLabel
        } else {
            if (sender.titleLabel!.text! == "Пластик"){
                sender.backgroundColor = .systemYellow
            }
            if (sender.titleLabel!.text! == "Тетра пак"){
                sender.backgroundColor = .gray
            }
            if (sender.titleLabel!.text! == "Стекло"){
                sender.backgroundColor = .systemGreen
            }
            if (sender.titleLabel!.text! == "Металл"){
                sender.backgroundColor = .systemRed
            }
            if (sender.titleLabel!.text! == "Макулатура"){
                sender.backgroundColor = .systemBlue
            }
        }
        if filtersArray == []{
            for i in array{
                    let coordinate = CLLocationCoordinate2D(latitude: i.long, longitude: i.lati)
                    self.addCustomPin(coordinate: coordinate, name: i.name, address: i.address)
            }
        } else {
            for i in filtAr{
                    let coordinate = CLLocationCoordinate2D(latitude: i.long, longitude: i.lati)
                    self.addCustomPin(coordinate: coordinate, name: i.name, address: i.address)
            }
        }
    }
    
}

