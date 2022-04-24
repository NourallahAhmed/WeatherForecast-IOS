//
//  ViewController.swift
//  WeatherForecast2
//
//  Created by NourAllah Ahmed on 4/23/22.
//  Copyright © 2022 NourAllah Ahmed. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {

    @IBOutlet weak var myTable: UITableView!
    var mydays : [Daily]?
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate = self
        
        //NetworkIndecator
        let myIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        myIndicator.center = self.view.center
            self.view.addSubview(myIndicator)
            myIndicator.startAnimating()
        let mynetwork = NetworkDelegate()
        mynetwork.getRequest(complitionHandler: {[weak self](result) in
            //table reload
            DispatchQueue.main.async {
                
                print(result?.daily)
                myIndicator.stopAnimating()
                self?.mydays = result?.daily
                self?.myTable.reloadData()
            }
            } , lon: 0.0 , lat: 0.0)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 7
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DaysTableViewCell
        var weather  : Weather = (mydays?[indexPath.row].weather)![0]
        print(weather.description)
        cell.descLabel.text = weather.description
        return cell
      }

}

