//
//  Forecast.swift
//  RainyShinyCloudy
//
//  Created by Josiah Mory on 6/17/17.
//  Copyright © 2017 kickinbahk Productions. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class Forecast {

  var forecasts = [ForecastItem]()

  
  func downloadForecastData(completed: @escaping DownloadComplete) {
    // Download forecast weather data
    let forecastURL = URL(string: FORECAST_URL)!
    Alamofire.request(forecastURL).responseJSON { response in
      let result = response.result
      if let dict = result.value as? Dictionary<String, AnyObject> {
        if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
          for item in list {
            let forecast = ForecastItem(weatherDict: item)
            self.forecasts.append(forecast)
          }
          self.forecasts.remove(at: 0)
        }
      }
      completed()
    }
  }
}













