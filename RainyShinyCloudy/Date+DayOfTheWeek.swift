//
//  Date+DayOfTheWeek.swift
//  RainyShinyCloudy
//
//  Created by Josiah Mory on 6/21/17.
//  Copyright © 2017 kickinbahk Productions. All rights reserved.
//

import Foundation

extension Date {
  func dayOfTheWeek() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter.string(from: self)
  }
}
