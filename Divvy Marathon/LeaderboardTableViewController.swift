//
//  LeaderboardTableViewController.swift
//  Divvy Marathon
//
//  Created by Jack Cable on 7/15/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit

class LeaderboardTableViewController: UITableViewController {

    var type = "totalMiles"
    var users : [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.whiteColor()
        
        print(type)
        
        
        let postString = "action=Leaderboard&type=\(type)"
        
        //loads user data from server
        DataManager.sendRequest(REQUEST_URL, postString: postString ) {
            response in
            
            if let error = DataManager.error(response) {
                print(error)
            }
            
            if let json = DataManager.stringToJSON(response) {
                
                for userJSON in json {
                    
                    self.users.append(userJSON.1)
                    
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserTableViewCell

        cell.usernameLabel.text = users[indexPath.row]["username"].stringValue
        cell.scoreLabel.text = users[indexPath.row][type].stringValue

        return cell
    }
    
}
