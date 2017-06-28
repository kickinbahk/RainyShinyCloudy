//
//  WeatherVC.swift
//  RainyShinyCloudy
//
//  Created by Josiah Mory on 6/17/17.
//  Copyright © 2017 kickinbahk Productions. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var currentTempLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var currentWeatherIcon: UIImageView!
  @IBOutlet weak var currentWeatherTypeLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  let dimmedView = UIView()
  
  let locationManager = CLLocationManager()
  var currentLocation: CLLocation!
  
  var currentWeather: CurrentWeather!
  var forecast: Forecast!
  var forecasts: [ForecastItem]?
  
  struct WeatherTypes {
    static let clear = "Clear"
    static let clouds = "Clouds"
    static let haze = "Clouds"
    static let mist = "Clouds"
    static let rain = "Rain"
    static let snow = "Snow"
    static let partiallyCloudy = "Partially Cloudy"
    static let thunderstorm = "Thunderstorm"
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.startMonitoringSignificantLocationChanges()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    currentWeather = CurrentWeather()
    forecast = Forecast()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    locationAuthStatus()
  }
  
  func locationAuthStatus() {
    let authStatus = CLLocationManager.authorizationStatus()
    
    if authStatus == .notDetermined {
      locationManager.requestWhenInUseAuthorization()
      return
    }
    
    if authStatus == .denied || authStatus == .restricted {
      showLocationServicesDeniedAlert()
      noLocationData()
      return
    }
    
    updateLocation()
  }
  
  func updateLocation() {
    currentLocation = locationManager.location
    Location.sharedInstance.latitude = currentLocation.coordinate.latitude
    Location.sharedInstance.longitude = currentLocation.coordinate.longitude
    print("got location")
    downloadWeatherData()
  }
  
  func downloadWeatherData() {
    currentWeather.downloadWeatherDetails {
      self.forecast.downloadForecastData {
        print("got forecast data")
        if self.forecasts?.count == 0 || self.forecasts?.count == nil {
          self.forecasts = self.forecast.forecasts
          print(self.forecasts!.count)
          self.updateMainUI()
          self.tableView.reloadData()
        } else {
          print("already have forecast")
          self.updateMainUI()
        }
        
      }
    }
  }
  
  func showLocationServicesDeniedAlert() {
    let alert = UIAlertController(title: "Location Services Disabled",
                                  message: "Please enable location services for this app in Settings.",
                                  preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK",
                                 style: .default,
                                 handler: nil)
    
    alert.addAction(okAction)
    present(alert, animated: true, completion: nil)
  }

  
  func updateMainUI() {
    let views = self.view.subviews
    for subview in views {
      if subview.tag == 1001 {
        subview.removeFromSuperview()
      }
    }
    
    dateLabel.text = currentWeather.date
    currentTempLabel.text = formatTemp(temp: currentWeather.currentTemp)
    currentWeatherTypeLabel.text = currentWeather.weatherType
    locationLabel.text = currentWeather.cityName
    let currentWeatherType = checkWeatherType(weather: currentWeather.weatherType)
    currentWeatherIcon.image = UIImage(named: currentWeatherType)
  }
  
  func checkWeatherType(weather: String) -> String {
    let weatherType: String
    switch weather {
    case "Clear":
      weatherType = WeatherTypes.clear
    case "Clouds":
      weatherType = WeatherTypes.clouds
    case "Partially Cloudy":
      weatherType = WeatherTypes.partiallyCloudy
    case "Haze":
      weatherType = WeatherTypes.haze
    case "Mist":
      weatherType = WeatherTypes.mist
    case "Rain":
      weatherType = WeatherTypes.rain
    case "Snow":
      weatherType = WeatherTypes.snow
    case "Thunderstorm":
      weatherType = WeatherTypes.thunderstorm
    default:
      weatherType = WeatherTypes.partiallyCloudy
    }
    return weatherType
  }
  
  func formatTemp(temp: Double) -> String {
    let intTemp = Int(temp)
    let formattedTemp = "\(intTemp)°"
    return formattedTemp
  }
  
  func noLocationData() {
    dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.65)
    dimmedView.tag = 1001
    
    view.addSubview(dimmedView)
    
    dimmedView.translatesAutoresizingMaskIntoConstraints = false
    dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
    dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    dimmedView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
    dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    
    let prompt = UILabel()
    prompt.textAlignment = .center
    prompt.text = "Please Enable Location in Settings to Use This App"
    prompt.textColor = .white
    prompt.font = UIFont(name: "AvenirNext-DemiBold", size: 24)
    prompt.lineBreakMode = .byWordWrapping
    prompt.numberOfLines = 0
    
    dimmedView.addSubview(prompt)
    
    prompt.translatesAutoresizingMaskIntoConstraints = false
    prompt.leadingAnchor.constraint(equalTo: dimmedView.leadingAnchor, constant: 25).isActive = true
    prompt.trailingAnchor.constraint(equalTo: dimmedView.trailingAnchor, constant: -25).isActive = true
    prompt.centerYAnchor.constraint(equalTo: dimmedView.centerYAnchor).isActive = true
    
  }
}

extension WeatherVC {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let forecastsArr = forecasts {
      return forecastsArr.count - 1 // Starting with tomorrow's data
    } else {
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell",
                                                for: indexPath) as? WeatherCell {
      let forecast = forecasts?[indexPath.row + 1] // First Item includes today so we start at tomorrows data
      cell.configureCell(forecastItem: forecast!)
      return cell
    } else {
      return WeatherCell()
    }
  }

}

extension WeatherVC {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    print("Location Auth Changed")
    locationAuthStatus()
  }
}

