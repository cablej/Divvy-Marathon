//
//  RouteCoordinate.swift
//  Divvy Marathon
//
//  Created by Jack Cable on 7/13/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit
import MapKit

class RouteCoordinate: NSObject {
    
    var coordinate = CLLocationCoordinate2D()
    var station: Station? = nil
    
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init()
        self.coordinate = coordinate
    }
    
    convenience init(coordinate: CLLocationCoordinate2D, station: Station) {
        self.init()
        self.coordinate = coordinate
        self.station = station
    }
    
}
