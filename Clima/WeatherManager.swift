//
//  WeatherManager.swift
//  Clima
//
//  Created by Vishwa Patel on 3/23/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    
    func didFailedWithError(error: Error)
}

struct WeatherManager{
    
    
    let weatherAPI = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid={API_KEY}"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(name: String)  {
        let newString = "\(weatherAPI)&q=\(name)"
        performRequest(with: newString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let newString = "\(weatherAPI)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: newString)
    }
    
    func performRequest(with urlString: String) {
        //1. Create a URL
        
        if let url = URL(string: urlString){
            
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the Session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    print(error!)
                    self.delegate?.didFailedWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)                    }
                }
            }
            
            //            let task = session.dataTask(with: url, completionHandler: handle(data: response: error:))
            
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?  {
        let decoder = JSONDecoder()
        do{
            // Parse Raw API Response in JSON Format
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            // Extract values from JSON and initialize a model class
            let id = decodedData.weather[0].id
            let temperature = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temperature)
            
            // Return values in String format
            return weather
        } catch{
            print(error)
            delegate?.didFailedWithError(error: error)
            return nil
        }
        
    }
    
    
}
