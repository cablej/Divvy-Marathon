//
//  UserStatsViewController.swift
//  Divvy Marathon
//
//  Created by Julianne Knott on 7/14/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit

class UserStatsViewController: UIViewController {

    @IBOutlet weak var numStationsTodayLabel: UILabel!
    @IBOutlet weak var mostStationsInADayLabel: UILabel!
    @IBOutlet weak var numMilesTodayLabel: UILabel!
    @IBOutlet weak var mostMilesInADayLabel: UILabel!
    
    var userStats = UserStats()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numStationsTodayLabel.text = "You went to \(userStats.numStationsToday) Divvy stations Today"
        mostStationsInADayLabel.text = "Most Stations Visited in a Day: \(userStats.mostStationsInADay)"
        numMilesTodayLabel.text = "You rode for \(userStats.numMilesToday) Miles today"
        mostMilesInADayLabel.text = "Most Miles Ridden in a Day: \(userStats.mostMilesInADay)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
