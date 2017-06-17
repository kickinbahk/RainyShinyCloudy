//
//  WeatherVC.swift
//  RainyShinyCloudy
//
//  Created by Josiah Mory on 6/17/17.
//  Copyright © 2017 kickinbahk Productions. All rights reserved.
//

import UIKit

class WeatherVC: UIViewController {

  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var currentTempLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  
  @IBOutlet weak var currentWeatherIcon: UIImageView!
  
  @IBOutlet weak var currentWeatherTypeLabel: UILabel!

  @IBOutlet weak var tableView: UITableView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }



}

