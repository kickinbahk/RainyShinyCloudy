//
//  Location.swift
//  RainyShinyCloudy
//
//  Created by Josiah Mory on 6/21/17.
//  Copyright © 2017 kickinbahk Productions. All rights reserved.
//

import Foundation
import CoreLocation

class Location {
  static var sharedInstance = Location()
  private init() { }
  
  var latitude: Double!
  var longitude: Double!
}
