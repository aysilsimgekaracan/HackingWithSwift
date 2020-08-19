//
//  GameScene.swift
//  Project11
//
//  Created by Ayşıl Simge Karacan on 18.08.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    // SKPhysicsContactDelegate -> An object that implements the SKPhysicsContactDelegate protocol can respond when two physics bodies with overlapping contactTestBitMask values are in contact with each other in a physics world.
    
    var scoreLabel: SKLabelNode!
    var editLabel: SKLabelNode!
    var ballsLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    
    var balls = ["ballBlue", "ballCyan", "ballGreen", "ballGrey", "ballPurple", "ballRed", "ballYellow"]
    var showParticles: Bool = true
    
    var numOfBoxes = 0 {
        didSet {
            if numOfBoxes <= 0 {
                gameFinished(text: "You win the game, Game Over!")
            }
        }
    }
    
    var numOfBalls = 5 {
        didSet {
            ballsLabel.text = "Balls: \(numOfBalls)"
            if numOfBalls == 0 {
                gameFinished(text: "You lost the game, Game Over!")
            }
        }
    }
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    
    override func didMove(to view: SKView) {
        // SKSpriteNode is an onscreen graphical element that can be initialized from an image or a solid color.
        let background = SKSpriteNode(imageNamed: "background")
        
        // The position of the node in its parent's coordinate system.
        background.position = CGPoint(x: 512, y: 384)
        
        // Blend modes determine how a node is drawn
        // The .replace option means "just draw it, ignoring any alpha values"
        background.blendMode = .replace
        
        // Draw this behind everything else
        background.zPosition = -1
        
        //  Using addChild() you can add nodes to other nodes to make a more complicated tre
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        ballsLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballsLabel.text = "Balls: 5"
        ballsLabel.horizontalAlignmentMode = .right
        ballsLabel.position = CGPoint(x: 980, y: 650)
        addChild(ballsLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        // SKPhysicsBody -> An object that adds physics simulation to a node.
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        // physicsWorld -> The physics simulation associated with the scene.
        // contactDelegate -> A delegate that is called when two physics bodies come in contact with each other.
        physicsWorld.contactDelegate = self
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))

        // END OF DID_MOVE
    }

    // This method gets called (in UIKit and SpriteKit) whenever someone starts touching their device.
    // touches -> A set of UITouch instances that represent the touches for the starting phase of the event, which is represented by event.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            // location -> returns the current location of the receiver in the coordinate system of the given node.
            let location = touch.location(in: self)

            // An array of all SKNode objects in the subtree that intersect the point.
            let objects = nodes(at: location)
            
            if objects.contains(editLabel) {
                editingMode.toggle()
            } else {
                if editingMode { // create a box
                    let size = CGSize(width: Int.random(in: 16...128), height: 16)
                    let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: CGFloat.random(in: 0...1)), size: size)
                    box.zRotation = CGFloat.random(in: 0...3)
                    box.position = location
                    
                    box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                    box.physicsBody?.isDynamic = false
                    box.name = "box"
                    addChild(box)
                    numOfBoxes += 1
                    
                } else {
                    if location.y > 600 && numOfBalls > 0 {
                        let ball = SKSpriteNode(imageNamed: balls.randomElement() ?? "ballRed")
                        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                        
                        // The bounciness of the physics body.
                        ball.physicsBody?.restitution = 0.4
                        
                        // The collisionBitMask bitmask means "which nodes should I bump into?" By default, it's set to everything, which is why our ball are already hitting each other and the bouncers. The contactTestBitMask bitmask means "which collisions do you want to know about?" and by default it's set to nothing. So by setting contactTestBitMask to the value of collisionBitMask we're saying, "tell me about every collision."
                        ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                        
                        ball.position = location
                        ball.name = "ball"
                        addChild(ball)
                    }
                }

            }
            
        }
    }
    
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        
        // isDynamic -> A Boolean value that indicates whether the physics body is moved by the physics simulation.
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
        
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
      
        if isGood {
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotBase.name = "good" // The node’s assignable name.

        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size) // Add rectangle physics to our slots.
        slotBase.physicsBody?.isDynamic = false // The slot base needs to be non-dynamic because we don't want it to move out of the way when a player ball hits.

        addChild(slotBase)
        addChild(slotGlow)
        
        // SKAction is an animation that is executed by a node in the scene.
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        
        // repeatForever -> Creates an action that repeats another action forever.
        let spinForever = SKAction.repeatForever(spin)
        
        // run -> Adds an action to the list of actions executed by the node
        slotGlow.run(spinForever)

    }
    
    // collisionBetween() will be called when a ball collides with something else
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            showParticles = true
            destroy(ball: ball)
            score += 1
            numOfBalls += 1
        } else if object.name == "bad" {
            showParticles = true
            destroy(ball: ball)
            score -= 1
            numOfBalls -= 1
        }
        
        if object.name == "box" {
            showParticles = false
            destroy(ball: object)
            numOfBoxes -= 1
        }

    }
    
    //  destroy() is going to be called when we're finished with the ball and want to get rid of it.
    func destroy(ball: SKNode) {
        // A SKEmitterNode object is a node that automatically creates and renders small particle sprites.
        if showParticles {
            if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
                fireParticles.position = ball.position
                addChild(fireParticles)
            }
        }
        ball.removeFromParent()
    }
    
    // This method called when two bodies first contact each other.
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
        
        
        if nodeA.name == "box" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "box" {
            collision(between: nodeB, object: nodeA)
        }
        
    }
    
    func gameFinished(text: String) {
        isUserInteractionEnabled = false
        gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = text
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        gameOverLabel.fontSize = 40
        gameOverLabel.color = .red
        addChild(gameOverLabel)
        
        let wait = SKAction.wait(forDuration: 1)
        let action = SKAction.run { self.reset() }
        run(SKAction.sequence([wait, action]))
    }
    
    func reset() {
        let newScene = GameScene(size: self.size)
        newScene.scaleMode = self.scaleMode
        let animation = SKTransition.fade(withDuration: 1.0)
        self.view?.presentScene(newScene, transition: animation)
    }
    
    
    // END OF GAME_SCENE
}
