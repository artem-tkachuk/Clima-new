//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //The text field should report back to ViewController
        searchTextField.delegate = self
        //The weather manager should report back to view controller!!!
        weatherManager.delegate = self
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        //Dismiss the keyboard
        searchTextField.endEditing(true)
    }
    
    
    
    //Delegate methods - delegate is the one who is being notified
    
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel) {
        DispatchQueue.main.async {
            //self. because we are in the closure
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
        //Relay back to the user
        //TODO see what happens when there is no internet
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Dismiss the keyboard
        searchTextField.endEditing(true)
        // Allow a text field to actually return
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //useful for validation
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type a city name here!"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //User searchTextField.text to get the weather for that city
        if let cityName = searchTextField.text {
            weatherManager.fetchWeather(cityName)
        }
        searchTextField.text = ""
    }
    
}

