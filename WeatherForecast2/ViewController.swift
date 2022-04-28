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
class ViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentDescLabel: UILabel!
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var timeZoneLabel: UILabel!
    @IBOutlet weak var mycollection: UICollectionView!
    @IBOutlet weak var hourCollection: UICollectionView!
    var mydays : [Daily]?
    var hourly : [Hourly]?
    var current : Current?
    var myresponse : AFDataResponse<Reponse>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate = self
        myTable.dataSource = self
        mycollection.delegate = self
        mycollection.dataSource = self
        hourCollection.delegate = self
        hourCollection.dataSource = self
        //Register cell classes
        //        self.mycollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell2")
        //        self.myTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //        self.hourlyTableView.register(UITableViewCell.self, forCellReuseIdentifier: "hourcell")
        
        
        
        
        //         self.myTable.register(UITableViewCell.self, forCellWithReuseIdentifier: "cell")
        //NetworkIndecator
        let myIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        myIndicator.center = self.view.center
        self.view.addSubview(myIndicator)
        myIndicator.startAnimating()
        //trying AlamoFire
        
        //assign parameters
        //let parameters = ["lon":29.924526, "lat": 31.205753 ,"appid": "00cc0edd6a289076e66954faceaf9259" ] as [String : Any]
        /*
         AF.request("https://api.openweathermap.org/data/2.5/onecall?",parameters: parameters).responseJSON(completionHandler:{ response in
         debugPrint("Response: \(response)")
         print("Response: \(response)")
         self.myresponse = response })
         */
        /*
         AF.request("https://api.openweathermap.org/data/2.5/onecall?",parameters: parameters).responseDecodable(of: Reponse.self, completionHandler: { response in
         //             debugPrint("Response: \(response)")
         print("Response2: \(response)")
         self.myresponse = response })
         
         print(myresponse as Any)
         
         */
        
        let mynetwork = NetworkDelegate()
        mynetwork.getRequest(complitionHandler: {[weak self](result) in
            //table reload
            DispatchQueue.main.async {
                myIndicator.stopAnimating()
                print(result?.lat)
                self?.mydays = result?.daily
                self?.hourly = result?.hourly
                
                
                // Mark: set current temp
                self?.currentDescLabel.text = result?.current?.weather?.first?.description
                let ctemp = result?.current?.temp!
                self?.currentTempLabel.text = String(format: "%.2f", ctemp ?? " ") + " C"
                self?.timeZoneLabel.text = result?.timezone ?? " "
                
                //reload data
                self?.myTable.reloadData()
                
//                self?.mycollection.reloadData()
                self?.hourCollection.reloadData()
            }
            } ,lon: 29.924526 , lat: 31.205753 , unit: "metric")
        
    }
    
    
    
    
    // Mark: Table
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var theReturn = 0
        if tableView == myTable{
            print("mytable")
            theReturn = mydays?.count ?? 0
        }
//        else if tableView == hourlyTableView {
//            print("hourtable")
//            theReturn = 0
//        }
        return theReturn
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DaysTableViewCell {
            
            print("hello ")
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
            print(dateFormatter)
            //print("date \(date)")
            //cell.dayLabel.text = date as? String
            
            // Mark:- Temp  and Desc
            let tempresult =  mydays?[indexPath.row].temp?.max
            cell.tempLabel.text = String(format: "%.2f", tempresult ?? "nil" ) + " C" ?? " nil"
            cell.descLabel.text = weather?.description ?? "nil"
            // Mark:- Icon
            let icon = weather?.icon ?? " "
            print("theIcon : \(icon)")
            let url = URL(string: "http://openweathermap.org/img/wn/\(icon)@2x.png")
            let image = UIImage(named: "default.png")
            cell.dayImage?.image = image
            cell.dayImage?.kf.setImage(with:  url, placeholder: image , options: nil, progressBlock: nil)
            return cell
            
        }
            
//        else if let cell = tableView.dequeueReusableCell(withIdentifier: "hourcell", for: indexPath) as? HourTableViewCell{
//            return cell
//
//        }
        return UITableViewCell()
        
    }
    //Mark : Collection
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hourCollection {
//            print("hello : \(hourly?.count)")
//            return hourly?.count ?? 1
            return 3
        }else{
            return 6
        }
       
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("almost there")
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as? CustomCollectionViewCell{
            print("okay")
        cell.myImage.image = UIImage(named: "pressure.jpeg")
        cell.myLabel.text = "clouds"
        
            return cell
            
        }
        else if let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "hourcell", for: indexPath) as? HourlyCollectionViewCell{
            print("welcome")
//            let tempresult =  hourly?[indexPath.row].temp
            cell.tempLabel.text = "90" //String(format: "%.2f", tempresult ?? "nil" ) + " C"
            cell.hourLabel.text = "sun" // String(format: "%.2f",  hourly?[indexPath.row].dt ?? " ") 
            cell.myImageView.image = UIImage (named: "default.png")
            return cell
        }
        return UICollectionViewCell()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == hourCollection{
            print("ana hena")
            return 1
        }
        else{
            return 1
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var collectionViewSize = collectionView.frame.size
        collectionViewSize.width = collectionViewSize.width/3.0 //Display Three elements in a row.
        collectionViewSize.height = collectionViewSize.height/4.0
        return collectionViewSize
    }
    
    
}


