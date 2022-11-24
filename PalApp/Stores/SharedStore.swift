//
//  SharedStore.swift
//  PalApp
//
//  Created by Rhys Mackenzie on 2022-10-09.
//

import Foundation

class SharedStore: ObservableObject {
    @Published var healthStore: HealthStore
    @Published var palStore: PalStore
    
    init() {
        let healthStore = HealthStore()
        self.healthStore = healthStore
        self.palStore = PalStore(healthStore: healthStore)
    }
}
