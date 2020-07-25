//
//  WeatherData.swift
//  Clima
//
//  Created by Artem Tkachuk on 7/24/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double    //Property names have to exactly match the API
}

struct Weather: Codable {
    let id: Int
}
