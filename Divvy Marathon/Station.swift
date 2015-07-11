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
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var numSpotsAvailable = 0
    var numBikesAvailable = 0
    var streetAddress = ""
    
    convenience init(latitude: Double, longitude: Double, numSpotsAvailable: Int, numBikesAvailable: Int, streetAddress: String) {
        
        self.init()
        
        self.latitude = latitude
        self.longitude = longitude
        self.numSpotsAvailable = numSpotsAvailable
        self.numBikesAvailable = numBikesAvailable
        self.streetAddress = streetAddress
    }
    
    override var description: String { //for debugging, when you print out the variable this gets printed
        return "\(streetAddress): (\(latitude), \(longitude)), \(numBikesAvailable) bikes available and \(numSpotsAvailable) spots available"
    }
    
}
