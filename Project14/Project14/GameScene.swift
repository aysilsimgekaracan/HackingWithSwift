//
//  GameScene.swift
//  Project14
//
//  Created by Ayşıl Simge Karacan on 27.08.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var gameScore: SKLabelNode!
    var slots = [WhackSlot]()
    
    var popupTime = 0.85
    var numRounds = 0
    
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.createEnemy()
        }
        
        }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tapppedNodes = nodes(at: location)
        
        for node in tapppedNodes {
            // It gets the parent of the parent of the node, and typecasts it as a WhackSlot. This line is needed because the player has tapped the penguin sprite node, not the slot – we need to get the parent of the penguin, which is the crop node it sits inside, then get the parent of the crop node, which is the WhackSlot object, which is what this code does.
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            
            if !whackSlot.isVisible { continue }
            if whackSlot.isHit { continue }
            whackSlot.hit()
            
//            if let smokeParticles = SKEmitterNode(fileNamed: "SmokeParticle") {
//                smokeParticles.position = whackSlot.position
//                smokeParticles.particleLifetime = 0.3
//                addChild(smokeParticles)
//            }

            if node.name == "charFriend" {
                score -= 5
                
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false)) // plays a sound and optionally waits for the sound to finish playing before continuing
            } else if node.name == "charEnemy" {
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                score += 1
                
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            }
        }
    }

    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }

    func createEnemy() {
        numRounds += 1
        
        if numRounds >= 30 {
            for slot in slots {
                slot.hide()
            }
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            
            let finalScore = SKLabelNode(fontNamed: "Chalkduster")
            finalScore.text = "Final Score: \(score)"
            finalScore.zPosition = 1
            finalScore.position = CGPoint(x: 500, y: 300)
            addChild(finalScore)
            
            run(SKAction.playSoundFileNamed("gameOver.wav", waitForCompletion: false))
            return
        }
        
        popupTime *= 0.991
        
        slots.shuffle()
        slots[0].show(hideTime: popupTime)
        
        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 8 { slots[2].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popupTime) }

        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
        }
        
    }

}
