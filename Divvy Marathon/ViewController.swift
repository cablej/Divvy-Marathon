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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StyleHelper.initializeViewController(self)
        UIApplication.sharedApplication().statusBarStyle = .LightContent //white status bar
        
        datePicker.countDownDuration = 30*60 //set to 30 minutes default
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let nvc = segue.destinationViewController as? UINavigationController {
            if let dvc = nvc.viewControllers.first as? LocationViewController {
                
                let seconds = tripLengthInSeconds()
                
                dvc.tripLengthInSeconds = seconds
                
            }
        }
    }
    
    /**
        returns the trip length, in seconds, from the value of the date picker
    **/
    func tripLengthInSeconds() -> Double {
        return Double(datePicker.countDownDuration) //all that parsing was for nothing...
    }

   

}

