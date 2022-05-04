//
//  Model.swift
//  WeatherForecast2
//
//  Created by NourAllah Ahmed on 4/23/22.
//  Copyright © 2022 NourAllah Ahmed. All rights reserved.
//

import Foundation

class Reponse : Codable {
    let lat: Double?
    let lon: Double?
    let timezone: String?
    let timezoneOffset: Int?
    let current: Current?
    let hourly: [Hourly]?
    let daily: [Daily]?

}

class Alerts : Decodable{
    var senderName : String?
    var event : String?
    var start : Int?
    var end : Int?
    var description : String?
    var tags : [String]?
}
class Current : Codable  {
    let dt: Int?
    let sunrise: Int?
    let sunset: Int?
    let temp: Double?
    let feelsLike: Double?
    let pressure: Int?
    let humidity: Int?
    let dewPoint: Double?
    let uvi: Double?
    let clouds: Int?
    let visibility: Int?
    let windSpeed: Double?
    let windDeg: Int?
    let weather: [Weather]?    
}

class Weather :Codable{
   let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

class Hourly :Codable {
    let dt: Double?
    let temp: Double?
    let feels_like: Double?
    let pressure: Int?
    let humidity: Int?
    let dew_point: Double?
    let uvi: Double?
    let clouds: Int?
    let visibility: Int?
    let wind_speed: Double?
    let wind_deg: Double?
    let wind_gust: Double?
    let weather: [Weather]?
    let pop: Int?


}
class Daily :Codable {
    
    let dt: Double?
    let sunrise: Int?
    let sunset: Int?
    let moonrise: Int?
    let moonset: Int?
    let moonPhase: Double?
    let temp: Temp?
    let feelsLike: FeelsLike?
    let pressure: Int?
    let humidity: Int?
    let dewPoint: Double?
    let windSpeed: Double?
    let windDeg: Int?
    let windGust: Double?
    let weather: [Weather]?
    let clouds: Int?
    let pop: Int?
    let uvi: Double?

}
class Temp : Codable{
    
    let day: Double?
    let min: Double?
    let max: Double?
    let night: Double?
    let eve: Double?
    let morn: Double?
    
}
class FeelsLike : Codable{
    
     let day: Double?
     let night: Double?
     let eve: Double?
     let morn: Double?
    
//    let day: String?
//    let night: String?
//    let eve: String?
//    let morn: String?
}

