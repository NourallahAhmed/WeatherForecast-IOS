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
