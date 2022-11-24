//
//  Utils.swift
//  PalApp
//
//  Created by Rhys Mackenzie on 2022-11-14.
//

import Foundation


func _convertRingProgressToState(ringsMetEveryday: Bool, moveProgress: Double, standProgress: Double, exerciseProgress: Double) -> PalState {
    var accum = 0.0
    let scalar = 0.25
    
    if moveProgress >= 1 {
        accum += 1 + (1 - moveProgress) * scalar
    } else {
        accum += moveProgress
    }
    
    if standProgress >= 1 {
        accum += 1 + (1 - standProgress) * scalar
    } else {
        accum += standProgress
    }
    
    if exerciseProgress >= 1 {
        accum += 1 + (1 - exerciseProgress) * scalar
    } else {
        accum += exerciseProgress
    }
    
    if ringsMetEveryday { return .extremeHappy }
    

    switch (accum) {
    case 0..<1.5:
        return .extremeSad
    case 1.5..<2:
        return .sad
    case 2..<2.5:
        return .neutral
    default:
        return .happy
    }
}

func calculatePalState(healthRings: [HealthRing]) -> PalState {
    var moveProgress = 0.0
    var standProgress = 0.0
    var exerciseProgress = 0.0
    
    let days = Double(healthRings.count)
    
    var ringsMetEveryday = true
    for healthRing in healthRings {
        moveProgress += healthRing.moveRing.progress / days
        standProgress += healthRing.standRing.progress / days
        exerciseProgress += healthRing.exerciseRing.progress / days

        if healthRing.moveRing.progress < 1.0 || healthRing.standRing.progress < 1.0 || healthRing.exerciseRing.progress < 1.0 {
            ringsMetEveryday = false
        }
    }
    
    return _convertRingProgressToState(ringsMetEveryday: ringsMetEveryday, moveProgress: moveProgress, standProgress: standProgress, exerciseProgress: exerciseProgress)
}
