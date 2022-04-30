//
//  SettingsViewController.swift
//  WeatherForecast2
//
//  Created by NourAllah Ahmed on 4/28/22.
//  Copyright © 2022 NourAllah Ahmed. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource {
    
    
    
    @IBOutlet weak var unitPicker: UIPickerView!
    @IBOutlet weak var locationPicker: UIPickerView!
    
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
            var mapScreen =  self.storyboard?.instantiateViewController(identifier: "MapScreen") as! MapViewController
                self.navigationController?.pushViewController(mapScreen, animated: true)
                myUsetDefaults?.set(location[row], forKey: "location")
            }else{
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
            case "Celsius":
                myUsetDefaults?.set("metric", forKey: "tempUnit")
            default:
                myUsetDefaults?.set("standard", forKey: "tempUnit")
            }

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
    
}
