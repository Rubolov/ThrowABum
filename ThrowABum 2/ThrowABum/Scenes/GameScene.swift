//
//  GameScene.swift
//  ThrowABum
//
//  Created by Yuriy Yakimenko on 06.04.2023.
//

import SpriteKit


class GameScene: SimpleScene {
    
    var scoreLabelNode = SKLabelNode()
    var hightscoreLabelNode = SKLabelNode()
    var backButtonNode = SKSpriteNode()
    var resetButtonNode = SKSpriteNode()
    var bumNode = SKSpriteNode()
    
    var didSwipe = false
    var start = CGPoint.zero
    var startTime = TimeInterval()
    var currentScore = 0
    
    var popSound = SKAction()
    var failSound = SKAction()
    var winSound = SKAction()
    
    override func didMove(to view: SKView) {
        self.physicsBody?.restitution = 0
        self.backgroundColor = UI_BACKGROUND_COLOR
        
        self.setupUINodes()
        self.setupGameNodes()
        
        popSound = SKAction.playSoundFileNamed(GAME_SOUND_POP, waitForCompletion: false)
        failSound = SKAction.playSoundFileNamed(GAME_SOUND_FAIL, waitForCompletion: false)
        winSound = SKAction.playSoundFileNamed(GAME_SOUND_SUCCESS, waitForCompletion: false)
    }
    func setupUINodes() {
        scoreLabelNode = LabelNode(text: "0", fontSize: 140, position: CGPoint(x: self.frame.midX, y: self.frame.midY + 200), fontColor: .cyan)
        scoreLabelNode.zPosition = -1
        self.addChild(scoreLabelNode)
        
        hightscoreLabelNode = LabelNode(text: "NEW RESULT", fontSize: 32, position: CGPoint(x: self.frame.midX, y: self.frame.midY + 160), fontColor: .cyan)
        hightscoreLabelNode.zPosition = -1
        self.addChild(hightscoreLabelNode)
        
        backButtonNode = ButtonNode(imageNode: "back_button", position: CGPoint(x: self.frame.minX + backButtonNode.size.width + 30, y: self.frame.maxY - backButtonNode.size.height - 40), xScale: 0.10, yScale: 0.10)
        self.addChild(backButtonNode)
        
        resetButtonNode = ButtonNode(imageNode: "reset_button", position: CGPoint(x: self.frame.maxX - resetButtonNode.size.width - 40, y: self.frame.maxY - resetButtonNode.size.height - 40), xScale: 0.10, yScale: 0.10)
        self.addChild(resetButtonNode)
    }
    func setupGameNodes() {
        
        let tableNode = SKSpriteNode(imageNamed: "table")
        
        tableNode.physicsBody = SKPhysicsBody(rectangleOf: (tableNode.texture?.size())!)
        tableNode.physicsBody?.isDynamic = false
        tableNode.physicsBody?.restitution = 0
        tableNode.xScale = 0.85
        tableNode.yScale = 0.85
        tableNode.position = CGPoint(x: self.frame.midX , y: 29)
        self.addChild(tableNode)
        
        let selectedBum = self.userData?.object(forKey: "bum")
        bumNode = BumNode(selectedBum as! Bum)
        self.addChild(bumNode)
        
        self.resetBum()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count > 1 {
            return
        }
        let touch = touches.first
        let location = touch?.location(in: self)
        
        start = location!
        startTime = touch!.timestamp
    }
    func failedFlip() {
        self.playSoundFX(failSound)
        currentScore = 0
        
        self.updateScore()
        
        self.resetBum()
    }
    func resetBum() {
        bumNode.position = CGPoint(x: self.frame.midX , y: bumNode.size.height )
        
        bumNode.physicsBody?.angularVelocity = 0
        bumNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        bumNode.speed = 0
        bumNode.zPosition = 0
        didSwipe = false
        
        self.playSoundFX(popSound)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if backButtonNode.contains(location) {
                self.playSoundFX(popSound)
                self.changeToSceneBy(nameScene: "MenuScene", userData: NSMutableDictionary.init())
            }
            
            if resetButtonNode.contains(location) {
                self.playSoundFX(popSound)
                failedFlip()
            }
        }
        if !didSwipe {
            let touch = touches.first
            let location = touch?.location(in: self)
            
            let x = ceil(location!.x - start.x)
            let y = ceil(location!.y - start.y)
            
            let distance = sqrt(x*x + y*y)
            let time = CGFloat(touch!.timestamp - startTime)
            
            if (distance >= GAME_SWIPE_MIN_DISTANSE && y > 0) {
                let speed = distance / time
                
                if speed >= GAME_SWIOE_MIN_SPEED {
                    bumNode.physicsBody?.angularVelocity = CGFloat(GAME_ANGULAR_VELOSITY)
                    bumNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: distance * GAME_DISTANCE_MULTIPLIER))
                    didSwipe = true
                }
            }
        }
    }
    override func update(_ currentTime: TimeInterval) {
        
        self.checkIfSuccessfulFlip()
    }
    func checkIfSuccessfulFlip() {
        if (bumNode.position.x <= 0 || bumNode.position.x >= self.frame.size.width || bumNode.position.y <= 0) {
            self.failedFlip()
        }
        if (didSwipe && bumNode.physicsBody!.isResting) {
            let bumRotation = abs(bumNode.zRotation)
            
            if bumRotation > 0 && bumRotation < 0.55 {
                self.successFlip()
            } else {
                self.failedFlip()
            }
        }
    }
    func successFlip() {
        self.playSoundFX(winSound)
        
        self.updateFlips()
        
        currentScore += 1
        self.updateScore()
        
        self.resetBum()
    }
    func updateScore() {
        scoreLabelNode.text = "\(currentScore)"
        
        let localHighscore = UserDefaults.standard.integer(forKey: "localHighscore")
        
        if currentScore > localHighscore {
            hightscoreLabelNode.isHidden = false
            
            let fadeAction = SKAction.fadeAlpha(to: 0, duration: 1.0)
            
            hightscoreLabelNode.run(fadeAction, completion: {
                self.hightscoreLabelNode.isHidden = true
            })
            UserDefaults.standard.set(currentScore, forKey: "localHighscore")
            UserDefaults.standard.synchronize()
        }
    }    
    func updateFlips() {
        var flips = UserDefaults.standard.integer(forKey: "flips")
        
        flips += 1
        UserDefaults.standard.set(flips, forKey: "flips")
        UserDefaults.standard.synchronize()
    }
}
