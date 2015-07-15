//
//  Sprint.swift
//  Divvy Marathon
//
//  Created by Julianne Knott on 7/14/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit

class Sprint: NSObject {
    var startStation = Station()
    var endStation = Station()
    var timeInSeconds = 0.0
    
    // tests if the sprints are the same route, doesn't consider time
    func isSameSprint(sprint: Sprint) -> Bool{
        if self.startStation.name == sprint.startStation.name && self.endStation.name == sprint.endStation.name {
            return true
        }
        else {
            return false
        }
    }
}
