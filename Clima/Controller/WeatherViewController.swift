//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize Delegate and One time authorization to allow app to get location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
            
        // Delegate for WeatherManager to access data
        weatherManager.delegate = self
        
        // Text field should report back to
        searchTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    
    @IBAction func autoLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation() // One time request to get location. Or use startUpdating method for recurring calls.
    }
}

//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true) // Dismiss keyboard when user is done typing
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true) // Dismiss keyboard when user is done typing
        //        print(searchTextField.text!)
        return true
    }
    
    // Func to validate whether user has entered something in searchbar or not
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            // print(searchTextField.text!)
            // If user has entered some value in text field, then return true
            return true
        }
        else{
            // If user has not entered any value, then change placeholder of textfield
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Use SearchTextField to get the weather for that city.
        
        
        if let city = searchTextField.text{
            
            weatherManager.fetchWeather(name: city)
        }
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    // Execute when system got data from API response.
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
        
        
    }
    
    // Display the error
    func didFailedWithError(error: Error) {
        print(error)
    }
    
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        
        // Print Last location
        if let location = locations.last{
            let long = location.coordinate.longitude
            let lat = location.coordinate.latitude
            weatherManager.fetchWeather(latitude: lat, longitude: long)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }
}
