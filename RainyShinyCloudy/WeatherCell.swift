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
  
  func configureCell(forecastItem: ForecastItem) {
    lowTemp.text = formatCellTemp(temp: forecastItem.lowTemp)
    highTemp.text = formatCellTemp(temp: forecastItem.highTemp)
    weatherType.text = forecastItem.weatherType
    weatherIcon.image = UIImage(named: forecastItem.weatherType)
    dayLabel.text = forecastItem.date
  }

  func formatCellTemp(temp: Double) -> String {
    let intTemp = Int(temp)
    let formattedTemp = "\(intTemp)°"
    return formattedTemp
  }
}
