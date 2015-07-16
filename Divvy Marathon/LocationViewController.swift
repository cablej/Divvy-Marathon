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

class LocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var finalLocationTextField: UITextField!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    
    let METER_TO_MILE = 1609.344 //conversion from meters to miles
    let MILE_TO_FEET = 5280.0 //converstion from mile to feet
    var tripLengthInSeconds = 0.0
    var tripLengthInMiles = 0.0
    var stressLevel = 0.0
    var locationManager : CLLocationManager!
    var stations: [Station] = []
    var currentLocation: CLLocation = CLLocation()
    var currentRoute: [MKRouteStep] = []
    var currentStationIndex = 0
    var routeStations: [Station] = []
    var numBikesOnThisRide = 0
    var userStats = UserStats()
    var typeOfRide = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLocation()
        
        if typeOfRide != 2 {
            finalLocationTextField.hidden = true
        }
        
        DataManager.getDivvyBikeData { (stationsArray) -> Void in
            if let tempStations = stationsArray {
                print("Yay! Got \(tempStations.count) stations.")
                self.stations = tempStations
                
                let location = self.findClosestLocation()
                
                self.routeStations.append(location)
                
                print(location)
                
                self.displayFullRoute()
                
                
                if self.typeOfRide == 1 {
                    
                    var destiStations : [Station] = [location]
                    
                    for name in lakeFrontStationNames {
                        
                        for station in self.stations {
                            if station.name == name {
                                destiStations.append(station)
                                break;
                            }
                        }
                    }
                    
                    self.processRoute(destiStations)
                    
                } else if self.typeOfRide == 0 {
                    
                    DataManager.getRoute(self.tripLengthInSeconds, startStation: location, stressLevel: self.stressLevel, typeOfRide: self.typeOfRide, success: { (routeStations) -> Void in
                        self.processRoute(routeStations)
                    })

                }
            }
        }
        
        if routeStations.count>=2{
            for i in 0...routeStations.count-2 {
                tripLengthInMiles += distanceBetweenTwoCoordinates(routeStations[i].coordinate, coordinate2: routeStations[i+1].coordinate)
        
            }
        }
        print("Seconds: " + String(tripLengthInSeconds))
        userStats.numStationsToday += routeStations.count
        
    }
    
    func processRoute(stationsToProccess: [Station]) {
        mapView.removeAnnotations(mapView.annotations)
        for station in stationsToProccess {
            self.addPin(station)
        }
        
        self.routeStations += stationsToProccess
        self.displayFullRoute()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if let dvc = segue.destinationViewController as? ViewRouteTableViewController {
                dvc.route = currentRoute
        }
    }
    
    /**
        displays the whole bike route to the user
    **/
    func displayFullRoute() {
        mapView.removeOverlays(mapView.overlays)
        displayDirectionsBetweenCoordinates(MKPlacemark(coordinate: currentLocation.coordinate, addressDictionary: nil), endCoordinate: MKPlacemark(coordinate: routeStations[0].coordinate, addressDictionary: nil))
        if routeStations.count >= 2 {
            for i in 0...routeStations.count - 2 {
                displayDirectionsBetweenCoordinates(MKPlacemark(coordinate: routeStations[i].coordinate, addressDictionary: nil), endCoordinate: MKPlacemark(coordinate: routeStations[i+1].coordinate, addressDictionary: nil))
            }
        }
    }
    
    /**
        displays the route between 2 coordinates
    **/
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
    
    /**
        draws a blue line indicating the route
    **/
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
        displays and returns the nearest divvy station
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
        
        addPin(closestStation)
        
        print("\(closestStation.name) is closest at \(closestDistance) miles")
        
        return closestStation
    }
    
    func findStationClosestToCoordinate(location: CLLocation) -> Station {
        var closestDistance: Double = -1.0 //start with -1 because we know it will never be possible
        var closestStation: Station = Station()
        for station in stations {
            let distance = CLLocation(latitude: station.coordinate.latitude, longitude: station.coordinate.longitude).distanceFromLocation(location) //get distance between station and current location
            let miles = metersToMiles(distance)
            if(closestDistance == -1.0 ||  miles < closestDistance) {
                closestDistance = miles
                closestStation = station
            }
        }
        
        addPin(closestStation)
        
        print("\(closestStation.name) is closest at \(closestDistance) miles")
        
        return closestStation
    }
    
    /**
        returns the distance from the current location to a coordinate
    **/
    func distanceToCoordinate(coordinate: CLLocationCoordinate2D) -> Double {
        let distance = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude).distanceFromLocation(currentLocation)
        let miles = metersToMiles(distance)
        return miles
    }
    
    /**
        returns the distance between two coordinates
    **/
    func distanceBetweenTwoCoordinates(coordinate1: CLLocationCoordinate2D, coordinate2: CLLocationCoordinate2D) -> Double {
        let distance = CLLocation(latitude: coordinate1.latitude, longitude: coordinate2.longitude).distanceFromLocation(CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude))
        let miles = metersToMiles(distance)
        return miles
    }
    
    /**
        converts from meters to miles
    **/
    func metersToMiles(meters: Double) -> Double {
        return meters / METER_TO_MILE
    }
    
    //MARK: Location methods
    /**
        sets up everything needed for the map View and Location Manager
    **/
    func initializeLocation() {
        //makes the map follow the user's location, no need for all that other code updating it
        mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        
        //locationManager.requestAlwaysAuthorization() //uncomment for access in background
        locationManager = CLLocationManager()
        
        //allows use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            print("Location services enabled")
            //LocationViewController conforms to the CLLocationManagerDelegate, so the locationManager will give updates to this class
            locationManager.delegate = self
            mapView.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else {
            print("Location services disabled")
        }
    }
    
    /**
        called whenever the user's coordinates change, which is quite often
    **/
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = manager.location!
        
        if userIsNearNextStation() {
            self.messageLabel.text = "Switch bikes at " + routeStations[currentStationIndex].name + "."
            //increases high score
            numBikesOnThisRide++
            
            //tests if not at the starting point
            if(currentStationIndex >= 1) {
                
                let miles = distanceBetweenTwoCoordinates(routeStations[currentStationIndex].coordinate, coordinate2: routeStations[currentStationIndex-1].coordinate)
                
                DataManager.hitStation(miles)
            }
            
            if(currentStationIndex < routeStations.count - 1) {
                currentStationIndex++
            }
        }
        
    }
    
    /**
        returns true if user is within 100 ft of the next station
    **/
    func userIsNearNextStation() -> Bool {
        if routeStations.isEmpty { return false }
        let nextStation = routeStations[currentStationIndex]
        return userIsNearCoordinate(nextStation.coordinate)
    }
    
    /**
        returns true if user is within 100 ft of a coordinate
    **/
    func userIsNearCoordinate(coordinate: CLLocationCoordinate2D) -> Bool {
        let distanceMiles = distanceToCoordinate(coordinate)
        let distanceFeet = distanceMiles * MILE_TO_FEET
        return distanceFeet <= 100
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error updating location: " + error.localizedDescription)
    }
    
    /**
        adds a station pin to the map
    **/
    func addPin(station: Station) {
        let pin = MKPointAnnotation()
        pin.coordinate = station.coordinate
        pin.title = station.name
        pin.subtitle = "bikes: \(station.numBikesAvailable)     docks: \(station.numSpotsAvailable)"
        mapView.addAnnotation(pin)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        if annotation.isKindOfClass(MKPointAnnotation) {
            if let pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("CustomPinAnnotationView") as? MKPinAnnotationView  {
                pinView.annotation = annotation
                return pinView
            } else {
                /*pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: "CustomPinAnnotationView")
                pinView!.image = UIImage(named: "divvy_arrows")
                pinView?.frame = CGRect(origin: CGPointZero, size: CGSize(width: 32, height: 32))*/
                let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "CustomPinAnnotationView")
                pinView.pinColor = MKPinAnnotationColor.Purple
                return pinView
            }
        }
        return nil
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        routeStations = []
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(textField.text!, completionHandler:
            {placemarks, error in
                if error != nil {
                    print(error)
                }
                else {
                    let placemark = placemarks!.first as
                        CLPlacemark!
                    self.routeStations = [self.findClosestLocation(), self.findStationClosestToCoordinate(placemark!.location)]
                    self.processRoute(self.routeStations)
                }
        })//note this ), this is all part of method header, closure is contained in method header!!!
        textField.resignFirstResponder() // gets rid of keyboard
        return true
    }
}
