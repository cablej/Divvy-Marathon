//
//  ViewRouteTableViewController.swift
//  Divvy Marathon
//
//  Created by Jack Cable on 7/12/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit
import MapKit

class ViewRouteTableViewController: UITableViewController {

    var route : MKRoute = MKRoute()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsetsMake(60,0,0,0);
        
        tableView.backgroundColor = UIColor.whiteColor()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return route.steps.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StepCell", forIndexPath: indexPath) as! RouteStepTableViewCell
        
        let step: MKRouteStep = route.steps[indexPath.row]
        
        cell.directionsLabel.text = step.instructions
        cell.distanceLabel.text = "\(step.distance) meters"

        return cell
    }


}
