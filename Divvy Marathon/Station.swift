//
//  Station.swift
//  Divvy Marathon
//
//  Created by Jack Cable on 7/10/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit
import CoreLocation

class Station: NSObject {
    
    var numSpotsAvailable = 0
    var numBikesAvailable = 0
    var name = ""
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var id = ""
    
    convenience init(coordinate: CLLocationCoordinate2D, numSpotsAvailable: Int, numBikesAvailable: Int, name: String, id: String) {
        
        self.init()
        
        self.coordinate = coordinate
        self.numSpotsAvailable = numSpotsAvailable
        self.numBikesAvailable = numBikesAvailable
        self.name = name
        self.id = id
    }
    
    convenience init(coordinate: CLLocationCoordinate2D, name: String, id: String) {
        
        self.init()
        
        self.coordinate = coordinate
        self.name = name
        self.id = id
    }
    
    /**
        returns a string with the station name, latitude, longitude, number of bikes, and number of available spots. Use for debugging
    **/
    override var description: String {
        return "\(name): (\(coordinate.latitude), \(coordinate.longitude)), \(numBikesAvailable) bikes available and \(numSpotsAvailable) spots available"
    }
    
}
