//
//  AddRouteStationsViewController.swift
//  Divvy Marathon
//
//  Created by Jack Cable on 7/28/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit

class AddRouteStationsViewController: UIViewController {

    @IBOutlet var rideTypeSegmentedControl: UISegmentedControl!
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StyleHelper.initializeViewController(self)
        
        datePicker.countDownDuration = 30*60 //set to 30 minutes default
        
    }
    
    @IBAction func onCancelButtonTapped(sender: AnyObject) {
        dismissView()
    }
    
    @IBAction func onGenerateRouteButtonTapped(sender: AnyObject) {
        let seconds = Double(datePicker.countDownDuration)
        let typeOfRide = rideTypeSegmentedControl.selectedSegmentIndex
        let closestStation = RouteManager.getRoute()[0]
        
        DataManager.getRoute(seconds, startStation: closestStation, stressLevel: 0, success: { (routeStations) -> Void in
            print(routeStations)
            RouteManager.addStationsToRoute(routeStations)
            self.dismissView()
        })
    }
    
//    @IBAction func onSaveButtonTapped(sender: AnyObject) {
//        RouteManager.addStationWithIDToRoute("101")
//        dismissView()
//    }
    
    func dismissView() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {
            let secondPresentingVC = self.presentingViewController?.presentingViewController;
            secondPresentingVC?.dismissViewControllerAnimated(true, completion: {})
        })
    }
    
    

}
