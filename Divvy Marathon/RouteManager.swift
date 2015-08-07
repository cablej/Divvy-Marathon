//
//  RouteManager.swift
//  Divvy Marathon
//
//  Created by Jack Cable on 7/28/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit
import CoreLocation

let METER_TO_MILE = 1609.344 //conversion from meters to miles

let userDefaults = NSUserDefaults.standardUserDefaults()

var stations: [Station] = []

class RouteManager: NSObject {
    
    class func loadStations(success: () -> Void) {
        DataManager.getDivvyBikeData { (stationsArray) -> Void in
            if let tempStations = stationsArray {
                print("Loaded \(tempStations.count) stations.")
                stations = tempStations
                success()
            }
        }

    }
    
    class func getRoute() -> [Station] {
        if let encodedStations = userDefaults.objectForKey("route") as? [NSData] {
            
            var route: [Station] = []
            
            for encodedStation in encodedStations {
                let station = NSKeyedUnarchiver.unarchiveObjectWithData(encodedStation) as! Station
                route.append(station)
            }
            
            return route
        }
        return []
    }
    
    class func setRoute(route : [Station]) {
        
        var encodedStations: [NSData] = []
        for station in route {
            let encodedStation = NSKeyedArchiver.archivedDataWithRootObject(station)
            encodedStations.append(encodedStation)
        }
        
        userDefaults.setObject(encodedStations, forKey: "route")
    }
    
    class func addStationsToRoute(stations : [Station]) {
        var route = getRoute()
        route = route + stations
        setRoute(route)
    }
    
    class func addStationToRoute(station : Station) {
        var route = getRoute()
        route.append(station)
        setRoute(route)
    }
    
    class func getCurrentStationIndex() -> Int {
        if let currentStationIndex = userDefaults.objectForKey("currentStationIndex") as? Int {
            return currentStationIndex
        }
        return 0
    }
    
    class func setCurrentStationIndex(index : Int) {
        userDefaults.setObject(index, forKey: "currentStationIndex")
    }
    
    class func getStationByID(stationID : String) -> Station? {
        for station in stations {
            if station.id == stationID {
                return station
            }
        }
        return nil
    }
    
    class func updateRoute(route: [Station]) -> [Station] {
        var updatedRoute: [Station] = []
        for station in route {
            if let updatedStation = getStationByID(station.id) {
                updatedRoute.append(updatedStation)
            } else { //stations haven't been loaded, just don't update
                return route
            }
        }
        return updatedRoute
    }
    
    class func findClosestStation(location: CLLocationCoordinate2D) -> Station { //displays the closest divvy station to the user's location
        var closestDistance: Double = -1.0 //start with -1 because we know it will never be possible
        var closestStation: Station = Station()
        for station in stations {
            let distance = CLLocation(latitude: station.coordinate.latitude, longitude: station.coordinate.longitude).distanceFromLocation(CLLocation(latitude: location.latitude, longitude: location.longitude)) //get distance between station and current location
            let miles = metersToMiles(distance)
            if(closestDistance == -1.0 ||  miles < closestDistance) {
                closestDistance = miles
                closestStation = station
            }
        }
        
        print("\(closestStation.name) is closest at \(closestDistance) miles")
        
        return closestStation
    }
    
    /**
    converts from meters to miles
    **/
    class func metersToMiles(meters: Double) -> Double {
        return meters / METER_TO_MILE
    }
    
    class func initializeLocation() -> CLLocationManager? {
        
        //locationManager.requestAlwaysAuthorization() //uncomment for access in background
        let locationManager = CLLocationManager()
        
        //allows use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            print("Location services enabled")
            //LocationViewController conforms to the CLLocationManagerDelegate, so the locationManager will give updates to this class
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            return locationManager
        } else {
            print("Location services disabled")
            return nil
        }
    }
    
    
}
