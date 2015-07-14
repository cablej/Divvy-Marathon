//
//  UserStats.swift
//  Divvy Marathon
//
//  Created by Julianne Knott on 7/14/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit

class UserStats: NSObject {
    var numStationsToday = 0
    var mostStationsInADay = 0
    var numMilesToday = 0
    var mostMilesInADay = 0
    var sprints: [Sprint] = []
    var fastestSprints: [Sprint] = []
    
    func findFastestSprints() {
        for sprint in sprints {
            var fastestSprintsContainsATimeForThisSprint = false
            for fastSprint in fastestSprints {
                if sprint.isSameSprint(fastSprint) {
                    fastestSprintsContainsATimeForThisSprint = true
                    if sprint.timeInSeconds < fastSprint.timeInSeconds {
                        let index = fastestSprints.indexOf(fastSprint)
                        fastestSprints.removeAtIndex(index!)
                        fastestSprints.insert(sprint, atIndex: index!)
                    }
                }
            }
            if !fastestSprintsContainsATimeForThisSprint {
                fastestSprints.append(sprint)
            }
        }
    }
  
}
