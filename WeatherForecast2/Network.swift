//
//  Network.swift
//  WeatherForecast2
//
//  Created by NourAllah Ahmed on 4/23/22.
//  Copyright © 2022 NourAllah Ahmed. All rights reserved.
//

import Foundation

class NetworkDelegate{
    //passing clousre -> escaping
    func getRequest(complitionHandler: @escaping (Reponse?) -> Void  , lon:Double , lat : Double){
         
        print(lat )
         // 1 URL
         let myUrl = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&appid=00cc0edd6a289076e66954faceaf9259")
        guard let newUrl = myUrl else {
             print("Error while unwrapping URL")
             return
         }
        
        print(newUrl)
        // 2 Request
         let myRequest = URLRequest(url: newUrl)
         
         // 3 session
         let mySession = URLSession(configuration: .default)
         
        // 4 task
        print("going to task")
         let myTask = mySession.dataTask(with: myRequest) { (rdata, response, error) in
             guard let data =  rdata else {
                print("data from guard : \(String(describing: rdata))")
                 return
             }
            print(" inside task")
            print("the date : \(data)")
            do {
                 print("inside the do")

                 let result = try JSONDecoder().decode(Reponse.self, from: data)
                    print("the result :\(result.lat)")
                    complitionHandler(result)
             }
             catch let error{
                 print("error : \(error.localizedDescription)")
                 complitionHandler(nil)

             }
         }
         
         
         // 5 resume
         
         myTask.resume()
     }
     
}
