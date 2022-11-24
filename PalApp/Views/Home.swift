//
//  Home.swift
//  PalApp
//
//  Created by Rhys Mackenzie on 2022-10-08.
//

import SwiftUI
import SpriteKit

struct Home: View {
    @EnvironmentObject var healthStore: HealthStore
    @EnvironmentObject var palStore: PalStore
    
    var labelMap: [PalState: String] = [
        .dead: "I can't go on... any... longer........",
        .extremeSad: "I'm extremely sad.",
        .sad: "I'm sad",
        .neutral: "I'm feeling ok",
        .happy: "I'm feeling happy!",
        .extremeHappy: "I've feeling amazing!"
    ]
    
    var palStats: [PalStat] {
        return palStore.palStats
    }
    
    var scene: SKScene {
        let palHomeScene = PalHomeScene()
        
        palHomeScene.palStore = palStore
        palHomeScene.size = CGSize(width: 400, height: 400)
        return palHomeScene
    }
    
    var body: some View {
        VStack {
            if palStore.stateUpdating {
                ProgressView()
            } else {
                Spacer()
                SpriteView(scene: scene)
                    .frame(width: 400, height: 400)
                ActionButton(label: labelMap[palStore.palState] ?? "...") { return }
                    .padding()
                Spacer()
            }
            
        }
        .frame(maxWidth: .infinity)
        .background(Color(hue: 0.326, saturation: 0.0, brightness: 0.819))
    }
}

struct Home_Previews: PreviewProvider {
    static var healthStore = HealthStore()
    static var previews: some View {
        Home()
            .environmentObject(PalStore(healthStore: healthStore))
            .environmentObject(healthStore)
    }
}
