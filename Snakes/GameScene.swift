//
//  GameScene.swift
//  Snakes
//
//  Created by mayank metha on 16/06/20.
//  Copyright © 2020 mayank metha. All rights reserved.
//

import SpriteKit
import GameplayKit

var game: GameManager!

class GameScene: SKScene {
    
    var gameLogo: SKLabelNode!
    var gameStart: Bool!
    var bestScore: SKLabelNode!
    var playButton: SKShapeNode!
    var stopButton: SKShapeNode!
    var currentScore: SKLabelNode!
    var playerPositions: [(Int, Int)] = []
    var gameBG: SKShapeNode!
    var gameArray: [(node: SKShapeNode, x: Int, y: Int)] = []
    var scorePos: CGPoint?
        
    override func didMove(to view: SKView) {
        
        initializeMenu()
        game = GameManager(scene: self)
        gameStart = false
        initializeGameView()
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeR))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeL))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeU))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeD))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc func swipeR() {
        game.swipe(ID: 3)
    }
    @objc func swipeL() {
        game.swipe(ID: 1)
    }
    @objc func swipeU() {
        game.swipe(ID: 2)
    }
    @objc func swipeD() {
        game.swipe(ID: 4)
    }
    
    override func update(_ currentTime: TimeInterval) {
        game.update(time: currentTime)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "play_button" {
                    startGame()
                }
                if node.name == "stop_button" {
                    stopGame()
                }
            }
        }
    }
    
    func stopGame() {
        if gameStart == true {
            stopButton.run(SKAction.scale(by: 0, duration: 0.3)) {
                self.stopButton.isHidden = true
            }
            game.stop()
        } else {
            return
        }
    }
    
    func startGame() {
        if gameStart == false {
            gameLogo.run(SKAction.move(by: CGVector(dx: -50, dy: 600), duration: 0.5)) {
                self.gameLogo.isHidden = true
            }
            playButton.run(SKAction.scale(by: 0, duration: 0.3)) {
                self.playButton.isHidden = true
                self.stopButton.isHidden = false
                self.stopButton.run(SKAction.scale(to: 1, duration: 0.3)) {
                }
            }
            let bottomCorner = CGPoint(x: 0, y: (frame.size.height / -2) + 20)
            bestScore.run(SKAction.move(to: bottomCorner, duration: 0.4)) {
                self.gameBG.setScale(0)
                self.currentScore.setScale(0)
                self.gameBG.isHidden = false
                self.currentScore.isHidden = false
                self.gameBG.run(SKAction.scale(to: 1, duration: 0.4))
                self.currentScore.run(SKAction.scale(to: 1, duration: 0.4))
                self.gameStart = true
                game.initGame()
            }
        } else {
            return
        }
    }
    
    private func initializeGameView() {
        currentScore = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        currentScore.zPosition = 1
        currentScore.position = CGPoint(x: 0, y: ((frame.size.height / -2) + 60))
        currentScore.fontSize = 40
        currentScore.isHidden = true
        currentScore.text = "Score: 0"
        currentScore.fontColor = SKColor.white
        self.addChild(currentScore)

        var cellWidth: CGFloat
        let aspectRatio = frame.size.height/frame.size.width
        if aspectRatio == 4/3 {
            if frame.size.height > frame.size.width {
                cellWidth = (frame.size.width - 450)/20
            } else {
                cellWidth = (frame.size.height - 450)/20
            }
        } else {
            if frame.size.height > frame.size.width {
                cellWidth = (frame.size.width - 200)/20
            } else {
                cellWidth = (frame.size.height - 200)/20
            }
        }
        let width = cellWidth * 20
        let height = cellWidth * 40
        let rect = CGRect(x: -width / 2, y: -height / 2, width: width, height: height)
        gameBG = SKShapeNode(rect: rect, cornerRadius: 0.02)
        gameBG.fillColor = SKColor.black
        gameBG.zPosition = 2
        gameBG.isHidden = true
        self.addChild(gameBG)
    
        createGameBoard(width: Int(width), height: Int(height))
    }
    
    private func createGameBoard(width: Int, height: Int) {
        var cellWidth: CGFloat
        let aspectRatio = frame.size.height/frame.size.width
        if aspectRatio == 4/3 {
            if frame.size.height > frame.size.width {
                cellWidth = (frame.size.width - 450)/20
            } else {
                cellWidth = (frame.size.height - 450)/20
            }
        } else {
            if frame.size.height > frame.size.width {
                cellWidth = (frame.size.width - 200)/20
            } else {
                cellWidth = (frame.size.height - 200)/20
            }
        }
        let numRows = 40
        let numCols = 20
        var x = CGFloat(width / -2) + (cellWidth / 2)
        var y = CGFloat(height / 2) - (cellWidth / 2)
        //loop through rows and columns, create cells
        for i in 0...numRows - 1 {
            for j in 0...numCols - 1 {
                let cellNode = SKShapeNode(rectOf: CGSize(width: cellWidth, height: cellWidth))
                if i == 0 || i == numRows - 1 {
                    cellNode.strokeColor = SKColor.red
                    cellNode.zPosition = 3
                } else if j == 0 || j == numCols - 1 {
                    cellNode.strokeColor = SKColor.red
                    cellNode.zPosition = 3
                } else {
                    cellNode.strokeColor = SKColor.lightGray
                    cellNode.zPosition = 2
                }
                cellNode.position = CGPoint(x: x, y: y)
                //add to array of cells -- then add to game board
                gameArray.append((node: cellNode, x: i, y: j))
                gameBG.addChild(cellNode)
                //iterate x
                x += cellWidth
            }
            //reset x, iterate y
            x = CGFloat(width / -2) + (cellWidth / 2)
            y -= cellWidth
        }
    }
    
    private func initializeMenu() {
        gameLogo = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        gameLogo.zPosition = 1
        gameLogo.position = CGPoint(x: 0,y: ((frame.size.height / 2) - 200))
        gameLogo.fontSize = 60
        gameLogo.text = "SNAKES"
        gameLogo.fontColor = SKColor.systemTeal
        self.addChild(gameLogo)
        
        bestScore = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        bestScore.zPosition = 1
        bestScore.position = CGPoint(x: 0, y: gameLogo.position.y - 50)
        bestScore.fontSize = 40
        bestScore.text = "Best Score: 0"
        bestScore.fontColor = SKColor.white
        self.addChild(bestScore)
        
        playButton = SKShapeNode()
        playButton.name = "play_button"
        playButton.zPosition = 1
        playButton.position = CGPoint(x: 0, y: (frame.size.height / -2) + 200)
        playButton.fillColor = SKColor.orange
        playButton.strokeColor = SKColor.orange
        let topCorner = CGPoint(x: -50, y: 50)
        let bottomCorner = CGPoint(x: -50, y: -50)
        let middle = CGPoint(x: 50, y: 0)
        let path = CGMutablePath()
        path.addLine(to: topCorner)
        path.addLines(between: [topCorner, bottomCorner, middle])
        playButton.path = path
        self.addChild(playButton)
        
        stopButton = SKShapeNode()
        stopButton.name = "stop_button"
        stopButton.zPosition = 1
        stopButton.position = CGPoint(x: 0, y: (frame.size.height / 2) - 75)
        stopButton.fillColor = SKColor.orange
        stopButton.strokeColor = SKColor.orange
        stopButton.isHidden = true
        stopButton.setScale(0)
        let topleftCorner = CGPoint(x: -25, y: 25)
        let bottomleftCorner = CGPoint(x: -25, y: -25)
        let toprightCorner = CGPoint(x: 25, y: 25)
        let bottomrightCorner = CGPoint(x: 25, y: -25)
        let pathstop = CGMutablePath()
        pathstop.addLine(to: topleftCorner)
        pathstop.addLines(between: [topleftCorner, bottomleftCorner, bottomrightCorner, toprightCorner])
        stopButton.path = pathstop
        self.addChild(stopButton)
    }
}
