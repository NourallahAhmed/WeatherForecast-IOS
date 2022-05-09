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
import Network


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
    
    var alert : UIAlertController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myUserDefaults = UserDefaults.standard
        //set the size of scrollView
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + myCollection.contentSize.height)
        print(myUserDefaults?.double(forKey: "lat"))
   
        myTable.delegate = self
        myTable.dataSource = self
        //to display -> pressure and windspeed and so on
        myCollection.delegate = self
        myCollection.dataSource = self
        //to display -> the temp each hour (( will be displayed horizontaly ))
        myHourlyCollection.delegate = self
        myHourlyCollection.dataSource = self
    }
    
    
    // MARK: VIEW DID APPEAR
    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height +  myCollection.contentSize.height)
        getDataFromUserDefault()
        
        if(myUserDefaults?.integer(forKey: "check") == 0){
             alert = UIAlertController(title: "Settings", message: "How to set your Location", preferredStyle: .alert)
            alert?.addAction(UIAlertAction(title: "MAP", style: .default, handler: {action  in
                let mapScreen =  self.storyboard?.instantiateViewController(identifier: "MapScreen") as! MapViewController
                self.navigationController?.pushViewController(mapScreen, animated: true)
                
                self.myUserDefault.set(1, forKey: "check")
                self.sendRequest()
                print("MAP")
                
            }))
            
            alert?.addAction(UIAlertAction(title: "GPS", style: .default, handler: {action  in
                self.getLocationGPS()
                self.myUserDefault.set(1, forKey: "check")

            } ))
            
            self.present(alert! , animated: true , completion: nil)
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
        self.myTable.reloadData()
                self.myHourlyCollection.reloadData()
                self.myCollection.reloadData()
                
    }
    // MARK: DATA FROM NETWORK
    
    func sendRequest() {
        //NetworkIndecator
        let myIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        myIndicator.center = self.view.center
        self.view.addSubview(myIndicator)
        myIndicator.startAnimating()
        
        
        // MARK: ALAMOFIRE
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "InternetConnectionMonitor")
        
        //assign parameters
        let parameters = ["lon": lon! , "lat": lat! ,"appid": "00cc0edd6a289076e66954faceaf9259" ,"units": unit!] as [String : Any]
        // check network
        monitor.pathUpdateHandler = { pathUpdateHandler  in
           
            print("entered")
            if pathUpdateHandler.status == .satisfied {
                print("Internet connection is on.")
                print("laaaat \(String(describing: parameters["lon"]))")
                AF.request("https://api.openweathermap.org/data/2.5/onecall?",parameters: parameters)
                    .responseJSON(completionHandler:{[weak self] response in
                        
                        //get request on type data
                        guard let reponse = response.data else {return}
                        do {
                            let result = try JSONDecoder().decode(Reponse.self, from: reponse)
                            myIndicator.stopAnimating()
                            DispatchQueue.main.async {
                                myIndicator.stopAnimating()
                                self?.timeZoneLabel.text = result.timezone
                                self?.currentDescLabel.text = result.current?.weather?.first?.description
                                let ctemp = result.current?.temp!
                                self?.currentTempLabel.text = String(format: "%.2f", ctemp ?? " ") + String( (self?.unitsign)!)
                                self?.current = result.current
                                self?.mydays = result.daily
                                self?.myhourly = result.hourly
                                
                                //reload data
                                self?.myTable.reloadData() // daily
                                self?.myHourlyCollection.reloadData() //hourly
                                self?.myCollection.reloadData()
                            }}
                        catch let error{
                            print("error : \(error.localizedDescription)")
                        }})
            } else
            {
                print("No Internet Connection")
                DispatchQueue.main.async {
                    let alert : UIAlertController = UIAlertController(title: "ERROR", message: "Please check your internet connection", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in
                        self.sendRequest()} ))
                    self.present(alert , animated: true , completion: nil)
                }
               

            }
        }
        monitor.start(queue: queue)
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
    
    func getLocationGPS(){
        print("getLocationGPS")
//        locationManager.requestAlwaysAuthorization()
        // For use when the app is open
        locationManager.requestWhenInUseAuthorization()
        // If location services is enabled get the users location
        print(CLLocationManager.locationServicesEnabled() )
        if CLLocationManager.locationServicesEnabled() {
            print("getLocationGPS")

            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        }
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
//            if let location = locations.first
            guard let loc : CLLocationCoordinate2D = manager.location?.coordinate else{
                return
            }
            lat = String(format: "%.2f" , loc.latitude )
            lon = String(format: "%.2f" , loc.longitude )
            print("from GPS \(lat)\(lon)")

            myUserDefaults?.set(loc.latitude, forKey: "lat")
            myUserDefaults?.set(loc.longitude, forKey: "lon")
            print("Sending request")
            self.sendRequest()
            print("request sended")

        
        }
    }




