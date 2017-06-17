//
//  WeatherVC.swift
//  RainyShinyCloudy
//
//  Created by Josiah Mory on 6/17/17.
//  Copyright © 2017 kickinbahk Productions. All rights reserved.
//

import UIKit

class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var currentTempLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  
  @IBOutlet weak var currentWeatherIcon: UIImageView!
  
  @IBOutlet weak var currentWeatherTypeLabel: UILabel!

  @IBOutlet weak var tableView: UITableView!
  
  var currentWeather: CurrentWeather!
  var forecast: Forecast!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    currentWeather = CurrentWeather()
    forecast = Forecast()
    currentWeather.downloadWeatherDetails {
      self.updateMainUI()
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

