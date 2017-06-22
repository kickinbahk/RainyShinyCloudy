//
//  WeatherCell.swift
//  RainyShinyCloudy
//
//  Created by Josiah Mory on 6/21/17.
//  Copyright © 2017 kickinbahk Productions. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

  @IBOutlet weak var weatherIcon: UIImageView!
  @IBOutlet weak var dayLabel: UILabel!
  @IBOutlet weak var weatherType: UILabel!
  @IBOutlet weak var highTemp: UILabel!
  @IBOutlet weak var lowTemp: UILabel!
  
  func configureCell(forecast: Forecast) {
    lowTemp.text = formatCellTemp(temp: forecast.lowTemp)
    highTemp.text = formatCellTemp(temp: forecast.highTemp)
    weatherType.text = forecast.weatherType
    weatherIcon.image = UIImage(named: forecast.weatherType)
    dayLabel.text = forecast.date
  }

  func formatCellTemp(temp: Double) -> String {
    let intTemp = Int(temp)
    let formattedTemp = "\(intTemp)°"
    return formattedTemp
  }
}
