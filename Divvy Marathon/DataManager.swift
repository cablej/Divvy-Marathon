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
let REQUEST_URL = "http://tiphound.me/Divvy-Marathon/request.php"
var lakeFrontStationNames: [String] = [/*"Sheridan Rd & Greenleaf Ave", "Sheridan Rd & Loyola Ave", "Broadway & Granville Ave", "Broadway & Thorndale Ave", "Lakefront Trail & Bryn Mawr Ave", "Clarendon Ave & Leland Ave", "Montrose Harbor", "Clarendon Ave & Junior Ter", "Clarendon Ave & Gordon Ter", "Pine Grove Ave & Irving Park Rd", "Pine Grove Ave & Waveland Ave", "Lake Shore Dr & Belmont Ave", "Lake Shore Dr & Wellington Ave", "Lake Shore Dr & Diversey Pkwy", "Stockton Dr & Wrightwood Ave", "Theater On The Lake", "Cannon Dr & Fullerton Ave", "Lakeview Ave & Fullerton Pkwy", "Clark St & Armitage Ave", "Clark St & Lincoln Ave", "Clark St & North Ave", "Lake Shore Dr & North Blvd", "Ritchie Ct & Banks St", "Michigan Ave & Oak St", "Michigan Ave & Oak St", "Lake Shore Dr & Ohio St", */"Streeter Dr & Illinois St", "Dusable Harbor", "Lake Shore Dr & Monroe St", "Michigan Ave & Madison St", "Millennium Park", "Wabash Ave & Adams St", "Michigan Ave & Jackson Blvd", "Michigan Ave & Congress Pkwy", "Michigan Ave & Balbo Ave", "Indiana Ave & Roosevelt Rd", "Shedd Aquarium", "Museum Campus", "Adler Planetarium", "Burnham Harbor", "Fort Dearborn Dr & 31st St"/*, "Lake Park Ave & 35th St", "Cottage grove Ave & Oakwood Blvd", "Woodlawn Ave & Lake Park Ave", "Lake Park Ave & 47th St", "Cornell Ave & Hyde Park Blvd", "Lake Park Ave & 53rd St", "Shore Dr & 55th St", "Museum of Science and Industry", "63rd St Beach", "Stony Island Ave & 64th St", "Stony Island Ave & 67th St", "Jeffery Blvd & 67th St", "South Shore Dr & 67th St", "South Shore Dr & 71st St", "South Shore Dr & 74th St", "Rainbow Beach" */]

class DataManager: NSObject {
    
    /**
        gets saves json data into an array of stations
    **/
    class func getDivvyBikeData(success: ((stationsArray: [Station]!) -> Void)) {
        
        let url = NSURL(string: DIVVY_JSON_URL)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) -> Void in
            if let urlData = data {
                if let divvyJSON = DataManager.stringToJSON(NSString(data: urlData, encoding: NSUTF8StringEncoding) as! String) {
                    
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
        
        task.resume()
        
    }
    
    /**
        calculates a route based on the time the user wants to bike for, the users starting location, and the type of ride the user would like to go on
        ride types:
        0 : basic crazy route
        1 : lakefront
        ...to be continued...
    **/
    class func getRoute(seconds: Double, startStation: Station, stressLevel: Double, success: ((routeStations: [Station]!) -> Void)) {
        var stressLevel = stressLevel
        if stressLevel == 0 {
            stressLevel = 5
        }
        
        let postString = "seconds=\(seconds)&startingStation=\(53/*startStation.id*/)&minTim=\(stressLevel)"
        
        sendRequest(ROUTE_URL, postString: postString)  {
            response in
            
            if let routeJSON = DataManager.stringToJSON(response) {
                
                var routeStations : [Station] = []
                
                for stationJSON in routeJSON {
                    
                    let name = stationJSON.1["station"]["name"].stringValue
                    let id = stationJSON.1["station"]["id"].stringValue
                    let latitude = stationJSON.1["station"]["latitude"].doubleValue
                    let longitude = stationJSON.1["station"]["longitude"].doubleValue
                    let availableDocks = stationJSON.1["station"]["availableDocks"].intValue
                    let availableBikes = stationJSON.1["station"]["availableBikes"].intValue
                    let station = Station(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), numSpotsAvailable: availableDocks, numBikesAvailable: availableBikes, name: name, id: id)
                        routeStations.append(station)
                }
                
                success(routeStations: routeStations)
            }
        }
    }
    /**
        sends a request for data to the server and does stuff with it
    **/
    class func sendRequest(url: String, postString: String, completionHandler : (String) -> ()){
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
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
            
            completionHandler(responseString)
            
        }
        
        task.resume()
    }

    /**
        converts a string to a json object
    **/
    
    
    class func stringToJSON(string: String) -> JSON? {
        let jsonObject : AnyObject?
        
        let json : JSON
        
        var error: NSError?
        
        jsonObject = NSJSONSerialization.JSONObjectWithData(string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, options: NSJSONReadingOptions.MutableContainers, error: nil)
        
        
        json = JSON(jsonObject!)
        
        return json
    }
    
    /**
        saves the user's information with a key'
    **/
    class func saveUserInformation(information: String) {
        if let json = stringToJSON(information) {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            
            let key = json["key"].stringValue
            
            let username = json["username"].stringValue
            
            userDefaults.setObject(key, forKey: "key")
            userDefaults.setObject(username, forKey: "username")
        }
    }
    
    class func getKey() -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let key = userDefaults.objectForKey("key") as? String
        return key == "" ? nil : key
    }
    
    class func getUsername() -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let username = userDefaults.objectForKey("username") as? String
        return username == "" ? nil : username
    }
    
    /**
        sends a request to the server when a user reaches a station
    **/
    class func hitStation(miles: Double) {
        
        if let key = getKey() {
            
            let postString = "action=HitStation&key=\(key)&miles=\(miles)"
            
            DataManager.sendRequest(REQUEST_URL, postString: postString ) {
                response in
                
                var message = "Successfully updated."
                
                if let error = DataManager.error(response) {
                    message = error
                } else {
                    DataManager.saveUserInformation(response)
                }
                
                print(message)
                
            }
        }
        
    }
    
    class func error(response: String) -> String? {
        if let json = stringToJSON(response) {
            let error = json["error"].stringValue
            
            if(error != "") {
                return error
            }
        }
        return nil
    }

}
