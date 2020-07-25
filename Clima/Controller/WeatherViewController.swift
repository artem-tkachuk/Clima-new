//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

//MARK: - WeatherViewController

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    //Responsible for getting hold of the current GPS location of the phone
    var locationManager = CoreLocation.CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //The text field should report back to ViewController
        searchTextField.delegate = self
        //The weather manager should report back to view controller!!!
        weatherManager.delegate = self
        //Location manager should report back to the view controller
        locationManager.delegate = self
        //Explicitly ask for the permission to get the user's location
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}


//MARK: - UITextFieldDelegate
    
extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        //Dismiss the keyboard
        searchTextField.endEditing(true)
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


//MARK: - WeatherManagerDelegate
//Delegate methods - delegate is the one who is being notified
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel) {
        DispatchQueue.main.async {
            //self. because we are in the closure
            //Set labels
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(_ error: Error) {
        showAlertController(title: "Error", message: "We could not find the weather for this city! Please try again!", buttonTitle: "OK")
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate  {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            weatherManager.fetchWeather(latitude, longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlertController(title: "Error", message: "We could not get your current location", buttonTitle: "OK")
    }
    
    @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: - showAlertController
extension WeatherViewController {
    func showAlertController(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            // create the alert
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
}
