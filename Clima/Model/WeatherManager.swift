//
//  WeatherManager.swift
//  Clima
//
//  Created by Artem Tkachuk on 7/24/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

//MARK: - WeatherManagerDelegate protocol
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel)
    func didFailWithError(_ error: Error)
}


//MARK: - WeatherManagerDelegate
struct WeatherManager {
    let appid = String(ProcessInfo.processInfo.environment["appid"]!)
    var weatherURL: String {
        "https://api.openweathermap.org/data/2.5/weather?&appid=\(appid)&units=metric&"
    }
    
    var delegate: WeatherManagerDelegate?
    
    //MARK: - fetchWeather()
    //Preparation for calling performRequest()
    func fetchWeather(_ cityName: String) {
        if let urlEncodedCityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            print(appid)
            print(weatherURL)
            let urlString = weatherURL + "q=\(urlEncodedCityName)"
            performRequest(with: urlString)
        }
    }
    
    func fetchWeather(_ lat: CLLocationDegrees, _ lon: CLLocationDegrees) {
        let urlString = weatherURL + "lat=\(lat)" + "&" + "lon=\(lon)"
        performRequest(with: urlString)
    }
    
    //MARK: - performRequest()
    //Making a request to the OpenWeatherMap API to obtain the weather data
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
    
    //MARK: - parseJSON()
    //Parsing JSON obtained from the OpenWeatherMap API
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
