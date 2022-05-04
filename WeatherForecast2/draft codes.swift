//
//  draft codes.swift
//  WeatherForecast2
//
//  Created by NourAllah Ahmed on 4/30/22.
//  Copyright © 2022 NourAllah Ahmed. All rights reserved.
//

import Foundation
// unitsign
        
/*
        unitsign = myUserDefault?.object(forKey: "unitsign") as? String
        print("unitsign = \(String(describing: unitsign))")

        unitsign = (unitsign == nil) ?  "K" :  unitsign
        print("unitsign after check = \(String(describing: unitsign))")
        print("form Home\(myUserDefault?.object(forKey: "unitsign"))")
*/

/*
            
             let mynetwork = NetworkDelegate()
             mynetwork.getRequest(complitionHandler: {[weak self](result) in
             //table reload
             DispatchQueue.main.async {
             myIndicator.stopAnimating()
            print("network result \(result)")
             print(result?.lat)
             // Mark :- set the array of daily and hourly information
             self?.mydays = result?.daily
             self?.hourly = result?.hourly


             // Mark :- set current temp
             self?.currentDescLabel.text = result?.current?.weather?.first?.description
             let ctemp = result?.current?.temp!
                self?.currentTempLabel.text = String(format: "%.2f", ctemp ?? " ") + String( (self?.unitsign)!) ?? "nil"
                self?.timeZoneLabel.text = result?.timezone ?? "nil"
                
                //reload data
                self?.myTable.reloadData()
                self?.myHourlyCollection.reloadData()
             
             //                self?.mycollection.reloadData()
             }
             } ,lon: 29.924526 , lat: 31.205753 , unit: unit! )
             */

   /*
        switch(response.result){
        case .success(_):
            do {
                let result = try JSONDecoder().decode([Reponse].self, from: reponse)
                print(result)
            }
            catch let error{
                print("error : \(error.localizedDescription)")
            }
            
        case .failure(_):
            
            print("ERROR")
        }
            
*/  
 /*
          
         let mynetwork = NetworkDelegate()
         mynetwork.getRequest(complitionHandler: {[weak self](result) in
             //table reload
             DispatchQueue.main.async {
                 myIndicator.stopAnimating()
 //                print("network result \(result)")
             }
             }
             , lon: 29.924526 , lat: 31.205753 , unit: unit! )
 */
/*
 //Register cell classes
       /*
        mycollection.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "cell2")
        
        
        
        // --> try the nib
        var nib = UINib(nibName: "UICollectionElementKindCell", bundle:nil)
        self.mycollection
        .register(nib, forCellWithReuseIdentifier: "cell2")
        
        
        */
       
 */

/*
 print("hourly: \n dt: \(String(describing: result.hourly?.first?.dt)) \n clouds: \(String(describing: result.hourly?.first?.clouds)) \n Temp: \(String(describing: result.hourly?.first?.temp)) \n feelslike: \(String(describing: result.hourly?.first?.feels_like)) \n pressure: \(String(describing: result.hourly?.first?.pressure))\n dewPoint: \(String(describing: result.hourly?.first?.dew_point)) \n humidity: \(String(describing: result.hourly?.first?.humidity))\n uvi: \(String(describing: result.hourly?.first?.uvi))\n visibility: \(String(describing: result.hourly?.first?.visibility))\n windspeed: \(String(describing: result.hourly?.first?.wind_speed))\n winddeg: \(String(describing: result.hourly?.first?.wind_deg))\n windgust: \(String(describing: result.hourly?.first?.wind_gust))\n windgust: \(String(describing: result.hourly?.first?.wind_gust))")
                       
 */
/*
   let date = NSDate() // current date
             
             let unixtime = date.timeIntervalSince1970
             var epocTime = TimeInterval(mydays?[indexPath.row].dt ?? 0.0)
             
             let myDate = NSDate(timeIntervalSince1970: epocTime)
 //            print("Converted Time \(myDate)")

             let dateFormatterPrint = DateFormatter()
             dateFormatterPrint.dateFormat = "MMM dd,yyyy"
             var datetry = dateFormatterPrint.date(from: myDate.description)
             cell.dayLabel.text = datetry?.description
 //            print("Converted Time \(datetry?.description)")
 */
/*
 // Create Date
       //let date = NSDate(timeIntervalSince1970: (mydays?[indexPath.row].dt) ?? 000000 )
       // Create Date Formatter
       let dateFormatter = DateFormatter()
       // Set Date Format
       dateFormatter.dateFormat = "YY/MM/dd"
       // Convert Date to String
       //print("date \(date)")
       //                cell.dayLabel.text = date as? String
       
       
 */
/*
 //MARK:- try to download again
 
 guard let newUrl=url else {
     return cell
 }
 DispatchQueue.global(qos: .userInteractive).async {
     do{
         let data = try Data(contentsOf: newUrl)
         DispatchQueue.main.async { [weak self] in
             cell.dayImage.image = UIImage(data: data)
             
         }
         
     }catch{
         
     }
 }
 */
