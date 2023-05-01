//
//  Bum.swift
//  ThrowABum
//
//  Created by Yuriy Yakimenko on 08.04.2023.
//

import Foundation

class Bum {
    var Sprite: String?
    var Mass: NSNumber?
    var Restitution: NSNumber?
    var XScale: NSNumber?
    var YScale: NSNumber?
    var MinFlips: NSNumber?
    
    init(_ bumDictionary: NSDictionary) {
        self.Sprite = bumDictionary["Sprite"] as? String
        self.Mass = bumDictionary["Mass"] as? NSNumber
        self.Restitution = bumDictionary["Restitution"] as? NSNumber
        self.XScale = bumDictionary["XScale"] as? NSNumber
        self.YScale = bumDictionary["YScale"] as? NSNumber
        self.MinFlips = bumDictionary["MinFlips"] as? NSNumber
    }
}
