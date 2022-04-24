//
//  Model.swift
//  WeatherForecast2
//
//  Created by NourAllah Ahmed on 4/23/22.
//  Copyright © 2022 NourAllah Ahmed. All rights reserved.
//

import Foundation

class Reponse : Decodable{
    var lat : Double?
    var lon : Double?
    var timezone : String?
    var timezone_offset : Double?
    var current : Current?
    var hourly : [Hourly]?
    var daily : [Daily]?
}
class Current :Decodable{
    var dt : Int?
    var sunrise : Int?
    var sunset : Int?
    var temp : Float?
    var feels_like : Float?
    var pressure : Int?
    var humidity : Int?
    var dew_point : Float?
    var uvi : Int?
    var clouds : Int?
    var visibility : Int?
    var wind_speed :Float?
    var wind_deg : Int?
    var wind_gust : Float?
    var weather : [Weather]?
}
class Weather :Decodable{
    var id : Int?
    var main : String?
    var description : String?
    var icon : String?
}
class Hourly :Decodable {
    var dt : Int?
    var temp : Float?
    var feels_like : Float?
    var pressure : Int?
    var humidity : Int?
    var dew_point : Float?
    var uvi : Int?
    var clouds : Int?
    var visibility : Int?
    var wind_speed :Float?
    var wind_deg : Int?
    var wind_gust : Float?
    var weather : [Weather]?
    var pop : Int?
}
class Daily :Decodable {
    var dt : Int?
    var sunrise : Int?
    var sunset : Int?
    var moonrise : Int?
    var moonset : Int?
    var moon_phase :Float?
    var temp :Temp?
    var feels_like : Feels_like?
    var pressure : Int?
    var humidity : Int?
    var dew_point : Float?
    var uvi : Int?
    var clouds : Int?
    var visibility : Int?
    var wind_speed :Float?
    var wind_deg : Int?
    var wind_gust : Float?
    var weather : [Weather]?
    var pop : Float?
    var rain : Float?
    
}
class Temp : Decodable{
    var day : Float?
    var min : Float?
    var max : Float?
    var night :Float?
    var eve : Float?
    var morn : Float?
    
}
class Feels_like{
    
     var day : Float?
     var night :Float?
     var eve : Float?
     var morn : Float?
}
