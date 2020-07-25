//
//  WeatherModel.swift
//  Clima
//
//  Created by Artem Tkachuk on 7/25/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    //MARK: - Stored properties
    let conditionID: Int
    let cityName: String
    let temperature: Double
    
    //MARK: - Computed properties
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }

    var conditionName: String {
        switch conditionID {
            case 200..<300:
                return "cloud.bolt.rain"
            case 300..<500:
                return "cloud.drizzle"
            case 500..<600:
                return "cloud.rain"
            case 600..<700:
                return "cloud.snow"
            case 700..<800:
                return "smoke"
            case 800:
                return "sun.max"
            case 800...:
                return "cloud"
            default:
                return "Undetermined icon"
        }
    }
    
    //MARK: - Initializer
    init(_ conditionID: Int, _ cityName: String, _ temperature: Double) {
        self.conditionID = conditionID
        self.cityName = cityName
        self.temperature = temperature
    }
}
