//
//  HealthRing.swift
//  PalApp
//
//  Created by Rhys Mackenzie on 2022-10-11.
//

import Foundation

enum RingType {
    case stand
    case exercise
    case move
}

class ActivityGoal: ObservableObject, Codable {
    var goal: Double
    var value: Double
    
    init(goal: Double, value: Double) {
        self.goal = goal
        self.value = value
    }
    var progress: Double {
        if goal == 0 {
            return 0
        }
        return value / goal
    }
}

class HealthRing: ObservableObject, Codable {
    var exerciseRing: ActivityGoal
    var standRing: ActivityGoal
    var moveRing: ActivityGoal
    
    init(exerciseRing: ActivityGoal, standRing: ActivityGoal, moveRing: ActivityGoal) {
        self.exerciseRing = exerciseRing
        self.standRing = standRing
        self.moveRing = moveRing
    }
    
    var goalProgress: Double {
        return (exerciseRing.progress + standRing.progress + moveRing.progress) / 3
    }
}
