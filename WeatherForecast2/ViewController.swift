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


class ViewController: UIViewController , UITableViewDataSource ,UICollectionViewDataSource, UITableViewDelegate , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var myCollection: UICollectionView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var currentDescLabel: UILabel!
    
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var timeZoneLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    
    @IBOutlet weak var myHourlyCollection: UICollectionView!
    var mydays : [Daily]?
    var myhourly : [Hourly] = []
    var current : Current?
    var myresponse : Reponse?
    var myUserDefault = UserDefaults.standard
    var unit :String?
    var unitsign :String?
    var lat : Double?
    var lon : Double?
    override func viewDidLoad() {
        super.viewDidLoad()
      
        //set the size of scrollView
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + myCollection.contentSize.height)
        
        getDataFromUserDefault()
        sendRequest()
        myTable.delegate = self
        myTable.dataSource = self
        //to display -> pressure and windspeed and so on
        myCollection.delegate = self
        myCollection.dataSource = self
        
        
        //to display -> the temp each hour (( will be displayed horizontaly ))
        myHourlyCollection.delegate = self
        myHourlyCollection.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
         scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height +  myCollection.contentSize.height)
        getDataFromUserDefault()
        sendRequest()
        myTable.delegate = self
        myTable.dataSource = self
    }
    
    //Mark :  ---------------------------> Data from user default <---------------------------
    
    func getDataFromUserDefault(){
        //unit
        unit = myUserDefault.object(forKey: "tempUnit")  as? String
        unit = (unit == nil) ?  "standard" :  unit
        
        //lat and lon
        lat =  31.205753
        lon = 29.924526
//        lat =  myUserDefault.double(forKey: "lat")
//        lon =  myUserDefault.double(forKey: "lon")

        print("lat : \(String(describing: lat))  lon : \(String(describing: lon))")
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
    // network
    func sendRequest() {
        //NetworkIndecator
        let myIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        myIndicator.center = self.view.center
        self.view.addSubview(myIndicator)
        myIndicator.startAnimating()
        
        
        // Mark : ---------------------------> trying AlamoFire <---------------------------
        
        //assign parameters
        let parameters = ["lon": lon! , "lat": lat! ,"appid": "00cc0edd6a289076e66954faceaf9259" ,"unit": unit!] as [String : Any]
        print("laaaat \(String(describing: parameters["lon"]))")
        
        AF.request("https://api.openweathermap.org/data/2.5/onecall?",parameters: parameters)
            .responseJSON(completionHandler:{[weak self] response in
               
                //get request on type data
                guard let reponse = response.data else {
                    return
                }
                do {
                    print("inside the do")
                    let result = try JSONDecoder().decode(Reponse.self, from: reponse)
                    DispatchQueue.main.async {
                        myIndicator.stopAnimating()
                        self?.timeZoneLabel.text = result.timezone
                        self?.currentDescLabel.text = result.current?.weather?.first?.description
                        
                        let ctemp = result.current?.temp!
                        self?.currentTempLabel.text = String(format: "%.2f", ctemp ?? " ") + String( (self?.unitsign)!)
                        
                        self?.current = result.current

                        self?.mydays = result.daily

                        //MARK : problem in hourly class
//                        self.myhourly = result.hourly ?? []
//                        print("hourly \(String(describing: result.hourly?.first))")
                        
                        //reload data
                        self?.myTable.reloadData() // daily
//                        self?.myTable.layoutIfNeeded()
                        self?.myHourlyCollection.reloadData() //hourly
//                        self?.myCollection.layoutIfNeeded()
                        print("finish")
                        
                    }
                }
                catch let error{
                    print("error : \(error.localizedDescription)")
                }
        
    
            })

   
}
        
        
        // Mark: --------------------------->  Table <---------------------------
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
                // Create Date
                //let date = NSDate(timeIntervalSince1970: (mydays?[indexPath.row].dt) ?? 000000 )
                // Create Date Formatter
                let dateFormatter = DateFormatter()
                // Set Date Format
                dateFormatter.dateFormat = "YY/MM/dd"
                // Convert Date to String
                //dateFormatter.string(from: date as Date)
                //print("date \(date)")
//                cell.dayLabel.text = date as? String
                
                // Mark:- Temp  and Desc
                let tempresult =  mydays?[indexPath.row].temp?.max
                cell.tempLabel.text = String(format: "%.2f", tempresult ?? "nil" ) + unitsign! ?? "nil"
                cell.descLabel.text = weather?.description ?? "nil"
                
                // Mark:- Icon
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
        
        
        
         //Mark : ---------------------------> Collection <---------------------------
         
         func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//         print("collection!")
            if collectionView == myHourlyCollection {
                return self.myhourly.count ?? 0
            }
            else{
                return 6
            }
         
         }
         
         
         
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        print("almost there")
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as? CustomCollectionViewCell{
//            print("okay")
            cell.myImage.image = UIImage(named: "pressure.jpeg")
            cell.myLabel.text = "clouds"
            cell.myDataLabel.text = "90"
            return cell

        }

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourcell", for: indexPath) as? HourlyCollectionViewCell{
            
            print("welcome")
//            let tempresult =  myhourly[indexPath.row].temp
//            cell.myHourlyTempLabel.text = "\(tempresult) \(unitsign)" ?? "nil"// String(format: "%.2f", tempresult ?? "nil" ) + unitsign
//            cell.myHourlyTimeLabel.text = "\(myhourly[indexPath.row].dt)" ?? "nil" //String(format: "%.2f",  hourly?[indexPath.row].dt ?? " ")
            cell.myhourlyImageView.image = UIImage (named: "default.png")
            
            return cell
        }
     return UICollectionViewCell()
    }
         
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var collectionViewSize = collectionView.frame.size
        if collectionView == myCollection {
            collectionViewSize.width = collectionViewSize.width/3.0 //Display Three elements in a row.
//            collectionViewSize.height = collectionViewSize.height/4.0
            }
        return collectionViewSize
    }
         
        
}


