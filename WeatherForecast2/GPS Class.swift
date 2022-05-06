////
////  GPS Class.swift
////  WeatherForecast2
////
////  Created by NourAllah Ahmed on 5/5/22.
////  Copyright © 2022 NourAllah Ahmed. All rights reserved.
////
//
//
//
//import Foundation
//import CoreLocation
//
//class GPS :  CLLocationManagerDelegate {
//    init(){
//        let locationManager = CLLocationManager()
//        locationManager.requestAlwaysAuthorization()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//        
//        // For use when the app is open
//        locationManager.requestWhenInUseAuthorization()
//        // If location services is enabled get the users location
//        if CLLocationManager.locationServicesEnabled() {
//            print("Allowed")
//            locationManager.startUpdatingLocation()
//            print("start")
//            //                    locationManager.requestLocation()
//        }
//        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//            if let error = error as? CLError, error.code == .denied {
//                print("error in getting location \(error.localizedDescription)")
//                // Location updates are not authorized.
//                manager.stopUpdatingLocation()
//                return
//            }
//            print("no Errors")
//            // Notify the user of any errors.
//        }
//        
//        
//        
//        // Print out the location to the console
//        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//            print("didUpdateLocations")
//            print(location.first)
//            if let location = locations.first {
//                print("getting")
//                print(location.coordinate.latitude)
//                print(location.coordinate.longitude)
//                myUsetDefaults?.set(location.coordinate.latitude, forKey: "lat")
//                myUsetDefaults?.set(location.coordinate.longitude, forKey: "lon")
//                
//            }
//            else{
//                print("not working")
//            }
//        }
//}
//}
//
