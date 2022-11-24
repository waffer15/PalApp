//
//  PalStore.swift
//  PalApp
//
//  Created by Rhys Mackenzie on 2022-10-08.
//

import Foundation

class PalStore: ObservableObject {
    @Published var palStats: [PalStat] = []
    var healthStore: HealthStore
    @Published var palState: PalState = .neutral
    var stateUpdating: Bool = false
    @Published var todaysHealthRing: HealthRing?
    
    init(healthStore: HealthStore) {
        self.healthStore = healthStore
    }
    
    
    func _updateCurrentPalStats(healthRing: HealthRing) {
        let moveStat = PalStat(title: "Move", value: healthRing.moveRing.value, goalValue: healthRing.moveRing.goal, color: .red)
        let exeriseStat = PalStat(title: "Exercise", value: healthRing.exerciseRing.value, goalValue: healthRing.exerciseRing.goal, color: .green)
        let standStat = PalStat(title: "Stand", value: healthRing.standRing.value, goalValue: healthRing.standRing.goal, color: .blue)
        self.palStats = [moveStat, exeriseStat, standStat]
        self.todaysHealthRing = healthRing
    }
    
    func _convertProgressToPalState(progress: Double) -> PalState {
        switch (progress) {
        case 0..<0.5:
            return .dead
        case 0.5..<0.75:
            return .extremeSad
        case 0.75..<0.9:
            return .neutral
        case 0.9..<1:
            return .happy
        default:
            return .extremeHappy
        }
    }

    func updatePalState(_ completion: @escaping (PalState) -> Void = {_ in }) {
        if UserDefaults.standard.bool(forKey: "isDead") {
            self.palState = .dead
            return
        }
        
        guard let palBirthDate = UserDefaults.standard.object(forKey: "lastEvolved") as? Date else {
            DispatchQueue.main.async {
                self.palState = .new
            }
            return
        }
        
        let numDaysSinceBirth = Calendar.current.numberOfDaysBetween(palBirthDate, and: Date())
        
        print(numDaysSinceBirth)
        let numDays = min(numDaysSinceBirth - 1, 3)
        
        healthStore.getHistoricalActivityStats(days: numDays) { healthRings in
            DispatchQueue.main.async {
                guard healthRings.count > 0 else {
                    completion(self.palState)
                    return
                }
                
                self.palState = calculatePalState(healthRings: healthRings)
                
                self._updateCurrentPalStats(healthRing: healthRings.last!)
                completion(self.palState)
            }
        }
    }
}
