//
//  PalNode.swift
//  PalApp
//
//  Created by Rhys Mackenzie on 2022-10-26.
//

import Foundation
import SpriteKit

let PAL_SIZE = CGSize(width: 75.0, height: 75.0)
let IDLE_FRAMES = 11

class PalNode {
    var state: PalState!
    var stage: Int!
    private var baseSpriteName: String!
    private var pal: SKSpriteNode!
    
    init(state: PalState, stage: Int) {
        self.state = state
        self.stage = stage
        
        _setupPal()
    }
    
    private var palAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "Pal")
    }
    
    private var palIdleTextures: [SKTexture] {
        return (0..<IDLE_FRAMES).map {
            palAtlas.textureNamed("\(baseSpriteName!)-idle-\($0 + 1)")
        }
    }
    
    private func _setupPal() {
        if state == .new {
            self.baseSpriteName = "egg"
        } else {
            self.baseSpriteName = "stage-\(stage!)-\(state.rawValue)"
        }
        
        let pal = SKSpriteNode(imageNamed: baseSpriteName)
        pal.name = "pal"
        pal.physicsBody = SKPhysicsBody(rectangleOf: PAL_SIZE)
        pal.size = PAL_SIZE
        self.pal = pal
    }
    
    func updatePalState(palState: PalState) {
        self.state = palState
        if state == .new {
            self.baseSpriteName = "egg"
        } else {
            self.baseSpriteName = "stage-\(stage!)-\(state.rawValue)"
        }
        pal.texture = SKTexture(imageNamed: baseSpriteName)
        print("adding texture")
    }
    
    func getPal() -> SKSpriteNode {
        return pal;
    }
    
    func startIdleAnimation() {
        let idleAnimation = SKAction.animate(with: palIdleTextures, timePerFrame: 0.3)
        
        pal.run(SKAction.repeatForever(idleAnimation), withKey: "palIdleAnimation")
    }
}
