//
//  MapViewController.swift
//  WeatherForecast2
//
//  Created by NourAllah Ahmed on 4/29/22.
//  Copyright © 2022 NourAllah Ahmed. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController , MKMapViewDelegate ,CLLocationManagerDelegate {
    
    
    var locationManager = CLLocationManager()
    
    
    @IBOutlet weak var myMap: MKMapView!
    
    
    var lat : Double?
    var lon : Double?
    var myUsetDefaults : UserDefaults?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //userDefaults
        myUsetDefaults = UserDefaults.standard
        
        
        //1
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //2
        locationManager.distanceFilter = kCLDistanceFilterNone
        //3
        locationManager.delegate = self
        //4
        locationManager.requestWhenInUseAuthorization()
        //5 ((not used?))
        locationManager.startUpdatingLocation()
        
        //6
        self.myMap.showsUserLocation = true
        
    }
    
    
    @IBAction func click(_ sender: UITapGestureRecognizer) {
    
        //1
        let  touchpoint : CGPoint = sender.location(in: self.myMap)

        //2 get coordinates
        let touchLocation : CLLocationCoordinate2D = myMap.convert(touchpoint, toCoordinateFrom: self.myMap)
        // create annotation
        
        let annotation : CustomAnnotaion = CustomAnnotaion(coordinate: touchLocation)
        
        lat =  annotation.coordinate.latitude
        lon = annotation.coordinate.longitude
        
        annotation.title="your location";
        annotation.subtitle="subtitle";

        self.myMap.removeAnnotations(self.myMap.annotations)
        self.myMap.addAnnotation(annotation)
    
    }
    
    
    @IBAction func done(_ sender: Any) {
 
        print("okay")
        //userdefaults to save them
        print("Lat : \(String(describing: lat)) \n Lon : \(String(describing: lon))")
        myUsetDefaults?.set(lat, forKey: "lat")
        myUsetDefaults?.set(lon, forKey: "lon")

        navigationController?.popViewController(animated: true)
    }
   

    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     override funString(describing: c p)repare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
