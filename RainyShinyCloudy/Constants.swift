//
//  Constants.swift
//  RainyShinyCloudy
//
//  Created by Josiah Mory on 6/17/17.
//  Copyright © 2017 kickinbahk Productions. All rights reserved.
//

import Foundation

let BASE_URL = "http://api.openweathermap.org/data/2.5/"
let WEATHER = "weather?"
let FORECAST = "forecast/daily?"
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let COUNT = "&cnt=10"
let MODE = "&mode=json"
let APP_ID = "&appId="
let API_KEY = OPEN_WEATHER_API_KEY

typealias DownloadComplete = () -> ()

let CURRENT_WEATHER_URL = "\(BASE_URL)\(WEATHER)\(LATITUDE)31\(LONGITUDE)121\(APP_ID)\(API_KEY)"
let FORECAST_URL = "\(BASE_URL)\(FORECAST)\(LATITUDE)\(Location.sharedInstance.latitude!)\(LONGITUDE)\(Location.sharedInstance.longitude!)\(COUNT)\(MODE)\(APP_ID)\(API_KEY)"

