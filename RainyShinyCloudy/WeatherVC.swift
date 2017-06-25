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
      return
    }
    
    // if does not fail above
    updateLocation()
  }
  
  func updateLocation() {
    currentLocation = locationManager.location
    Location.sharedInstance.latitude = currentLocation.coordinate.latitude
    Location.sharedInstance.longitude = currentLocation.coordinate.longitude
    print("got location")
    currentWeather.downloadWeatherDetails {
      self.forecast.downloadForecastData {
        print("got forecast data")
        self.forecasts = self.forecast.forecasts
        self.updateMainUI()
        self.tableView.reloadData()
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
}

extension WeatherVC {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let forecastsArr = forecasts {
      return forecastsArr.count
    } else {
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell",
                                                for: indexPath) as? WeatherCell {
      let forecast = forecasts![indexPath.row]
      cell.configureCell(forecastItem: forecast)
      return cell
    } else {
      return WeatherCell()
    }
  }

}

extension WeatherVC {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    locationAuthStatus()
  }
}

