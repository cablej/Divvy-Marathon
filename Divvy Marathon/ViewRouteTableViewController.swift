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
    let METER_TO_MILE = 1609.344 //conversion from meters to miles
    let MILE_TO_FEET = 5280.0 //converstion from mile to feet
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func metersToMiles(meters: Double) -> Double {

        return meters / METER_TO_MILE    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StepCell", forIndexPath: indexPath) as! RouteStepTableViewCell
        
        let step: MKRouteStep = route[indexPath.row]
        
        cell.directionsLabel.text = step.instructions
        
        let miles = metersToMiles(step.distance)
        var distanceString = NSString(format: "%.1f miles", miles) as String
        if miles < 1 {
            let feet = miles * MILE_TO_FEET
            distanceString = NSString(format: "%.0f feet", feet) as String
        }
        
        cell.distanceLabel.text = distanceString

        return cell
    }


}
