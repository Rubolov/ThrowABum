//
//  BumNode.swift
//  ThrowABum
//
//  Created by Yuriy Yakimenko on 16.04.2023.
//

import SpriteKit

class BumNode: SKSpriteNode {
    
    init(_ bum: Bum) {
        let texture = SKTexture(imageNamed: bum.Sprite!)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: texture.size())
        self.xScale = CGFloat(bum.XScale!.floatValue)
        self.yScale = CGFloat(bum.YScale!.floatValue)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.angularDamping = 0.25
        self.physicsBody?.mass = CGFloat(bum.Mass!.doubleValue)
        self.physicsBody?.restitution = CGFloat(bum.Restitution!.doubleValue)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
