//
//  MyAnnotation.swift
//  WeatherForecast2
//
//  Created by NourAllah Ahmed on 4/29/22.
//  Copyright © 2022 NourAllah Ahmed. All rights reserved.
//

import Foundation
import MapKit
class CustomAnnotaion : NSObject,MKAnnotation {
        var coordinate: CLLocationCoordinate2D
        var title: String?
        var subtitle: String?
        init(coordinate:CLLocationCoordinate2D) {
            self.coordinate = coordinate
        }
    }

