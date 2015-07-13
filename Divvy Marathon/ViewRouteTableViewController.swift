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

    var route : [MKRouteStep] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsetsMake(70,0,0,0);
        
        tableView.backgroundColor = UIColor.whiteColor()
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return route.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StepCell", forIndexPath: indexPath) as! RouteStepTableViewCell
        
        let step: MKRouteStep = route[indexPath.row]
        
        cell.directionsLabel.text = step.instructions
        cell.distanceLabel.text = "\(step.distance) meters"

        return cell
    }


}
