//
//  PalHomeScene.swift
//  PalApp
//
//  Created by Rhys Mackenzie on 2022-10-19.
//

import Foundation
import SpriteKit
import SwiftUI


enum PalAnimationState {
    case idle
}


class PalHomeScene: SKScene {
    var palNode: PalNodeV2!
    var palStore: PalStore?
    var currentPalState: PalState = .neutral
    var todaysHealthRing: HealthRing?

    // stats bars
    var firstBarContainer: SKSpriteNode!
    var firstBar: SKSpriteNode!
    var firstBarText: SKLabelNode!
    var secondBarContainer: SKSpriteNode!
    var secondBar: SKSpriteNode!
    var secondBarText: SKLabelNode!
    var thirdBarContainer: SKSpriteNode!
    var thirdBar: SKSpriteNode!
    var thirdBarText: SKLabelNode!
    
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "living-room")
        let padding = 75.0
        let backgroundPos = CGPoint(x: (size.width / 2), y: (size.height - padding) / 2)
        let bacgkroundSize = CGSize(width: size.width, height: size.height - padding)
        
        background.zPosition = 0
        background.position = backgroundPos
        background.size = bacgkroundSize
        addChild(background)
        
        scaleMode = .aspectFit
        let physicsFrame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height)
        physicsBody = SKPhysicsBody(edgeLoopFrom: physicsFrame)
        
        configurePal()
        configureStatsBar()
        configureLabels()
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let store = palStore else { return }
        
        if currentPalState != store.palState {
            currentPalState = store.palState
            updatePalState()
        }
    }
    
    func updatePalState() {
        palNode.updateTexture(imageNamed: getTextureName(stage: 0, palState: currentPalState))
        startPalIdleAnimation()
        updateStatBars()
    }
    
    func updateStatBars() {
        guard let healthRing = palStore?.todaysHealthRing else { return }
        
        let maxBarWidth = activityBarMaxSize().width
        
        let moveBarWidth = min(healthRing.moveRing.progress * maxBarWidth, maxBarWidth)
        updateActivityBarWidth(bar: firstBar, newWidth: moveBarWidth, container: firstBarContainer)
        firstBarText.text = "\(round(healthRing.moveRing.progress * 100))%"
        
        let exerciseBarWidth = min(healthRing.exerciseRing.progress * maxBarWidth, maxBarWidth)
        updateActivityBarWidth(bar: secondBar, newWidth: exerciseBarWidth, container: secondBarContainer)
        secondBarText.text = "\(round(healthRing.exerciseRing.progress * 100))%"
        
        let standBarWidth = min(healthRing.standRing.progress * maxBarWidth, maxBarWidth)
        updateActivityBarWidth(bar: thirdBar, newWidth: standBarWidth, container: thirdBarContainer)
        thirdBarText.text = "\(round(healthRing.standRing.progress * 100))%"
    }
    
    func updateActivityBarWidth(bar: SKSpriteNode, newWidth: Double, container: SKSpriteNode) {
        let padding = 5.0
        bar.size.width = newWidth
        bar.position.x = container.frame.minX + (newWidth / 2.0) + padding
    }
}

// Helper Properties

extension PalHomeScene {
    func activityBarContainerSize() -> CGSize {
        return CGSize(width: frame.width / 4.0, height: 25.0)
    }
    
    func activityBarMaxSize() -> CGSize {
        let width = activityBarContainerSize().width
        let height = activityBarContainerSize().height
        return CGSize(width: width - 10, height: height - 5)
    }
}

// Configuration

extension PalHomeScene {
    func configurePal() {
        guard let store = palStore else { return }
        
        let palSize = CGSize(width: frame.width, height: frame.width / 1.25)
        palNode = PalNodeV2(imageNamed: getTextureName(stage: 0, palState: store.palState), size: palSize)
        palNode.position = CGPoint(x: frame.maxX / 2, y: frame.maxY / 2)
        
        addChild(palNode)
    }
    
    func configureStatsBar() {
        let padding = 15.0
        let barY = frame.maxY - 20
        let barX = frame.minX + padding
        
        let barWidth = activityBarContainerSize().width
        
        // initialize containers
        let firstBarContainer = getStatsBarContainer()
        firstBarContainer.position.x = barX + padding + (barWidth / 2.0)
        firstBarContainer.position.y = barY
        addChild(firstBarContainer)
        
        let secondBarContainer = getStatsBarContainer()
        secondBarContainer.position.x = firstBarContainer.position.x + padding + barWidth
        secondBarContainer.position.y = barY
        addChild(secondBarContainer)
        
        let thirdBarContainer = getStatsBarContainer()
        thirdBarContainer.position.x = secondBarContainer.position.x + padding + barWidth
        thirdBarContainer.position.y = barY
        addChild(thirdBarContainer)
        
        self.firstBarContainer = firstBarContainer
        self.secondBarContainer = secondBarContainer
        self.thirdBarContainer = thirdBarContainer
        
        // initialize activity bars
        firstBar = getActivityBar(color: UIColor(hue: 0.001, saturation: 0.693, brightness: 0.755, alpha: 1))
        firstBar.position = firstBarContainer.position
        addChild(firstBar)
        secondBar = getActivityBar(color: UIColor(hue: 0.332, saturation: 0.869, brightness: 0.674, alpha: 1))
        secondBar.position = secondBarContainer.position
        addChild(secondBar)
        thirdBar = getActivityBar(color: UIColor(hue: 0.619, saturation: 0.869, brightness: 0.674, alpha: 1))
        thirdBar.position = thirdBarContainer.position
        addChild(thirdBar)
    }
    
    func configureLabels() {
        let offset = 30.0
        firstBarText = createActivityBarLabel(position: CGPoint(x: firstBar.position.x, y: firstBar.position.y - offset))
        secondBarText = createActivityBarLabel(position: CGPoint(x: secondBar.position.x, y: secondBar.position.y - offset))
        thirdBarText = createActivityBarLabel(position: CGPoint(x: thirdBar.position.x, y: thirdBar.position.y - offset))
        
        addChild(firstBarText)
        addChild(secondBarText)
        addChild(thirdBarText)
    }
    
    func createActivityBarLabel(position: CGPoint) -> SKLabelNode {
        let label = SKLabelNode(fontNamed: "Nanum Gothic")
        label.fontSize = 15
        label.fontColor = .white
        label.position = position
        return label
    }
    func getStatsBarContainer() -> SKSpriteNode {
        let container = SKShapeNode(rectOf: activityBarContainerSize())
        container.fillColor = .white
        container.strokeColor = .black
        
        return SKSpriteNode(texture: view!.texture(from: container))
    }
    
    func getActivityBar(color: UIColor) -> SKSpriteNode {
        let container = SKShapeNode(rectOf: activityBarMaxSize())
        container.fillColor = color
        
        return SKSpriteNode(texture: view!.texture(from: container))
    }
}


// Touch handling

extension PalHomeScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let node: SKNode = self.atPoint(location)

        if(node.name == NSStringFromClass(PalNodeV2.self) && palStore?.palState == .new){
            UserDefaults.standard.set(Date(), forKey: "lastEvolved")
            hatchPal()
        }
    }
    
    func getTextureName(stage: Int, palState: PalState) -> String {
        if palState == .new {
            return "egg"
        }
        return palState.rawValue
    }
    
    func hatchPal() {
        palStore!.updatePalState() { palState in
            self.palNode.updateTexture(imageNamed: self.getTextureName(stage: 0, palState: palState))
        }
        
    }
}


// Animations

extension PalHomeScene {
    func startPalIdleAnimation() {
        guard let store = palStore else { return }
        
        if currentPalState == .new {
            return
        }
        
        let baseSpriteName = getTextureName(stage: 0, palState: store.palState)
        let idleAnimation = SKAction.animate(with: palNode.getIdleAnimation(baseSpriteName: baseSpriteName), timePerFrame: 0.3)
        
        palNode.run(SKAction.repeatForever(idleAnimation), withKey: "palIdleAnimation")
    }
}
