//
//  WeatherManager.swift
//  Clima
//
//  Created by Artem Tkachuk on 7/24/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel)
    func didFailWithError(_ error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=&units=metric&q="
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(_ cityName: String) {
        let urlString = weatherURL + cityName
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        //1. Create a URL
        if let url = URL(string: urlString) {
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    //Exit out of this function. Request failed
                    return
                } else {
                    if let safeData = data {
                        if let weather = self.parseJSON(weatherData: safeData) {   //in closure we must add self. to the method call
                            print(weather)
                            // Weather manager triggers the delegate method and passes the weather object
                            self.delegate?.didUpdateWeather(self, weather)
                        
                        }
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            //basically a response
            let decodedWeatherData = try decoder.decode(WeatherData.self, from: weatherData)
            //Parse properties
            let temperature = decodedWeatherData.main.temp
            let conditionID = decodedWeatherData.weather[0].id
            let cityName = decodedWeatherData.name
            //Populate the instance with parsed values
            let weather = WeatherModel(conditionID, cityName, temperature)
            
            return weather
        } catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
}
