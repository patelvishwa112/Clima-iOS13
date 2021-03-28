//
//  WeatherModel.swift
//  Clima
//
//  Created by Vishwa Patel on 3/27/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    var conditionID: Int
    var cityName: String
    var temperature: Double
    
    
    // Computed Property
    var temperatureString: String {
        return String(format: "%.1f", self.temperature)
    }
    
    
    // Computed Property
    var conditionName: String {
        // All string represent name of images in SF Image Class.
        switch conditionID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
    
}
