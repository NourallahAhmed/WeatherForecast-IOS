//
//  ViewController.swift
//  WeatherForecast2
//
//  Created by NourAllah Ahmed on 4/23/22.
//  Copyright © 2022 NourAllah Ahmed. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import CoreLocation

class ViewController: UIViewController , UITableViewDataSource ,UICollectionViewDataSource, UITableViewDelegate , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout , CLLocationManagerDelegate {
    @IBOutlet weak var myCollection: UICollectionView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var currentDescLabel: UILabel!
    
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var timeZoneLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    
    @IBOutlet weak var myHourlyCollection: UICollectionView!
    let locationManager = CLLocationManager()
    
    var myUserDefaults : UserDefaults?
    var mydays : [Daily]?
    var myhourly : [Hourly]?
    var current : Current?
    var myresponse : Reponse?
    var myUserDefault = UserDefaults.standard
    var unit :String?
    var unitsign :String?
    var lat : String?
    var lon : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myUserDefaults = UserDefaults.standard
        //set the size of scrollView
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + myCollection.contentSize.height)
        print(myUserDefaults?.double(forKey: "lat"))
//        if(myUserDefaults?.double(forKey: "lat") != 0.0){
//            getDataFromUserDefault()
//            sendRequest()
//            
//        }
        myTable.delegate = self
        myTable.dataSource = self
        //to display -> pressure and windspeed and so on
        myCollection.delegate = self
        myCollection.dataSource = self
        //        myCollection.layoutIfNeeded()
        
        //to display -> the temp each hour (( will be displayed horizontaly ))
        myHourlyCollection.delegate = self
        myHourlyCollection.dataSource = self
        
        
    }
    
    
    // MARK: VIEW DID APPEAR
    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height +  myCollection.contentSize.height)
        getDataFromUserDefault()
        
        if(myUserDefaults?.double(forKey: "lat") == 0.0){
        let alert : UIAlertController = UIAlertController(title: "Settings", message: "How to set your Location", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "MAP", style: .default, handler: {action  in
            let mapScreen =  self.storyboard?.instantiateViewController(identifier: "MapScreen") as! MapViewController
            self.navigationController?.pushViewController(mapScreen, animated: true)
            print("MAP")
            
        }))
        
        alert.addAction(UIAlertAction(title: "GPS", style: .default, handler: {action  in self.getLocationGPS()} ))
        
        self.present(alert , animated: true , completion: nil)
        }
        sendRequest()
        myTable.delegate = self
        myTable.dataSource = self
        //to display -> pressure and windspeed and so on
        myCollection.delegate = self
        myCollection.dataSource = self
        
        //to display -> the temp each hour (( will be displayed horizontaly ))
        myHourlyCollection.delegate = self
        myHourlyCollection.dataSource = self
        print("ViewDidAppear")
        //        myCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell2")
        
    }
    
    // MARK: DATA FROM USERDEFAULTS
    
    func getDataFromUserDefault(){
        //unit
        unit = myUserDefault.object(forKey: "tempUnit")  as? String
        unit = (unit == nil) ?  "standard" :  unit
        
        lat =  myUserDefault.double(forKey: "lat").description
        lon =  myUserDefault.double(forKey: "lon").description
        
        print("lat : \(lat)  lon : \(String(describing: lon))")
        /*
         For temperature in Fahrenheit use units=imperial
         For temperature in Celsius use units=metric
         Temperature in Kelvin is used by default, no need to use units parameter in API call
         */
        switch unit {
        case "imperial":
            unitsign = "F"
        case "metric":
            unitsign = "C"
            
        default:
            unitsign = "K"
        }
    }
    // MARK: DATA FROM NETWORK
    
    func sendRequest() {
        //NetworkIndecator
        let myIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        myIndicator.center = self.view.center
        self.view.addSubview(myIndicator)
        myIndicator.startAnimating()
        
        
        // MARK: ALAMOFIRE
        
        //assign parameters
        let parameters = ["lon": lon! , "lat": lat! ,"appid": "00cc0edd6a289076e66954faceaf9259" ,"units": unit!] as [String : Any]
        print("laaaat \(String(describing: parameters["lon"]))")
        
        AF.request("https://api.openweathermap.org/data/2.5/onecall?",parameters: parameters)
            .responseJSON(completionHandler:{[weak self] response in
                
                //get request on type data
                guard let reponse = response.data else {
                    return
                }
                do {
                    print("inside the do")
                    //                    print("request \(response.value)")
                    let result = try JSONDecoder().decode(Reponse.self, from: reponse)
                    print( result.timezone)
                    myIndicator.stopAnimating()
                    DispatchQueue.main.async {
                        myIndicator.stopAnimating()
                        self?.timeZoneLabel.text = result.timezone
                        self?.currentDescLabel.text = result.current?.weather?.first?.description
                        
                        let ctemp = result.current?.temp!
                        self?.currentTempLabel.text = String(format: "%.2f", ctemp ?? " ") + String( (self?.unitsign)!)
                        
                        self?.current = result.current
                        
                        self?.mydays = result.daily
                        
                        //MARK : problem in hourly class
                        self?.myhourly = result.hourly
                        
                        //reload data
                        self?.myTable.reloadData() // daily
                        self?.myHourlyCollection.reloadData() //hourly
                        self?.myCollection.reloadData()
                        myIndicator.stopAnimating()

                        print("finish")
                        
                    }
                    myIndicator.stopAnimating()

                }
                catch let error{
                    print("error : \(error.localizedDescription)")
                }
                
                
            })
        
        
    }
    
    
    // MARK: --------------------------->  Table <---------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var theReturn = 0
        if tableView == myTable{
            theReturn = mydays?.count ?? 0
        }
        return theReturn
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DaysTableViewCell {
            
            let weather  : Weather?
            weather = (mydays?[indexPath.row].weather)?.first
            
            
            //MARK:- DAY
            
            let tdate = Date(timeIntervalSince1970: TimeInterval(mydays?[indexPath.row].dt ?? 0.0 ))
            let formatter = DateFormatter()
            //formatter.timeZone = TimeZone(abbreviation: "UTC")
            formatter.dateFormat = "EE" //"HH:mm"
            //formatter.dateFormat = "yyyy-MM-dd"
            cell.dayLabel.text = formatter.string(from: tdate)
            
            // MARK:- Temp  and Desc
            let tempresult =  mydays?[indexPath.row].temp?.max
            cell.tempLabel.text = String(format: "%.2f", tempresult ?? "nil" ) + unitsign!
            cell.descLabel.text = weather?.description ?? "nil"
            
            // MARK:- Icon
            let icon = weather?.icon ?? "nil"
            print("theIcon : \(icon)")
            let url = URL(string: "http://openweathermap.org/img/wn/\(icon)@2x.png")
            let image = UIImage(named: "default.png")
            cell.dayImage?.image = image
            cell.dayImage?.kf.setImage(with:  url, placeholder: image , options: nil, progressBlock: nil)
            
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    
    
    //MARK: ---------------------------> Collection <---------------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == myCollection {
            return 6
        }
        else{
            print("start")
            return self.myhourly?.count ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("hello from collectionView cell for item ar")
        if( collectionView == myCollection){
            let cell = myCollection.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! CustomCollectionViewCell
            
            let myData = ["Clouds" ,"Pressure" , "Humidity", "Wind","UltraViolet","Visibility"]
            switch myData[indexPath.row]{
                
            case "Clouds":
                print(myData[indexPath.row])
                
                cell.myImage.image = UIImage(named: "cloud.jpeg")
                cell.myLabel.text = myData[indexPath.row]
                cell.myDataLabel.text = String(format: "%.2d", self.current?.clouds ?? " ") + " %"
                break
            case "Pressure":
                print(myData[indexPath.row])
                
                cell.myImage.image = UIImage(named: "pressure.jpeg")
                cell.myLabel.text = myData[indexPath.row]
                let pressure = self.current?.pressure
                cell.myDataLabel.text = String(format: "%.2d", pressure ?? "nil" ) + " hpa"
                break
            case "Humidity":
                print(myData[indexPath.row])
                
                cell.myImage.image = UIImage(named: "drop.png")
                cell.myLabel.text = myData[indexPath.row]
                cell.myDataLabel.text = String(format: "%.2d", self.current?.humidity ?? " ") + " %"
                break
            case "Wind":
                print(myData[indexPath.row])
                
                cell.myImage.image = UIImage(named: "wind.jpeg")
                cell.myLabel.text = myData[indexPath.row]
                cell.myDataLabel.text = String(format: "%.2f", self.current?.windSpeed ?? " ") + " m/s"
                break
            case "UltraViolet":
                print(myData[indexPath.row])
                
                cell.myImage.image = UIImage(named: "ultrviolt.jpeg")
                cell.myLabel.text = myData[indexPath.row]
                cell.myDataLabel.text = String(format: "%.2f", self.current?.uvi ?? " ") + "m"
                break
            case "Visibility":
                print(myData[indexPath.row])
                
                cell.myImage.image = UIImage(named: "visible.jpeg")
                cell.myLabel.text = myData[indexPath.row]
                cell.myDataLabel.text = String(format: "%.2d", self.current?.visibility ?? " ")
                break
            default: break
                
                
            }
            return cell
            
        }
        else if let cell = myHourlyCollection.dequeueReusableCell(withReuseIdentifier: "hourcell", for: indexPath) as? HourlyCollectionViewCell{
            
            print("welcome")
            let tempresult =  myhourly?[indexPath.row].temp
            print(tempresult!)
            //MARK:- hour
            let tdate = Date(timeIntervalSince1970: TimeInterval(myhourly?[indexPath.row].dt ?? 0.0 ))
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:aa"
            cell.myHourlyTimeLabel.text = formatter.string(from: tdate)
            
            cell.myHourlyTempLabel.text = String(tempresult!) + String(unitsign!)
            
            let icon = myhourly?[indexPath.row].weather?.first?.icon ?? "nil"
            print("theIcon : \(icon)")
            let url = URL(string: "http://openweathermap.org/img/wn/\(icon)@2x.png")
            let image = UIImage(named: "default.png")
            cell.myhourlyImageView?.image = image
            cell.myhourlyImageView?.kf.setImage(with:  url, placeholder: image , options: nil, progressBlock: nil)
            
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        var collectionViewSize = collectionView.frame.size
    //        if collectionView == myCollection {
    //            collectionViewSize.width = collectionViewSize.width/3.0 //Display Three elements in a row.
    //            //            collectionViewSize.height = collectionViewSize.height/4.0
    //        }
    //        return collectionViewSize
    //    }
    //
    func getLocationGPS(){
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        // For use when the app is open
        locationManager.requestWhenInUseAuthorization()
        // If location services is enabled get the users location
        if CLLocationManager.locationServicesEnabled() {
            print("Allowed")
            locationManager.startUpdatingLocation()
            print("start")
            //                    locationManager.requestLocation()
        }
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
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
            if let location = locations.first {
                print("getting")
                print(location.coordinate.latitude)
                print(location.coordinate.longitude)
                myUserDefaults?.set(location.coordinate.latitude, forKey: "lat")
                myUserDefaults?.set(location.coordinate.longitude, forKey: "lon")
                
            }
            else{
                print("not working")
            }
        }
    }
}



