//
//  SettingsViewController.swift
//  WeatherForecast2
//
//  Created by NourAllah Ahmed on 4/28/22.
//  Copyright © 2022 NourAllah Ahmed. All rights reserved.
//

import UIKit
import CoreLocation

class SettingsViewController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource, CLLocationManagerDelegate {
    
    
    
    @IBOutlet weak var unitPicker: UIPickerView!
    @IBOutlet weak var locationPicker: UIPickerView!
    let locationManager = CLLocationManager()

    var tempunit = ["Kelvin" , "Celsius" , "Fahrenheit"]
    var location = ["Map","GPS"]
    var myUsetDefaults : UserDefaults?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        //userDefaults
        myUsetDefaults = UserDefaults.standard
        
        unitPicker.dataSource = self
        unitPicker.delegate = self
        locationPicker.delegate = self
        locationPicker.dataSource = self
        
        
        //manage the size
        unitPicker.translatesAutoresizingMaskIntoConstraints = false
        locationPicker.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var theReturn = 0
        if pickerView == unitPicker {
            theReturn = 3
        }
        else if pickerView == locationPicker {
            theReturn = 2
        }
        return theReturn
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title : String?
        if pickerView == unitPicker {
            
            switch(row) {
            case 0:
                title = tempunit[0]
                break
            case 1:
                title = tempunit[1]
                break
            case 2:
                title = tempunit[2]
                break
            default:
                title = " "
            }
        }
        else if pickerView == locationPicker {
            switch(row) {
            case 0:
                title = location[0]
                break
            case 1:
                title = location[1]
                break
            default:
                title = " "
            }
        }
        
        return title
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == locationPicker {
            print("selected \(location[row])")
            if row == 0 {
                let mapScreen =  self.storyboard?.instantiateViewController(identifier: "MapScreen") as! MapViewController
                self.navigationController?.pushViewController(mapScreen, animated: true)
                myUsetDefaults?.set(location[row], forKey: "location")
            }else{
                //GPS
               
                print("Else :GPS")
                locationManager.requestAlwaysAuthorization()
                locationManager.delegate = self
                // For use when the app is open
                locationManager.requestWhenInUseAuthorization()
                // If location services is enabled get the users location
                if CLLocationManager.locationServicesEnabled() {
                    print("Allowed")
                    locationManager.startUpdatingLocation()
                    print("start")
//                    locationManager.requestLocation()
            
                }
                
               
                myUsetDefaults?.set(location[row], forKey: "location")
                
            }
        }
        else if pickerView == unitPicker{
            print("selected \(tempunit[row])")
            /*
             For temperature in Fahrenheit use units=imperial
             For temperature in Celsius use units=metric
             Temperature in Kelvin is used by default, no need to use units parameter in API call
             */
            switch tempunit[row] {
            case "Fahrenheit":
                myUsetDefaults?.set("imperial", forKey: "tempUnit")
                myUsetDefaults?.set("unitsign", forKey: "F")
            case "Celsius":
                myUsetDefaults?.set("metric", forKey: "tempUnit")
                myUsetDefaults?.set("unitsign", forKey: "C")
            default:
                myUsetDefaults?.set("standard", forKey: "tempUnit")
                myUsetDefaults?.set("unitsign", forKey: "K")
            }
            print("form settings\(myUsetDefaults?.object(forKey: "unitsign"))")
            
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       if let error = error as? CLError, error.code == .denied {
        print("error in getting location \(error.localizedDescription)")
          // Location updates are not authorized.
          manager.stopUpdatingLocation()
          return
       }
        print("no Errors")
       // Notify the user of any errors.
    }

    
    
    // Print out the location to the console
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        print(location.first)
        if let location = locations.first {
            print("getting")
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            myUsetDefaults?.set(location.coordinate.latitude, forKey: "lat")
            myUsetDefaults?.set(location.coordinate.longitude, forKey: "lon")

        }
        else{
            print("not working")
        }
    }
    
    /*
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuthorization")
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    // Show the popup to the user if we have been deined access
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "In order to get the Weather Info we need your location",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }*/



}
