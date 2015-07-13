//
//  DataManager.swift
//  Divvy Marathon
//
//  Created by Jack Cable on 7/10/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit
import CoreLocation

let DIVVY_JSON_URL = "http://www.divvybikes.com/stations/json"
let ROUTE_URL = "http://tiphound.me/Divvy-Marathon/generateRoute.php"

class DataManager: NSObject {
    
    class func getDivvyBikeData(success: ((stationsArray: [Station]!) -> Void)) {
        
        let url = NSURL(string: DIVVY_JSON_URL)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) -> Void in
            if let urlData = data {
                if let divvyJSON = stringToJSON(NSString(data: urlData, encoding: NSUTF8StringEncoding) as! String) {
                    
                    var stations : [Station] = []
                    
                    for stationJSON in divvyJSON["stationBeanList"] { //who knows why it's called 'stationBeanList', but it is.
                        
                        if(stationJSON.1["statusKey"] == 1) { //is operational
                            
                            
                            
                            let latitude = stationJSON.1["latitude"].doubleValue
                            let longitude = stationJSON.1["longitude"].doubleValue
                            let numSpotsAvailable = stationJSON.1["availableDocks"].intValue
                            let numBikesAvailable = stationJSON.1["availableBikes"].intValue
                            let name = stationJSON.1["stationName"].stringValue
                            let id = stationJSON.1["id"].stringValue
                            
                            let station = Station(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), numSpotsAvailable: numSpotsAvailable, numBikesAvailable: numBikesAvailable, name: name, id: id)
                            stations.append(station)
                        }
                        
                    }
                    
                    success(stationsArray: stations)
                }
            }
        }
        
        task?.resume()
        
    }
    
    class func getRoute(seconds: Double, startStation: Station, success: ((routeStations: [Station]!) -> Void)) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: ROUTE_URL)!)
        
        let postString = "seconds=\(seconds)&startingStation=\(startStation.id)"
        
        request.HTTPMethod = "POST"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        var responseString = ""
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if(error != nil) {
                print("error=\(error)")
                return
            }
            
            responseString = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
            
            if let routeJSON = stringToJSON(responseString) {
                
                var routeStations : [Station] = []
                
                for stationJSON in routeJSON {
                    
                    let name = stationJSON.1["station"]["name"].stringValue
                    let id = stationJSON.1["station"]["id"].stringValue
                    let latitude = stationJSON.1["station"]["latitude"].doubleValue
                    let longitude = stationJSON.1["station"]["longitude"].doubleValue
                    
                    let station = Station(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), name: name, id: id)
                    routeStations.append(station)
                    
                }
                
                success(routeStations: routeStations)
            }
            
        }
        
        task?.resume()
    }
    
    class func stringToJSON(string: String) -> JSON? { //returns a JSON object of the given string
        let jsonObject : AnyObject?
        let json : JSON
        do {
            jsonObject = try NSJSONSerialization.JSONObjectWithData(string.dataUsingEncoding(NSUTF8StringEncoding)!,
                options: NSJSONReadingOptions.AllowFragments)
            json = JSON(jsonObject!)
            return json
        } catch {}
        return nil;
    }
}
