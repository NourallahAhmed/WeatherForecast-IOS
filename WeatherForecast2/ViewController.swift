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
class ViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    @IBOutlet weak var currentTempLabel: UILabel!
    
    @IBOutlet weak var currentDescLabel: UILabel!
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var timeZoneLabel: UILabel!
    var mydays : [Daily]?
    var hourly : [Hourly]?
    var current : Current?
    var myresponse : AFDataResponse<Reponse>?

    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate = self
        myTable.dataSource = self
        
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mydays?.count ?? 0
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DaysTableViewCell
        
        print("hello!")
        let weather  : Weather?
        weather = (mydays?[indexPath.row].weather)?.first
//        print(mydays?[indexPath.row].dt ?? " ")
        // Create Date
//        let date = NSDate(timeIntervalSince1970: (mydays?[indexPath.row].dt) ?? 000000 )

        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "YY/MM/dd"

        // Convert Date to String
//        dateFormatter.string(from: date as Date)
        print(dateFormatter)
//        print("date \(date)")
//
//        cell.dayLabel.text = date as? String
        
        
        //Temp  and Desc
        
        let tempresult =  mydays?[indexPath.row].temp?.max
        cell.tempLabel.text = String(format: "%.2f", tempresult ?? "nil" ) + " C"
        cell.descLabel.text = weather?.description ?? "nil"

        
        // Icon
        let icon = weather?.icon ?? " "
        print("theIcon : \(icon)")
        let url = URL(string: "http://openweathermap.org/img/wn/\(icon)@2x.png")
        let image = UIImage(named: "default.png")
        cell.dayImage?.image = image
        cell.dayImage?.kf.setImage(with:  url, placeholder: image , options: nil, progressBlock: nil)
        return cell
      }

}


