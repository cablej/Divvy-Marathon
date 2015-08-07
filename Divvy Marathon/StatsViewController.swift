//
//  StatsViewController.swift
//  Divvy Marathon
//
//  Created by Jack Cable on 8/6/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    
    @IBOutlet weak var totalStations: UILabel!
    @IBOutlet weak var totalMiles: UILabel!
    @IBOutlet var usernameButton: UIBarButtonItem!
    @IBOutlet var logInButton: UIBarButtonItem!
    @IBOutlet var usernameStats: UILabel!
    
    var userStats = UserStats()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StyleHelper.initializeViewController(self)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if let username = DataManager.getUsername() {
            usernameStats.text = "Your stats: \(username)"
            
            usernameButton.title = username
        } else {
            usernameStats.text = "You're not logged in."
            usernameButton.title = ""
        }
        
        loadStats()
        
        if let _ = DataManager.getUsername() {
            logInButton.title = "Log out"
        } else {
            logInButton.title = "Log in"
        }
    }
    
    @IBAction func onLogInButtonTapped(sender: AnyObject) {
        if let _ = DataManager.getUsername() {
            userDefaults.setObject("", forKey: "key")
            userDefaults.setObject("", forKey: "username")
            logInButton.title = "Log in"
            usernameButton.title = ""
            totalMiles.text = "Total miles: "
            totalStations.text = "Total stations: "
        } else {
            performSegueWithIdentifier("LogIn", sender: self)
        }
        
    }
    
    
    /**
    loads the user's data from the Server
    **/
    func loadStats() {
        print(DataManager.getKey())
        if let key = DataManager.getKey() {
            
            let postString = "action=UserStats&key=\(key)"
            
            
            DataManager.sendRequest(REQUEST_URL, postString: postString ) {
                response in
                
                if let error = DataManager.error(response) {
                    print(error)
                }
                
                print(response);
                
                if let json = DataManager.stringToJSON(response) {
                    
                    let miles = json["totalMiles"].doubleValue
                    let stations = json["totalStations"].intValue
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.totalMiles.text = NSString(format: "total miles: %.1f", miles) as String
                        self.totalStations.text = "total stations: \(stations)"
                    }
                }
                
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dvc = segue.destinationViewController as? LeaderboardTableViewController {
            if(sender!.tag == 1) {
                dvc.type = "totalStations"
            } else {
                dvc.type = "totalMiles"
            }
        }
    }
}
