//
//  Health.swift
//  PalApp
//
//  Created by Rhys Mackenzie on 2022-10-08.
//

import Foundation
import HealthKit
import Combine

class HealthStore: ObservableObject {
    @Published var currentHealthRing: HealthRing?
    @Published var statsPending: Bool = false
    @Published var refreshPending = false
    
    let healthStore = HKHealthStore()
    
    func _getHistoricalRangeHKQueryPredicate(days: Int) -> NSPredicate {
        let calendar = NSCalendar.current
        let endDate = Date()
         
        guard let startDate = calendar.date(byAdding: .day, value: -days, to: endDate) else {
            fatalError("*** Unable to create the start date ***")
        }

        let units: Set<Calendar.Component> = [.day, .month, .year, .era]

        
        var startDateComponents = calendar.dateComponents(units, from: calendar.startOfDay(for: startDate))
        startDateComponents.calendar = calendar

        var endDateComponents = calendar.dateComponents(units, from: endDate)
        endDateComponents.calendar = calendar

        // Create the predicate for the query
        return HKQuery.predicate(forActivitySummariesBetweenStart: startDateComponents, end: endDateComponents)
    }
    
    func _executeHKActivitySummaryQuery(predicate: NSPredicate, _ completion: @escaping([HKActivitySummary]) -> Void) {
        let query = HKActivitySummaryQuery(predicate: predicate) { (query, summaries, error) in
            guard let summaries = summaries, summaries.count > 0
            else {
                completion([])
                return
            }
            completion(summaries)
        }
        healthStore.execute(query)
    }
    
    func _convertHKActivitySummaryToHealthRing(summary: HKActivitySummary) -> HealthRing {
        let moveValue = summary.activeEnergyBurned.doubleValue(for: .largeCalorie())
        let standValue = summary.appleStandHours.doubleValue(for: .count())
        let exerciseValue = summary.appleExerciseTime.doubleValue(for: .minute())
        
        let moveGoal = summary.activeEnergyBurnedGoal.doubleValue(for: .largeCalorie())
        let standGoal = summary.appleStandHoursGoal.doubleValue(for: .count())
        let exerciseGoal = summary.appleExerciseTimeGoal.doubleValue(for: .minute())
        
        let standRing = ActivityGoal(goal: standGoal, value: standValue)
        let exerciseRing = ActivityGoal(goal: exerciseGoal, value: exerciseValue)
        let moveRing = ActivityGoal(goal: moveGoal, value: moveValue)
        
        return HealthRing(exerciseRing: exerciseRing, standRing: standRing, moveRing: moveRing)
    }
    
    func getHistoricalActivityStats(days: Int, _ completion: @escaping ([HealthRing]) -> Void) {
        let predicaate = _getHistoricalRangeHKQueryPredicate(days: days)
        _executeHKActivitySummaryQuery(predicate: predicaate) { summaries in
            if summaries.count == 0 {
                completion([])
                return
            }
            var healthRings: [HealthRing] = []
            for summary in summaries {
                print(summary)
                healthRings.append(self._convertHKActivitySummaryToHealthRing(summary: summary))
            }
            completion(healthRings)
        }
    }
    
    func requestAccess(_ completion: @escaping (Error?) -> Void) {
        let objectTypes: Set<HKObjectType> = [
            HKObjectType.activitySummaryType()
        ]

        healthStore.requestAuthorization(toShare: nil, read: objectTypes) { _, error in
            completion(error)
        }
    }
}
