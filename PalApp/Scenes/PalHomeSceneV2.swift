//
//  PalHomeSceneV2.swift
//  PalApp
//
//  Created by Rhys Mackenzie on 2022-10-25.
//

import Foundation
import SpriteKit

class PalHomeSceneV2: SKScene {
    var palStore: PalStore?
    let palSize = CGSize(width: 75.0, height: 75.0)
    var palNode: PalNode?
    
    override func didMove(to view: SKView) {
        let palState = palStore?.palState ?? .neutral
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        palNode = setupPal(state: palStore?.palState ?? .neutral)
        
        if palState != .new {
            palNode!.startIdleAnimation()
        }
        
        let pal = palNode!.getPal()
        pal.position = CGPoint(x: frame.maxX / 2, y: frame.maxY / 2)
        addChild(pal)
    }
    
    private func setupPal(state: PalState) -> PalNode {
        return PalNode(state: state, stage: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let node: SKNode = self.atPoint(location)

        if(node.name == "pal" && palStore?.palState == .new){
            UserDefaults.standard.set(Date(), forKey: "lastEvolved")
            palStore!.updatePalState() { palState in
                print("updated")
                self.palNode?.updatePalState(palState: palState)
            }
        }
    }
}
