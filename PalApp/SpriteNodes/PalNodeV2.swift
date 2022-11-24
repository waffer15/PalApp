//
//  PalNodeV2.swift
//  PalApp
//
//  Created by Rhys Mackenzie on 2022-11-04.
//

import Foundation
import SpriteKit



class PalNodeV2: SKSpriteNode {
    let IDLE_FRAMES = 8
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init(imageNamed: String, size: CGSize) {
        super.init(texture: SKTexture(imageNamed: imageNamed), color: UIColor.clear, size: size)

        name = NSStringFromClass(PalNodeV2.self)
        physicsBody = SKPhysicsBody(rectangleOf: size)
    }
    
    private var palAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "stage0")
    }
    
    func getIdleAnimation(baseSpriteName: String) -> [SKTexture] {
        return (0..<IDLE_FRAMES).map {
            palAtlas.textureNamed("\(baseSpriteName)-idle-\($0 + 1)")
        }
    }
    func updateTexture(imageNamed: String) {
        texture = SKTexture(imageNamed: imageNamed)
    }
}
