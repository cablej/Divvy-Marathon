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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
