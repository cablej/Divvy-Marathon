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
    
    @IBOutlet var usernameLabel: UILabel!
    
    @IBOutlet var logInButton: UIBarButtonItem!
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var userStats = UserStats()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StyleHelper.initializeViewController(self)
        UIApplication.sharedApplication().statusBarStyle = .LightContent //white status bar
        
        datePicker.countDownDuration = 30*60 //set to 30 minutes default
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if let _ = DataManager.getUsername() {
            logInButton.title = "Log out"
        }
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
    
    @IBAction func onLogInButtonTapped(sender: AnyObject) {
        if let username = DataManager.getUsername() {
            userDefaults.setObject("", forKey: "key")
            userDefaults.setObject("", forKey: "username")
            logInButton.title = "Log in"
        } else {
            performSegueWithIdentifier("SignIn", sender: self)
        }

    }
    
    /**
        returns the trip length, in seconds, from the value of the date picker
    **/
    func tripLengthInSeconds() -> Double {
        print(String(Double(datePicker.countDownDuration)))
        return Double(datePicker.countDownDuration) //all that parsing was for nothing...
    }

   

}

