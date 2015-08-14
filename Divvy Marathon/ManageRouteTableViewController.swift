//
//  ManageRouteTableViewController.swift
//  Divvy Marathon
//
//  Created by Jack Cable on 7/28/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit
import CoreLocation

class ManageRouteTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    var route : [Station] = []
    var locationManager : CLLocationManager!
    
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let manager = RouteManager.initializeLocation() {
            locationManager = manager
            locationManager.delegate = self
        }
        
        StyleHelper.initializeViewController(self)
        
        tableView.backgroundColor = UIColor.whiteColor()
        
        self.route = RouteManager.getRoute()
        self.updateTable()
        
        if self.route == [] { //doesn't have a route, should find the closest location
            self.locationManager.startUpdatingLocation()
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        route = RouteManager.getRoute()
        updateTable()
    }
    
    @IBAction func onEditButtonTapped(sender: AnyObject) {
        setRouteEditing(!tableView.editing)
    }
    
    func setRouteEditing(editing: Bool) {
        if editing {
            editButton.title = "Done"
            addButton.title = "Reset"
        } else {
            editButton.title = "Edit"
            addButton.title = "Add"
        }
        tableView.setEditing(editing, animated: true)
    }
    
    @IBAction func onAddButtonTapped(sender: AnyObject) {
        if !tableView.editing {
            performSegueWithIdentifier("addRoute", sender: sender)
        } else {
            setRouteEditing(false)
            RouteManager.setRoute([])
            RouteManager.setCurrentStationIndex(0)
            route = []
            updateTable()
            self.locationManager.startUpdatingLocation()
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row != 0 {
            return true
        }
        return false
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            alert("Could not delete", message: "You are not allowed to delete the first station.")
        }
        if editingStyle == UITableViewCellEditingStyle.Delete {
            var route = RouteManager.getRoute()
            route.removeAtIndex(indexPath.row)
            RouteManager.setRoute(route)
            updateTable()
        }
    }
    
    func alert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
        return
    }
    
    /**
    called whenever the user's coordinates change, which is quite often
    **/
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        let closestStation = RouteManager.findClosestStation(newLocation.coordinate)
        if(route == []) {
            RouteManager.setRoute([closestStation])
            route = [closestStation]
        }
        self.updateTable()
        locationManager.stopUpdatingLocation()
    }
    
    func updateTable() {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return route.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StationCell", forIndexPath: indexPath) as! ManageRouteTableViewCell
        
        cell.stationNameLabel.text = "\(indexPath.row + 1). \(route[indexPath.row].name)"
        
        if indexPath.row < RouteManager.getCurrentStationIndex() { //is completed
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        return cell
    }

}
