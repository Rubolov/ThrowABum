//
//  GameViewController.swift
//  ThrowABum
//
//  Created by Yuriy Yakimenko on 06.04.2023.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if let scene = MenuScene(fileNamed: "MenuScene") {
                scene.scaleMode = .resizeFill
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
