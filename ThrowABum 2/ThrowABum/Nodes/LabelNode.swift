//
//  LabelNode.swift
//  ThrowABum
//
//  Created by Yuriy Yakimenko on 08.04.2023.
//

import SpriteKit

class LabelNode: SKLabelNode {
    
    convenience init(text: String, fontSize: CGFloat, position: CGPoint, fontColor: UIColor) {
        self.init(fontNamed: UI_Font)
        self.text = text
        self.fontSize = fontSize
        self.position = position
        self.fontColor = fontColor
    }
}
