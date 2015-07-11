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
    var streetAddress = ""
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    convenience init(coordinate: CLLocationCoordinate2D, numSpotsAvailable: Int, numBikesAvailable: Int, streetAddress: String) {
        
        self.init()
        
        self.coordinate = coordinate
        self.numSpotsAvailable = numSpotsAvailable
        self.numBikesAvailable = numBikesAvailable
        self.streetAddress = streetAddress
    }
    
    override var description: String { //for debugging, when you print out the variable this gets printed
        return "\(streetAddress): (\(coordinate.latitude), \(coordinate.longitude)), \(numBikesAvailable) bikes available and \(numSpotsAvailable) spots available"
    }
    
}
