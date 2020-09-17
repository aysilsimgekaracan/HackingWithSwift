//
//  GameScene.swift
//  Milestone-Projects16-18
//
//  Created by Ayşıl Simge Karacan on 8.09.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var scoreLabel: SKLabelNode!
    var magazineLabel: SKLabelNode!
    var timeLabel: SKLabelNode!
    
    var rowTimer: Timer?
    var duckTimer: Timer?
    var gameDuration: Timer?
    
    var rowPositions = [CGPoint(x: 0, y: 100), CGPoint(x: 0, y: 300), CGPoint(x: 0, y: 500)]
    var allDucks = ["brownDuck_enemy" : +10, "brownDuck_friend": -10, "yellowDuck_enemy": +50, "yellowDuck_friend": -50]
    
    var secondsRemaining = 20 {
        didSet {
            timeLabel.text = "Time Left: \(secondsRemaining)"
            if secondsRemaining < 5 {
                timeLabel.fontColor = .red
                if secondsRemaining == 0 {
                    gameOver()
                }
            }
        }
    }
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var magazine = 6 {
        didSet {
            magazineLabel.text = String(magazine)
            if magazine == 0 {
                reload()
            }
        }
    }
    
    override func didMove(to view: SKView) {
        // Background
        let background = SKSpriteNode(imageNamed: "background")
        background.size = frame.size
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        // Score Label
        scoreLabel = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        scoreLabel.fontSize = 48
        scoreLabel.position = CGPoint(x: 1024, y: 0)
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.text = "Score: 0"
        scoreLabel.zPosition = 3
        addChild(scoreLabel)
        
        // Curtains
        let curtainTop = SKSpriteNode(imageNamed: "curtain_top")
        curtainTop.size = CGSize(width: frame.size.width, height: 250)
        curtainTop.position = CGPoint(x: frame.size.width / 2, y: 768)
        curtainTop.zPosition = 3
        addChild(curtainTop)
        
        let curtainLeft = SKSpriteNode(imageNamed: "curtain")
        curtainLeft.size = CGSize(width: 150, height: frame.size.height)
        curtainLeft.position = CGPoint(x: 50, y: frame.size.height / 2)
        curtainLeft.zPosition = 2
        addChild(curtainLeft)
        
        let curtainRight = SKSpriteNode(imageNamed: "curtain")
        curtainRight.xScale = curtainRight.xScale * -1;
        curtainRight.size = CGSize(width: 150, height: frame.size.height)
        curtainRight.position = CGPoint(x: 974, y: frame.size.height / 2)
        curtainRight.zPosition = 2
        addChild(curtainRight)
        
        // Magazine Icon
        let magazineIcon = SKSpriteNode(imageNamed: "magazine_icon")
        magazineIcon.size = CGSize(width: 48, height: 48)
        magazineIcon.position = CGPoint(x: 32, y: 32)
        magazineIcon.xScale = magazineIcon.xScale * -1
        magazineIcon.zPosition = 3
        addChild(magazineIcon)
        
        // Magazine Label
        magazineLabel = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        magazineLabel.fontSize = 48
        magazineLabel.position = CGPoint(x: 80, y: 16)
        magazineLabel.zPosition = 3
        magazineLabel.text = "6"
        addChild(magazineLabel)
        
        // Time Label
        timeLabel = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        timeLabel.fontSize = 48
        timeLabel.zPosition = 4
        timeLabel.text = "Time Left: \(secondsRemaining)"
        timeLabel.position = CGPoint(x: 16, y: 742)
        timeLabel.horizontalAlignmentMode = .left
        timeLabel.verticalAlignmentMode = .top
        addChild(timeLabel)
        
        // Info Button
        let info = SKSpriteNode(imageNamed: "info")
        info.size = CGSize(width: 64, height: 64)
        info.position = CGPoint(x: 992, y: 736)
        info.name = "info"
        info.zPosition = 4
        addChild(info)
        
        createRows(rowSize: CGSize(width: 3000, height: 87), rowPosition: rowPositions[0])
        createRows(rowSize: CGSize(width: 3000, height: 87), rowPosition: rowPositions[1])
        createRows(rowSize: CGSize(width: 3000, height: 87), rowPosition: rowPositions[2])
        
        setTimers()
    }
    
    func setTimers() {
        gameDuration?.invalidate()
        gameDuration = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            self?.secondsRemaining -= 1
        })
        
        rowTimer?.invalidate()
        rowTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(generateWaterEffect), userInfo: nil, repeats: true)
        
        duckTimer?.invalidate()
        duckTimer = Timer.scheduledTimer(timeInterval: Double.random(in: 0.8...1.5), target: self, selector: #selector(generateDucks), userInfo: nil, repeats: true)
    }
    
    func showHudBackground() {
        self.children.map{($0 as SKNode).isPaused = true}
        for timer in [rowTimer, gameDuration, duckTimer] {
            timer?.invalidate()
        }
        
        let hudBackground = SKSpriteNode(imageNamed: "hud_background")
        hudBackground.size = CGSize(width: frame.size.width / 2, height: frame.size.width / 2)
        hudBackground.position = CGPoint(x: 512, y: 368)
        hudBackground.zPosition = 5
        hudBackground.name = "hudBackground"
        addChild(hudBackground)
        
    }
    
    func gameOver() {

        showHudBackground()
        
        let gameOver = SKSpriteNode(imageNamed: "gameover")
        gameOver.size = CGSize(width: 349, height: 72)
        gameOver.position = CGPoint(x: 512, y: 536)
        gameOver.zPosition = 6
        addChild(gameOver)
        
        let finalScoreLabel = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        finalScoreLabel.fontColor = .green
        finalScoreLabel.text = scoreLabel.text
        finalScoreLabel.fontSize = 64
        finalScoreLabel.position = CGPoint(x: 512, y: 380)
        finalScoreLabel.zPosition = 6
        addChild(finalScoreLabel)
        
        let resetLabel = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        resetLabel.text = "RESET"
        resetLabel.name = "reset"
        resetLabel.fontColor = .red
        resetLabel.fontSize = 64
        resetLabel.position = CGPoint(x: 512, y: 264)
        resetLabel.zPosition = 6
        addChild(resetLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)

        for node in tappedNodes {
            guard let nodeName = node.name else { return }
            if allDucks.keys.contains(nodeName) {
                let isFriend: Bool
                score += allDucks[nodeName] ?? 0
                magazine -= 1
                
                if nodeName.contains("friend") {
                    isFriend = true
                } else {
                    isFriend = false
                }
                
                showEffect(location: location, isFriend: isFriend)
                node.removeFromParent()
            } else if nodeName == "reload" {
                magazine = 6
                node.removeFromParent()
                if let magazineLabelNode = self.childNode(withName: "reloadLabel") as? SKLabelNode {
                    magazineLabelNode.removeFromParent()
                }
            } else if nodeName == "reset" {
                resetGameScene()
            } else if nodeName == "info" {
                showInfo()
            } else if nodeName == "back" {
                goBack()
            }
        }
    }
    
    func showInfo() {
        showHudBackground()
        var height = 245
        var count = 0
        for duck in allDucks {
            let nodeImg = SKSpriteNode(imageNamed: duck.key)
            nodeImg.size = CGSize(width: 64, height: 64)
            nodeImg.position = CGPoint(x: 360, y: height)
            nodeImg.zPosition = 6
            nodeImg.name = "nodeImg\(count)"
            addChild(nodeImg)
            
            let nodeLabel = SKLabelNode(fontNamed: "MarkerFelt-Wide")
            nodeLabel.fontSize = 48
            nodeLabel.text = " -> \(duck.value) Points"
            nodeLabel.position = CGPoint(x: 540, y: height)
            nodeLabel.zPosition = 6
            nodeLabel.name = "nodeLabel\(count)"
            addChild(nodeLabel)
            
            height += 100
            count += 1
        }
        
        let backLabel = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        backLabel.fontSize = 64
        backLabel.fontColor = .red
        backLabel.position = CGPoint(x: 512, y: 150)
        backLabel.zPosition = 6
        backLabel.text = "BACK"
        backLabel.name = "back"
        addChild(backLabel)
    }
    
    func goBack() {
        self.children.map{($0 as SKNode).isPaused = false}
        setTimers()
        
        for nodeName in ["nodeImg0", "nodeLabel0","nodeImg1", "nodeLabel1","nodeImg2", "nodeLabel2","nodeImg3", "nodeLabel3", "back", "hudBackground"] {
            if let node = self.childNode(withName: nodeName) {
                node.removeFromParent()
            }
        }
    }
    
    func resetGameScene(){
        let gameScene:GameScene = GameScene(size: self.view!.bounds.size) // create your new scene
            let transition = SKTransition.fade(withDuration: 1.0) // create type of transition (you can check in documentation for more transtions)
            gameScene.scaleMode = SKSceneScaleMode.fill
        self.view!.presentScene(gameScene, transition: transition)
    }
    
    func reload() {
        // Show reload icon on the screen randomly
        let reloadIcon = SKSpriteNode(imageNamed: "reload_icon")
        reloadIcon.size = CGSize(width: 21, height: 44)
        reloadIcon.position = CGPoint(x: CGFloat(Int.random(in: 64...960)), y: CGFloat(Int.random(in: 64...704)))
        reloadIcon.zPosition = 4
        reloadIcon.name = "reload"
        addChild(reloadIcon)
        
        let reloadLabel = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        //reloadLabel.color =  hexStringToUIColor(hex: "#FF4500")
        reloadLabel.fontColor = .red
        reloadLabel.text = "!!RELOAD!!"
        reloadLabel.name = "reloadLabel"
        reloadLabel.fontSize = 48
        reloadLabel.zPosition = 4
        reloadLabel.position = CGPoint(x: 232, y: 16)
        addChild(reloadLabel)
    }
    
    func showEffect(location: CGPoint, isFriend: Bool) {
        let remove = SKAction.removeFromParent()
        if !isFriend {
            // Show Particle Effect
            
            if let particleNode = SKEmitterNode(fileNamed: "Particle") {
                particleNode.position = CGPoint(x: location.x, y: location.y - 30)
                particleNode.zPosition = 4
                
                addChild(particleNode)
                
                let duration = SKAction.wait(forDuration: 0.5)
                particleNode.run(SKAction.sequence([duration, remove]))
            }
        } else {
            // Show and Animate Target Image
            
            let target = SKSpriteNode(imageNamed: "target")
            target.size = CGSize(width: 64, height: 64)
            target.position = location
            target.zPosition = 3
            addChild(target)

            let resize = SKAction.resize(toWidth: 128, height: 128, duration: 0.5)
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            
            target.run(SKAction.sequence([resize, fadeOut, remove]))
        }

    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < 0 || node.position.x > 1024 {
                node.removeFromParent()
            }
        }
    }

    @objc func generateDucks() {
        let duck = SKSpriteNode(imageNamed: "brownDuck_friend")
        duck.zPosition = 0
        
        var nodeName = "brownDuck_friend"

        if Int.random(in: 0...5) == 0 {
            // yellow duck
            if Int.random(in: 0...1) == 0 {
                // yellow duck good
                nodeName = "yellowDuck_friend"
            } else {
                //yellow duck bad
                nodeName = "yellowDuck_enemy"
            }
        } else {
            // brown duck
            if Int.random(in: 0...5) == 0 {
                // brown duck bad
                nodeName = "brownDuck_friend"
            } else {
                // brown duck good
                
                nodeName = "brownDuck_enemy"
            }
        }
        
        duck.texture = SKTexture(imageNamed: nodeName)

        let row = Int.random(in: 0...2)

        if row == 1 {
            // middle row (right to left)
            duck.xScale = duck.xScale * -1
            duck.position = CGPoint(x: 1024, y: 390)
            duck.run(SKAction.repeatForever(SKAction.moveBy(x: CGFloat(Int.random(in: 150...400) * -1), y: 0, duration: 0.5)))
        } else {
            if row == 2 {
                // top row (left to right)
                duck.position = CGPoint(x: 0, y: 590)
            } else {
                // bottom row (left to right)
                duck.position = CGPoint(x: 0, y: 190)
            }
            duck.run(SKAction.repeatForever(SKAction.moveBy(x: CGFloat(Int.random(in: 150...400)), y: 0, duration: 0.5)))
        }
        
        duck.name = nodeName

        addChild(duck)
    }
    
    @objc func generateWaterEffect() {
        createWaterEffect(waterSize: CGSize(width: 66, height: 112), waterPosition: CGPoint(x: 0, y: 113))
        createWaterEffect(waterSize: CGSize(width: 66, height: 112), waterPosition: CGPoint(x: 1024, y: 312))
        createWaterEffect(waterSize: CGSize(width: 66, height: 112), waterPosition: CGPoint(x: 0, y: 513))
    }
    
    func createRows(rowSize: CGSize, rowPosition: CGPoint) {
        let row = SKShapeNode(rectOf: rowSize)
        row.fillColor = hexStringToUIColor(hex: "#3FA5E0")
        row.strokeColor = hexStringToUIColor(hex: "#A16D38")
        row.lineWidth = 3
        row.position = rowPosition
        row.zPosition = 1
        addChild(row)
    }
    
    func createWaterEffect(waterSize: CGSize, waterPosition: CGPoint) {
        let waterEffect = SKSpriteNode(imageNamed: "water")
        waterEffect.size = waterSize
        waterEffect.position = waterPosition
        waterEffect.zPosition = 1
        
        if waterPosition.x == 0 {
            waterEffect.run(SKAction.repeatForever(SKAction.moveBy(x: 200, y: 0, duration: 0.5)))
        } else {
            waterEffect.run(SKAction.repeatForever(SKAction.moveBy(x: -200, y: 0, duration: 0.5)))
        }
        
        addChild(waterEffect)
    }
    
    // Convert hex color to UIColor
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
