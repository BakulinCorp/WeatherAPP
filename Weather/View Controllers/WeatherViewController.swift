//
//  WeatherViewController.swift
//  Weather
//
//  Created by Максим Бакулин on 04.09.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    
    @IBOutlet var table: UITableView!
    var models = [DailyWeatherEntry]()
    var hourlyModels = [HourlyWeather]()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
        var currently: CurrentWeather?
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        table.register(WeatherCollectionViewCell.nib(), forCellReuseIdentifier: WeatherCollectionViewCell.identifier)
        
        table.delegate = self
        table.dataSource = self
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil  {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatehrForLocation()
            
        }
    }
    
    
    
    func requestWeatehrForLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=minutely&appid=86c62bbd6d83d8358e6f31d6932b22a7"
        
        print("\(long) | \(lat)")
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            
            // Validation
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            
            // Convert data to models/some object
            
            var json: WeatherResponse?
            print(WeatherResponse.self)
            do {
                json = try JSONDecoder().decode(WeatherResponse.self, from: data)
            }
            catch {
                print("error: \(error)")
            }
            
            guard let result = json else {
                return
            }
            
            print(result.current.temp)
            
            let entries = result.current.temp
            
//            self.models.append(contentsOf: entries)
            
                    let currently = result.current
                    self.currently = currently
            
            
            
            //        self.hourlyModels = result.hourly.data
            
            // Update user interface
            DispatchQueue.main.async {
                self.table.reloadData()
                
                //            self.table.tableHeaderView = self.createTableHeader()
            }
            
        }).resume()
    }
}



// MARK - 24min

struct WeatherResponse: Codable {
    let lat: Float
    let lon: Float
    let timezone: String
    let current: CurrentWeather
//    let hourly: HourlyWeather
//    let daily: DailyWeather
}

struct CurrentWeather: Codable {
    let dt: Int
    let temp: Double
    let hourly: [HourlyWeather]
    let daily: [DailyWeather]
}

struct DailyWeather: Codable {
    let dt: Int
    let temp: DailyWeatherEntry
}

struct DailyWeatherEntry: Codable {
    let day: Double
    let min: Double
    let max: Double
}

struct HourlyWeather: Codable {
    let dt: Int
    let temp: Double
    
}

//struct HourlyWeatherEntry: Codable {
//    let dt: Int
//    let temp: Double
//}
