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
    
    @IBOutlet var mapView: MKMapView!
    
    var locationManager : CLLocationManager!
    
    var stations: [Station] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.getDivvyBikeData { (stationsArray) -> Void in
            if let tempStations = stationsArray {
                print("Yay! Got \(tempStations.count) stations.")
                self.stations = tempStations
            }
        }
        
        initializeLocation()
        
    }
    
    //MARK: Location methods
    
    func initializeLocation() { //sets up everything needed for the mapView and locationManager
        mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true) //makes the map follow the user's location, no need for all that other code updating it
        
        locationManager = CLLocationManager()
        //         locationManager.requestAlwaysAuthorization() //uncomment for access in background
        locationManager.requestWhenInUseAuthorization() //allows use in foreground
        
        if CLLocationManager.locationServicesEnabled() {
            
            print("Location services enabled")
            
            locationManager.delegate = self //LocationViewController conforms to the CLLocationManagerDelegate, so the locationManager will give updates to this class
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else {
            print("Location services disabled")
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { //called whenever the user's coordinates changed, which is quite often
        let location : CLLocationCoordinate2D = manager.location!.coordinate
        
        print("User location: (\(location.latitude), \(location.longitude))")
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error updating location: " + error.localizedDescription)
    }
    
    func addPin(coordinate: CLLocationCoordinate2D, title: String) {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = title
        mapView.addAnnotation(pin)
    }


}
