//
//  GameViewController.swift
//  Snakes
//
//  Created by mayank metha on 16/06/20.
//  Copyright © 2020 mayank metha. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
                    scene.size.height = scene.size.width * (UIScreen.main.bounds.size.width / UIScreen.main.bounds.size.height)
                } else {
                    scene.size.width = scene.size.height * (UIScreen.main.bounds.size.width / UIScreen.main.bounds.size.height)
                }
                scene.scaleMode = .aspectFit
                scene.backgroundColor = .black

                // Present the scene
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        var didHandleEvent = false
        for press in presses {
            guard let key = press.key else { continue }
            if key.charactersIgnoringModifiers == UIKeyCommand.inputLeftArrow {
                game.swipe(ID: 1)
                didHandleEvent = true
            }
            if key.charactersIgnoringModifiers == UIKeyCommand.inputRightArrow {
                game.swipe(ID: 3)
                didHandleEvent = true
            }
            if key.charactersIgnoringModifiers == UIKeyCommand.inputUpArrow {
                game.swipe(ID: 2)
                didHandleEvent = true
            }
            if key.charactersIgnoringModifiers == UIKeyCommand.inputDownArrow {
                game.swipe(ID: 4)
                didHandleEvent = true
            }
        }
        
        if didHandleEvent == false {
            super.pressesBegan(presses, with: event)
        }
    }
    
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesBegan(presses, with: event)
    }
}
