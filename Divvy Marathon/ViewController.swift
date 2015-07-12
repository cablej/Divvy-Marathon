//
//  ViewController.swift
//  Divvy Marathon
//
//  Created by Jack Cable on 7/10/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var numMinutes = 0
    let dateFormatter = NSDateFormatter()
    var numMiles = 0.0
    /*
    estimated average speed fo a bike in the city: ~6mph accoring to treehuggers.com based on data in lyons france.
    we definitely need to look into this, maybe make it adjustable
    */
    var mph = 6.0
    var numNeccessaryIntermediaryStops = 0 //doesn't include start and end stations
    var tryToHitAsManyBikesAsPossible = false
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onTappedGoButton(sender: UIButton) {
        dateFormatter.dateFormat = "hh"
        let hrsStr = dateFormatter.stringFromDate(datePicker.date)
        dateFormatter.dateFormat = "mm"
        let hours = Int(hrsStr)
        let minsStr = dateFormatter.stringFromDate(datePicker.date)
        let minutes = Int(minsStr)
        numMinutes = hours! * 60 + minutes!
        print(numMinutes)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

