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
                            let streetAddress = stationJSON.1["stAddress1"].stringValue
                            
                            let station = Station(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), numSpotsAvailable: numSpotsAvailable, numBikesAvailable: numBikesAvailable, streetAddress: streetAddress)
                            stations.append(station)
                        }
                        
                    }
                    
                    success(stationsArray: stations)
                }
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
