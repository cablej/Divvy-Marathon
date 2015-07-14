//
//  ViewController.swift
//  Divvy Marathon
//
//  Created by Jack Cable on 7/10/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var testTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    var userStats = UserStats()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        StyleHelper.initializeViewController(self)
        UIApplication.sharedApplication().statusBarStyle = .LightContent //white status bar
        
        datePicker.countDownDuration = 30*60 //set to 30 minutes default
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dvc = segue.destinationViewController as? LocationViewController {
            
            let seconds = tripLengthInSeconds()
            dvc.userStats = userStats
            dvc.tripLengthInSeconds = seconds
        }
        if let dvc = segue.destinationViewController as? UserStatsViewController {
            
            let seconds = tripLengthInSeconds()
            dvc.userStats = userStats
        }

    }
    
    /**
        returns the trip length, in seconds, from the value of the date picker
    **/
    func tripLengthInSeconds() -> Double {
        print(datePicker.countDownDuration)
        print(String(Double(datePicker.countDownDuration)))
        return Double(datePicker.countDownDuration) //all that parsing was for nothing...
    }

   

}

