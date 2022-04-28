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
    @IBOutlet weak var hourlyTableView: UITableView!
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
        hourlyTableView.dataSource = self
        hourlyTableView.delegate = self
        
        //         Register cell classes
        //        self.mycollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell2")
        self.myTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.hourlyTableView.register(UITableViewCell.self, forCellReuseIdentifier: "hourcell")

        
        
        
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
                self?.currentDescLabel.text = result?.current?.weather?.first?.description
                let ctemp = result?.current?.temp!
                self?.currentTempLabel.text = String(format: "%.2f", ctemp ?? " ") + " C"
                self?.timeZoneLabel.text = result?.timezone ?? " "
                self?.myTable.reloadData()
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
            theReturn = mydays?.count ?? 0
        }
        if tableView == hourlyTableView {
            theReturn = hourly?.count ?? 0
        }
        return theReturn
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell :UITableViewCell?
//        let hourcell = tableView.dequeueReusableCell(withIdentifier: "hourcell", for: indexPath) as! HourTableViewCell
//        let daycell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DaysTableViewCell
        switch tableView {
        case myTable:
            if let cell = cell as? DaysTableViewCell{
//                cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DaysTableViewCell
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
            cell.tempLabel.text = String(format: "%.2f", tempresult ?? "nil" ) + " C"
            cell.descLabel.text = weather?.description ?? "nil"
            // Mark:- Icon
            let icon = weather?.icon ?? " "
            print("theIcon : \(icon)")
            let url = URL(string: "http://openweathermap.org/img/wn/\(icon)@2x.png")
            let image = UIImage(named: "default.png")
            cell.dayImage?.image = image
            cell.dayImage?.kf.setImage(with:  url, placeholder: image , options: nil, progressBlock: nil)

            }
        case hourlyTableView:
            let hourcell = tableView.dequeueReusableCell(withIdentifier: "hourcell", for: indexPath) as! HourTableViewCell
            return hourcell
        default:
            print("default")
        }
        return UITableViewCell()
}
        //Mark : Collection
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 6
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! CustomCollectionViewCell
            cell.myImage.image = UIImage(named: "pressure.jpeg")
            //
            cell.myLabel.text = "clouds"
            
            return cell
        }
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            print("jiiiii")
            //          let width = UIScreen.main.bounds.width / 2
            //            return CGSize(width: width, height: 100)
            var collectionViewSize = collectionView.frame.size
            collectionViewSize.width = collectionViewSize.width/3.0 //Display Three elements in a row.
            collectionViewSize.height = collectionViewSize.height/4.0
            return collectionViewSize
        }
        
        
    }
    

