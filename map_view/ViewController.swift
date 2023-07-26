//
//  ViewController.swift
//  map_view
//
//  Created by 이태윤 on 2023/07/10.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var map_view: MKMapView!
    @IBOutlet var label_1: UILabel!
    @IBOutlet var label_2: UILabel!
    let location_manager = CLLocationManager()
    
    func go_location (latitude : CLLocationDegrees, longitude : CLLocationDegrees, delta_span : Double) -> CLLocationCoordinate2D {
        let p_location = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpan(latitudeDelta: delta_span, longitudeDelta: delta_span)
        let location_view = MKCoordinateRegion(center: p_location, span: span)
        map_view.setRegion(location_view, animated: true)
        return p_location
    }
    
    func setAnnotation (latitude : CLLocationDegrees, longitude : CLLocationDegrees, delta_span : Double, title : String, sub_title : String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = go_location(latitude: latitude, longitude: longitude, delta_span : delta_span)
        annotation.title = title
        annotation.subtitle = sub_title
        map_view.addAnnotation(annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let last_location = locations.last
        _ = go_location(latitude: (last_location?.coordinate.latitude)!, longitude: (last_location?.coordinate.longitude)!, delta_span: 0.01)
        CLGeocoder().reverseGeocodeLocation(last_location!, completionHandler: {
            (placemarks, error) -> Void in
            let pm = placemarks!.first
            let country = pm!.country
            var address : String = country!
            if pm!.locality != nil {
                address += " "
                address += pm!.locality!
            }
            if pm!.thoroughfare != nil {
                address += " "
                address += pm!.thoroughfare!
            }
            self.label_1.text = "현재 위치"
            self.label_2.text = address
        })
        location_manager.stopUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        label_1.text = ""
        label_2.text = ""
        location_manager.delegate = self
        location_manager.desiredAccuracy = kCLLocationAccuracyBest
        location_manager.requestWhenInUseAuthorization()
        location_manager.startUpdatingLocation()
        map_view.showsUserLocation = true
    }
    
    @IBAction func segmented_control(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.label_1.text = ""
            self.label_2.text = ""
            location_manager.startUpdatingLocation()
        } else if sender.selectedSegmentIndex == 1 {
            setAnnotation(latitude: 37.751853, longitude: 128.87605740000004, delta_span: 1, title: "한국폴리텍대학 강릉캠퍼스", sub_title: "강원도 강릉시 남산초교길 121")
            self.label_1.text = "보고 계신 위치"
            self.label_2.text = "한국 폴리텍대학 강릉캠퍼스"
        } else if sender.selectedSegmentIndex == 2 {
            setAnnotation(latitude: 37.556876, longitude: 126.914066, delta_span: 0.1, title: "이지스 퍼블리싱", sub_title: "서울시 마포구 장다리로 109 이지스 빌딩")
            self.label_1.text = "보고 계신 위치"
            self.label_2.text = "이지스 퍼블리싱 출판사"
        }
    }

}

