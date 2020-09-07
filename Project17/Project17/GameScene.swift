//
//  GameScene.swift
//  Project17
//
//  Created by Ayşıl Simge Karacan on 4.09.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    
    var possibleEnemies = ["ball", "hammer", "tv"]
    var gameTimer: Timer?
    var seconds: TimeInterval = 1
    var isGameOver = false
    var canMove: Bool = true
    
    var enemyCount = 0 {
        didSet {
            if enemyCount == 20 {
                enemyCount = 0
                seconds -= 0.1
            }
        }
    }

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10) // Once added to a scene, an emitter node automatically creates new particles in new animation frames. This method allows you to artificially advance a running emitter’s simulation, causing it to generate new particles and advance any existing particles. The most common use for this method is to prepopulate an emitter node with particles after it is first added to a scene.

        addChild(starfield)
        starfield.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self // A delegate that is called when two physics bodies come in contact with each other.
        
        gameTimer?.invalidate()
        
        gameTimer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    @objc func createEnemy() {
        guard let enemy = possibleEnemies.randomElement() else { return }
        enemyCount += 1
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0) // Creates a vector with components specified as integer values.
        sprite.physicsBody?.angularVelocity = 5 // The physics body’s angular speed.
        sprite.physicsBody?.linearDamping = 0 //  property that reduces the body’s linear velocity.
        sprite.physicsBody?.angularDamping = 0 // A property that reduces the body’s rotational velocity.
    }

    override func update(_ currentTime: TimeInterval) {
        // children -> The node’s children. The objects in this array are all SKNode objects.
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        if !isGameOver { score += 1 }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        if canMove {
            if location.y < 100 {
                location.y = 100
            } else if location.y > 668 {
                location.y = 668
            }
        }
        
        player.position = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        canMove = player.contains(location) ? true : false
    }
    
    func didBegin(_ contact: SKPhysicsContact) { // Called when two bodies first contact each other.
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        gameTimer?.invalidate()
        isGameOver = true
        starfield.isPaused = true
        
        gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = "Game Over! Score: \(score)"
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        addChild(gameOverLabel)
    }
    
}
