//
//  MenuScene.swift
//  ThrowABum
//
//  Created by Yuriy Yakimenko on 06.04.2023.
//

import SpriteKit

class MenuScene: SimpleScene {
    var playButtonNode = SKSpriteNode()
    var tableNode = SKSpriteNode()
    var bumNode = SKSpriteNode()
    var leftButtonNode = SKSpriteNode()
    var rightButtonNode = SKSpriteNode()
    var flipsTagNode = SKSpriteNode()
    var unlockLabelNode = SKLabelNode()
    
    var highscore = 0
    var totalFlips = 0
    var bums = [Bum]()
    var selectedBumIndex = 0
    var totalBums = 0
    var isShopButton = false
    
    var popSound = SKAction()
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UI_BACKGROUND_COLOR
        
        bums = BumController.readItems()
        totalBums = bums.count
        
        highscore = UserDefaults.standard.integer(forKey: "localHighscore")
        totalFlips = UserDefaults.standard.integer(forKey: "flips")
        
        popSound = SKAction.playSoundFileNamed(GAME_SOUND_POP, waitForCompletion: false)
     
        setupUI()
    }
    func setupUI() {
        
        let logo = ButtonNode(imageNode: "logo", position: CGPoint(x: self.frame.midX, y: self.frame.maxY - 80), xScale: 1, yScale: 1)
        self.addChild(logo)
        
        let bestScoreLabelNode = LabelNode(text: "BEST SCORE", fontSize: 15, position: CGPoint(x: self.frame.midX - 135, y: self.frame.maxY - 180), fontColor: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1))
        self.addChild(bestScoreLabelNode)
        
        let hightScoreLabelNode = LabelNode(text: String(highscore), fontSize: 70, position: CGPoint(x: self.frame.midX - 135, y: self.frame.maxY - 250), fontColor: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1))
        self.addChild(hightScoreLabelNode)
        
        let totalFlipsLabelNode = LabelNode(text: "NUMBERS OF SALTAS", fontSize: 15, position: CGPoint(x: self.frame.midX + 115, y: self.frame.maxY - 180), fontColor: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1))
        self.addChild(totalFlipsLabelNode)
        
        let flipsLabelNode = LabelNode(text: String(totalFlips), fontSize: 70, position: CGPoint(x: self.frame.midX + 135, y: self.frame.maxY - 250), fontColor: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1))
        self.addChild(flipsLabelNode)
        
        playButtonNode = ButtonNode(imageNode: "play_button", position: CGPoint(x: self.frame.midX, y: self.frame.midY - 15), xScale: 0.3, yScale: 0.3)
        self.addChild(playButtonNode)
        
        tableNode = ButtonNode(imageNode: "table", position: CGPoint(x: self.frame.midX, y: self.frame.minY - 30), xScale: 0.60, yScale: 0.60)
        tableNode.zPosition = 3
        self.addChild(tableNode)
        
        selectedBumIndex = BumController.getSaveBumIndex()
        let selectedBum = bums[selectedBumIndex]
        bumNode = SKSpriteNode(imageNamed: selectedBum.Sprite!)
        bumNode.zPosition = 10
        self.addChild(bumNode)
        
        leftButtonNode = ButtonNode(imageNode: "left_button", position: CGPoint(x: self.frame.midX +
                                                                                leftButtonNode.size.width - 130, y: self.frame.minY - leftButtonNode.size.height + 145), xScale: 0.07, yScale: 0.07)
        self.changeButton(leftButtonNode, state: false)
        self.addChild(leftButtonNode)
        
        rightButtonNode = ButtonNode(imageNode: "right_button", position: CGPoint(x: self.frame.midX +
                                                                                  rightButtonNode.size.width + 130, y: self.frame.minY - rightButtonNode.size.height + 145), xScale: 0.07, yScale: 0.07)
        self.changeButton(rightButtonNode, state: true)
        self.addChild(rightButtonNode)
        
        flipsTagNode = ButtonNode(imageNode: "lock", position: CGPoint(x: self.frame.midX + bumNode.size.width * 0.20, y: self.frame.minY + bumNode.size.height/2 + 10), xScale: 0.1, yScale: 0.1)
        flipsTagNode.zPosition = 25
        flipsTagNode.zRotation = 0.3
        self.addChild(flipsTagNode)
        
        unlockLabelNode = LabelNode(text: "0", fontSize: 170, position: CGPoint(x: 0, y: -unlockLabelNode.frame.size.height - 145), fontColor: .white)
                                    unlockLabelNode.zPosition = 30
                                    flipsTagNode.addChild(unlockLabelNode)
        
        self.updateSelectedBum(selectedBum)
        
        self.pulseLockNode(flipsTagNode)
    }
    func changeButton(_ buttonNode: SKSpriteNode, state: Bool) {
        var buttonColor = #colorLiteral(red: 0.3752416968, green: 0.6382335424, blue: 0.7075284123, alpha: 0.2074451573)
        
        if state {
            buttonColor = #colorLiteral(red: 0.4167990088, green: 0.7314438224, blue: 0.8265272975, alpha: 1)
        }
        buttonNode.color = buttonColor
        buttonNode.colorBlendFactor = 1
}
    func updateSelectedBum(_ bum: Bum) {
        
        let unlockFlips = bum.MinFlips!.intValue - highscore
        let unlocked = (unlockFlips <= 0)
        
        flipsTagNode.isHidden = unlocked
        unlockLabelNode.isHidden = unlocked
        
        bumNode.texture = SKTexture(imageNamed: bum.Sprite!)
        playButtonNode.texture = SKTexture(imageNamed: (unlocked ? "play_button" : "shop_button"))
        
        isShopButton = !unlocked
        
        bumNode.size = CGSize(width: bumNode.texture!.size().width * CGFloat(bum.XScale!.floatValue), height: bumNode.texture!.size().height * CGFloat(bum.YScale!.floatValue))
        
        bumNode.position = CGPoint(x: self.frame.midX, y: self.frame.minY + bumNode.size.height/2 + 94)
        
        flipsTagNode.position = CGPoint(x: self.frame.midX + bumNode.size.width * 0.20, y: self.frame.minY + bumNode.size.height/2 + 10)
        
        unlockLabelNode.text = "\(bum.MinFlips!.intValue)"
        unlockLabelNode.position = CGPoint(x: 0, y: -unlockLabelNode.frame.size.height - 45)
        
        self.updateArrowState()
    }
    func updateArrowState() {
        self.changeButton(leftButtonNode, state: Bool(truncating: selectedBumIndex as NSNumber))
        self.changeButton(rightButtonNode, state: Bool(selectedBumIndex != totalBums - 1))
    }
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if playButtonNode.contains(location) {
                self.playSoundFX(popSound)
                self.startGame()
            }
            if leftButtonNode.contains(location) {
                let prevIndex = selectedBumIndex - 1
                if prevIndex >= 0 {
                    self.playSoundFX(popSound)
                    self.updateByIndex(prevIndex)
                }
            }
            if rightButtonNode.contains(location) {
                let nextIndex = selectedBumIndex + 1
                if nextIndex < totalBums {
                    self.playSoundFX(popSound)
                    self.updateByIndex(nextIndex)
                }
            }
        }
    }
    func updateByIndex(_ index: Int) {
        let bum = bums[index]
        
        selectedBumIndex = index
        
        self.updateSelectedBum(bum)
        BumController.saveSelectedBum(selectedBumIndex)
    }
    func pulseLockNode(_ node: SKSpriteNode) {
        let scaleDownAction = SKAction.scale(to: 0.3, duration: 0.5)
        let scaleUpAction = SKAction.scale(to: 0.2, duration: 0.2)
        let seq = SKAction.sequence([scaleDownAction, scaleUpAction])
        
        node.run(SKAction.repeatForever(seq))
}
    func startGame() {
            if !isShopButton {
                let userData = ["bum": bums[selectedBumIndex]]
                let mutableUserData = NSMutableDictionary(dictionary: userData)
                self.changeToSceneBy(nameScene: "GameScene", userData: mutableUserData)
            } else {
                print("Go Buy Bum")
            }
        }
    }

