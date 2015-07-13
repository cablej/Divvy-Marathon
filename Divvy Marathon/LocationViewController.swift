//
//  LocationViewController.swift
//  Divvy Marathon
//
//  Created by Jack Cable on 7/10/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

/*  find info on generating directions here: http://www.techotopia.com/index.php/Using_MKDirections_to_get_iOS_8_Map_Directions_and_Routes should we consider segueing to a new viewcontroller that shows the route once a pin is selected? We should see if it's possible to display multiple routes on a single map. That way we can show the route to the nearest station (walking), the route(s) between stations (biking), and the route to the desired end location (walking).
*/

import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet var messageLabel: UILabel!
    let METER_TO_MILE = 1609.344 //conversion from meters to miles
    let MILE_TO_FEET = 5280.0 //converstion from mile to feet
    
    @IBOutlet var mapView: MKMapView!
    
    var tripLengthInSeconds = 0
    
    var locationManager : CLLocationManager!
    var stations: [Station] = []
    var currentLocation: CLLocation = CLLocation()
    var currentRoute: [MKRouteStep] = []
    var currentStationIndex = 0
    var routeStations: [Station] = []
    var numBikesOnThisRide = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeLocation()
        
        DataManager.getDivvyBikeData { (stationsArray) -> Void in
            if let tempStations = stationsArray {
                print("Yay! Got \(tempStations.count) stations.")
                self.stations = tempStations
                
                let location = self.findClosestLocation()
                
                self.routeStations.append(location)
                
                print(location)
                
                self.displayFullRoute()
            }
        }
        
        print("Seconds: " + String(tripLengthInSeconds))
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if let dvc = segue.destinationViewController as? ViewRouteTableViewController {
                dvc.route = currentRoute
        }
    }
    
    func displayFullRoute() {
        displayDirectionsBetweenCoordinates(MKPlacemark(coordinate: currentLocation.coordinate, addressDictionary: nil), endCoordinate: MKPlacemark(coordinate: routeStations[0].coordinate, addressDictionary: nil))
        if routeStations.count >= 2 {
            for i in 0...routeStations.count - 2 {
                displayDirectionsBetweenCoordinates(MKPlacemark(coordinate: routeStations[i].coordinate, addressDictionary: nil), endCoordinate: MKPlacemark(coordinate: routeStations[i+1].coordinate, addressDictionary: nil))
            }
        }
        /*for i in 0...routeStations.count - 2 {
            displayDirectionsBetweenCoordinates(MKPlacemark(coordinate: routeStations[i].coordinate, addressDictionary: nil), endCoordinate: MKPlacemark(coordinate: routeStations[i+1].coordinate, addressDictionary: nil))
        }*/
    }
    
    func displayDirectionsBetweenCoordinates(startCoordinate: MKPlacemark, endCoordinate: MKPlacemark) {
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: startCoordinate)
        request.destination = MKMapItem(placemark: endCoordinate)
        request.requestsAlternateRoutes = false
        request.transportType = MKDirectionsTransportType.Walking
        
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler { (response, error) -> Void in
            if error != nil {
                print("Oh no :( Error: " + error!.description)
            } else {
                let route = response?.routes.first
                self.currentRoute += route!.steps
                self.showRoute(response!)
            }
        }
    }
    
    func showRoute(response: MKDirectionsResponse) {
        for route in response.routes {
            mapView.addOverlay(route.polyline, level: MKOverlayLevel.AboveRoads)
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = TINT_COLOR
        renderer.lineWidth = 5.0
        return renderer
    }
    
    /**
        displays the nearest divvy station
    **/
    func findClosestLocation() -> Station { //displays the closest divvy station to the user's location
        var closestDistance: Double = -1.0 //start with -1 because we know it will never be possible
        var closestStation: Station = Station()
        for station in stations {
            let distance = CLLocation(latitude: station.coordinate.latitude, longitude: station.coordinate.longitude).distanceFromLocation(currentLocation) //get distance between station and current location
            let miles = metersToMiles(distance)
            if(closestDistance == -1.0 ||  miles < closestDistance) {
                closestDistance = miles
                closestStation = station
            }
        }
        
        addPin(closestStation.coordinate, title: closestStation.streetAddress)
        
        print("\(closestStation.streetAddress) is closest at \(closestDistance) miles")
        
        return closestStation
    }
    
    func distanceToCoordinate(coordinate: CLLocationCoordinate2D) -> Double {
        let distance = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude).distanceFromLocation(currentLocation)
        let miles = metersToMiles(distance)
        return miles
    }
    
    func metersToMiles(meters: Double) -> Double {
        return meters / METER_TO_MILE
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
            mapView.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else {
            print("Location services disabled")
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { //called whenever the user's coordinates changed, which is quite often
        let location : CLLocationCoordinate2D = manager.location!.coordinate
        currentLocation = manager.location!
        if userIsNearNextStation() {
            self.messageLabel.text = "Switch bikes at " + routeStations[currentStationIndex].streetAddress + "."
            numBikesOnThisRide++
            if(currentStationIndex < routeStations.count - 1) {
                currentStationIndex++
            }
        }
        
    }
    
    func userIsNearNextStation() -> Bool {
        if routeStations.isEmpty { return false }
        let nextStation = routeStations[currentStationIndex]
        return userIsNearCoordinate(nextStation.coordinate)
    }
    
    func userIsNearCoordinate(coordinate: CLLocationCoordinate2D) -> Bool {
        let distanceMiles = distanceToCoordinate(coordinate)
        let distanceFeet = distanceMiles * MILE_TO_FEET
        return distanceFeet <= 20
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
