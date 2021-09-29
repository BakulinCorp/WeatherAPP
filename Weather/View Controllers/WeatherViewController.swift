//
//  WeatherViewController.swift
//  Weather
//
//  Created by Максим Бакулин on 04.09.2021.
//

import UIKit
import CoreLocation
import Foundation
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    
    @IBOutlet var table: UITableView!
    var models = [Daily]()
    var hourlyModels = [Current]()
//    var weatherResponse = [WeatherResponse]()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var currently: Current?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
        table.delegate = self
        table.dataSource = self
        
        table.backgroundColor = .systemBlue
        view.backgroundColor = .systemBlue
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
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&appid=86c62bbd6d83d8358e6f31d6932b22a7&units=metric"
        
        print("\(long) | \(lat)")
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            
            // Validation
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            
            // Convert data to models/some object
            
            var json: WeatherResponse?
          
            do {
                json = try JSONDecoder().decode(WeatherResponse.self, from: data)
            }
            catch {
                print("error: \(error)")
            }
            
            guard let result = json else {
                return
            }
            
     
            
            let entries = result.daily
            
            self.models.append(contentsOf: entries)
            
            let currently = result.current
            self.currently = currently
            
            
            
                        self.hourlyModels = result.hourly
            
            // Update user interface
            DispatchQueue.main.async {
                self.table.reloadData()
                
                self.table.tableHeaderView = self.createTableHeader()
            }
            
        }).resume()
    }
    
    func createTableHeader() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height:  view.frame.size.width))
        
        headerView.backgroundColor = .systemBlue
        
        let locationLabel = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.size.width-20, height: headerView.frame.size.height/5))
        let summaryLabel = UILabel(frame: CGRect(x: 10, y: 20+locationLabel.frame.size.height, width: view.frame.size.width-20, height: headerView.frame.size.height/5))
        let tempLabel = UILabel(frame: CGRect(x: 10, y: 20+locationLabel.frame.size.height+summaryLabel.frame.size.height, width: view.frame.size.width-20, height: headerView.frame.size.height/2))
        
        
        
        headerView.addSubview(locationLabel)
        headerView.addSubview(tempLabel)
        headerView.addSubview(summaryLabel)
        
        tempLabel.textAlignment = .center
        locationLabel.textAlignment = .center
        summaryLabel.textAlignment = .center
        
//        locationLabel.text = "\(WeatherResponse.timezone)"
        locationLabel.text = "Location Label"

        
        guard let Current = self.currently else {
            return UIView()
        }
        //timezone
        
        tempLabel.text = "\(Int(Current.temp))°"
        tempLabel.font = UIFont(name: "Helvetica-Bold", size: 32)
        summaryLabel.text = "clear"
        
        
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
            cell.configure(with: hourlyModels)
            //        cell.backgroundColor = .systemBlue
            return cell
            
       
        }
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
            cell.configure(with: models[indexPath.row])
            //        cell.backgroundColor = .systemBlue
            return cell
        }
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
    }

    
    // MARK - 24min
    
    
    // MARK: - WeatherResponse
    
    
    
    
    struct WeatherResponse: Codable {
        let lat, lon: Double
        let timezone: String
        let timezoneOffset: Int?
        let current: Current
        let minutely: [Minutely]
        let hourly: [Current]
        let daily: [Daily]
        
        enum CodingKeys: String, CodingKey {
            case lat, lon, timezone
            case timezoneOffset
            case current, minutely, hourly, daily
        }
    }
    
    // MARK: - Current
    struct Current: Codable {
        let dt: Int
        let sunrise, sunset: Int?
        let temp: Double
        let feelsLike: Double?
        let pressure, humidity: Int
        let dewPoint, uvi: Double?
        let clouds, visibility: Int
        let windSpeed: Double?
        let windDeg: Int?
        let windGust: Double?
        let weather: [Weather]
        let rain: Rain?
        let pop: Double?
        
        enum CodingKeys: String, CodingKey {
            case dt, sunrise, sunset, temp
            case feelsLike
            case pressure, humidity
            case dewPoint
            case uvi, clouds, visibility
            case windSpeed
            case windDeg
            case windGust
            case weather, rain, pop
        }
    }
    
    // MARK: - Rain
    struct Rain: Codable {
        let the1H: Double
        
        enum CodingKeys: String, CodingKey {
            case the1H
        }
    }
    
    // MARK: - Weather
    struct Weather: Codable {
        let id: Int?
        //    let main: Main?
        let weatherDescription: String?
        //    let icon: Icon?
        
        enum CodingKeys: String, CodingKey {
            case id
            //        case main
            case weatherDescription
            //        case icon
        }
    }
    
    //enum Icon: String, Codable {
    //    case the02D = "02d"
    //    case the03D = "03d"
    //    case the04D = "04d"
    //    case the04N = "04n"
    //    case the09D = "09d"
    //    case the10D = "10d"
    //}
    //
    //enum Main: String, Codable {
    //    case clouds = "Clouds"
    //    case rain = "Rain"
    //}
    
    // MARK: - Daily
    struct Daily: Codable {
        let dt, sunrise, sunset, moonrise: Int
        let moonset: Int
        let moonPhase: Double?
        let temp: Temp
        let feelsLike: FeelsLike?
        let pressure, humidity: Int
        let dewPoint, windSpeed: Double?
        let windDeg: Int?
        let windGust: Double?
        let weather: [Weather]
        let clouds: Int
        let pop: Double
        let rain: Double?
        let uvi: Double
        
        enum CodingKeys: String, CodingKey {
            case dt, sunrise, sunset, moonrise, moonset
            case moonPhase
            case temp
            case feelsLike
            case pressure, humidity
            case dewPoint
            case windSpeed
            case windDeg
            case windGust
            case weather, clouds, pop, rain, uvi
        }
    }
    
    // MARK: - FeelsLike
    struct FeelsLike: Codable {
        let day, night, eve, morn: Double
    }
    
    // MARK: - Temp
    struct Temp: Codable {
        let day, min, max, night: Double
        let eve, morn: Double
    }
    
    // MARK: - Minutely
    struct Minutely: Codable {
        let dt: Int
        let precipitation: Double
    }
