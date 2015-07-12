//
//  ViewController.swift
//  Divvy Marathon
//
//  Created by Jack Cable on 7/10/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var numMinutes = 0
    var numMiles = 0.0
    /*
    estimated average speed fo a bike in the city: ~6mph accoring to treehuggers.com based on data in lyons france.
    we definitely need to look into this, maybe make it adjustable
    */
    var mph = 6.0
    var numNeccessaryIntermediaryStops = 0 //doesn't include start and end stations
    var tryToHitAsManyBikesAsPossible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StyleHelper.initializeViewController(self)
        UIApplication.sharedApplication().statusBarStyle = .LightContent //white status bar
        
        datePicker.countDownDuration = 30*60 //set to 30 minutes default
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dvc = segue.destinationViewController as? LocationViewController {
            
            let seconds = tripLengthInSeconds()
            
            dvc.tripLengthInSeconds = seconds
            
        }
    }
    
    /**
        returns the trip length, in seconds, from the value of the date picker
    **/
    func tripLengthInSeconds() -> Int {
        return Int(datePicker.countDownDuration) //all that parsing was for nothing...
    }

    /**
        uses the numMinutes to calculate numMiles based on the estimated average speed of a bike in the city
    **/
    func minutesToMiles(){
        numMiles = mph / Double(60) * Double(numMinutes)
    }
    
    /**
        uses numMinutes to calculate numNecessaryIntermediaryStops, assumes 25 mins between stops
    **/
    func calculateNumNecessaryStops(){
        var minsExcludingStartEndTimes = numMinutes - 25 // extra time not covered by first rental
        if (minsExcludingStartEndTimes % 25 > 0) {
            numNeccessaryIntermediaryStops = minsExcludingStartEndTimes / 25
        }
        else {
            numNeccessaryIntermediaryStops = minsExcludingStartEndTimes / 25 - 1
        }
    }


}

