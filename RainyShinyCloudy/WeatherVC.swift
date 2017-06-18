//
//  WeatherVC.swift
//  RainyShinyCloudy
//
//  Created by Josiah Mory on 6/17/17.
//  Copyright © 2017 kickinbahk Productions. All rights reserved.
//

import UIKit
import Alamofire

class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var currentTempLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  
  @IBOutlet weak var currentWeatherIcon: UIImageView!
  
  @IBOutlet weak var currentWeatherTypeLabel: UILabel!

  @IBOutlet weak var tableView: UITableView!
  
  var currentWeather: CurrentWeather!
  var forecast: Forecast!
  var forecasts = [Forecast]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    currentWeather = CurrentWeather()
    currentWeather.downloadWeatherDetails {
      self.downloadForecastData {

         self.updateMainUI()
      }
    }
  }
  
  func downloadForecastData(completed: @escaping DownloadComplete) {
    // Download forecast weather data for TableView
    let forecastURL = URL(string: FORECAST_URL)!
    Alamofire.request(forecastURL).responseJSON { response in
      let result = response.result
      if let dict = result.value as? Dictionary<String, AnyObject> {
        if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
          for item in list {
            print("hit loop")
            let forecast = Forecast(weatherDict: item)
            self.forecasts.append(forecast)
            print(item)
          }
        }
      }
      completed()
    }
    
  }
  
  func updateMainUI() {
    dateLabel.text = currentWeather.date
    currentTempLabel.text = "\(currentWeather.currentTemp)"
    currentWeatherTypeLabel.text = currentWeather.weatherType
    locationLabel.text = currentWeather.cityName
    currentWeatherIcon.image = UIImage(named: currentWeather.weatherType)
  }
  

}

extension WeatherVC {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 6
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath)
    return cell
  }

}

