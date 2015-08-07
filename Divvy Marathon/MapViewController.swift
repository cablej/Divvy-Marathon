//
//  MapViewController.swift
//  Divvy Marathon
//
//  Created by Jack Cable on 7/28/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var showFullRouteButton: UIBarButtonItem!
    
    var currentRoute: [Station] = []
    var currentRouteDirections: [MKRoute] = []
    
    var locationManager: CLLocationManager!
    var shouldUpdateMap = false //if mapview should update the map
    
    var numRequests = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StyleHelper.initializeViewController(self)
        
        messageLabel.backgroundColor = TINT_COLOR
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.minimumScaleFactor = 10.0
        
        showFullRouteButton.enabled = false
        
        mapView.delegate = self
        mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        
        if let manager = RouteManager.initializeLocation() {
            locationManager = manager
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
        
        RouteManager.loadStations { () -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                print("Stations loaded updating map.")
                self.updateMap()
                self.showFullRouteButton.enabled = true
            }
        }
    }

    override func viewDidAppear(animated: Bool) {
        shouldUpdateMap = true
        if(mapView.userLocation.coordinate.latitude == 0.0 && mapView.userLocation.coordinate.longitude == 0.0) {
            //shouldUpdateMap = true
        } else {
            //print("View did appear updating map, basic.")
            //updateMap()
        }
    }
    
    @IBAction func onViewDirectionsTapped(sender: AnyObject) {
        updateMap()
    }
    /**
    called whenever the user's coordinates change, which is quite often
    **/
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print(manager.location!)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error updating location: " + error.localizedDescription)
    }
    
    func updateMap() {
        currentRoute = RouteManager.updateRoute(RouteManager.getRoute())
        currentRouteDirections = []
        clearMap()
        displayRoute(currentRoute)
    }
    
    func clearMap() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
    }
    
    func displayRoute(route: [Station]) {
        
        print(mapView.userLocation.coordinate)
        
        var locationsInDirections : [MKPlacemark] = [MKPlacemark(coordinate: mapView.userLocation.coordinate, addressDictionary: nil)]
        
        for station in route {
            locationsInDirections.append(MKPlacemark(coordinate: station.coordinate, addressDictionary: nil))
        }
        
        for(var i=0; i<locationsInDirections.count - 1; i++) {
            calculateDirectionsBetweenCoordinates(locationsInDirections[i], endCoordinate: locationsInDirections[i+1], success: { (index) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if index == RouteManager.getCurrentStationIndex() {
                        print(self.showFullRouteButton.tag != 0)
                        self.displayCurrentRouteDirections(self.showFullRouteButton.tag != 0)
                    }
                }
            })
        }
    }
    
    func displayCurrentRouteDirections(fullRoute: Bool) {
        clearMap()
        var routeIndexesToDisplay: [Int] = []
        if fullRoute {
            for(var i=RouteManager.getCurrentStationIndex(); i<currentRouteDirections.count; i++) {
                routeIndexesToDisplay.append(i)
            }
        } else {
            routeIndexesToDisplay.append(RouteManager.getCurrentStationIndex())
        }
        
        for index in routeIndexesToDisplay {
            self.displayMKRoute(currentRouteDirections[index])
            self.addPin(currentRoute[index])
        }
        
        messageLabel.text = "Follow the highlighted route to \(currentRoute[RouteManager.getCurrentStationIndex()].name)"
        
    }
    
    @IBAction func onShowFullRouteTapped(sender: AnyObject) {
        if showFullRouteButton.tag == 0 { //should show full route
            showFullRouteButton.tag = 1
            showFullRouteButton.title = "Hide full route"
            displayCurrentRouteDirections(true)
        } else { //should hide full route
            showFullRouteButton.tag = 0
            showFullRouteButton.title = "Show full route"
            displayCurrentRouteDirections(false)
        }
    }
    
    /**
    adds a station pin to the map
    **/
    func addPin(station: Station) {
        let pin = MKPointAnnotation()
        pin.coordinate = station.coordinate
        pin.title = station.name
        let bikes = station.numBikesAvailable
        let docks = station.numSpotsAvailable
        pin.subtitle = "bikes: \(bikes)     docks: \(docks)"
        mapView.addAnnotation(pin)
    }
    
    /**
    displays the route between 2 coordinates
    **/
    func calculateDirectionsBetweenCoordinates(startCoordinate: MKPlacemark, endCoordinate: MKPlacemark, success: (index: Int) -> Void) {
        
        numRequests++;
        print(numRequests)
        
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: startCoordinate)
        request.destination = MKMapItem(placemark: endCoordinate)
        request.requestsAlternateRoutes = false
        request.transportType = MKDirectionsTransportType.Walking
        
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler { (response, error) -> Void in
            if error != nil {
                print("Error: " + error!.description)
            } else {
                if let route = response?.routes.first {
                    let index = self.currentRouteDirections.count //it'll be the next element
                    self.currentRouteDirections.append(route)
                    success(index: index)
                }
            }
        }
    }
    
    /**
    draws a blue line indicating the route
    **/
    func displayMKRoute(route: MKRoute) {
        for step in route.steps {
            mapView.addOverlay(step.polyline, level: MKOverlayLevel.AboveRoads)
        }
    }
    
    //adds custom overlay to map
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = TINT_COLOR
        renderer.lineWidth = 5.0
        return renderer
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        //print("Moved: \(userLocation.location)")
        if shouldUpdateMap {
            print("Updating map from user location.")
            updateMap()
            shouldUpdateMap = false
        }
    }

}
