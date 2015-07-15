//
//  UserStatsViewController.swift
//  Divvy Marathon
//
//  Created by Julianne Knott on 7/14/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit

class UserStatsViewController: UIViewController {

    @IBOutlet weak var totalStations: UILabel!
    @IBOutlet weak var totalMiles: UILabel!
    
    @IBOutlet var usernameButton: UIBarButtonItem!
    
    var userStats = UserStats()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameButton.title = DataManager.getUsername()
        
        loadStats()
    }
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
