//
//  PalAppApp.swift
//  PalApp
//
//  Created by Rhys Mackenzie on 2022-10-08.
//

import SwiftUI

@main
struct PalAppApp: App {
    @State var palStore: PalStore
    @State var router = ViewRouter()
    @State var healthStore: HealthStore
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        let healthStore = HealthStore()
        _healthStore = State(initialValue: healthStore)
        _palStore = State(initialValue: PalStore(healthStore: healthStore))
    }
    
    var body: some Scene {
        WindowGroup {
            GlobalView()
                .environmentObject(healthStore)
                .environmentObject(palStore)
                .environmentObject(router)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                healthStore.requestAccess() { error in
                    if error != nil {
                        return
                    }
                    print("updating state")
                    palStore.updatePalState()
                }
            }
        }
    }
}
