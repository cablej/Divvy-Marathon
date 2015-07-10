//
//  LocationViewController.swift
//  Divvy Marathon
//
//  Created by Jack Cable on 7/10/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager : CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        print("This will print the current location.")
        
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization() //background
        locationManager.requestWhenInUseAuthorization() //foreground
        
        if CLLocationManager.locationServicesEnabled() {
            
            print("Location services enabled")
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
        } else {
            print("Location services disabled")
        }
        
        // Do any additional setup after loading the view.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var location : CLLocationCoordinate2D = manager.location!.coordinate
        
        print("User location: (\(location.latitude), \(location.longitude))")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error updating location: " + error.localizedDescription)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
