//
//  GameScene.swift
//  SpriteKitTowers
//
//  Created by Becca Gottlieb on 10/12/20.
//  Copyright © 2020 Becca Gottlieb. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene
{
    private var label : SKLabelNode?
    
    var buttons : [SKSpriteNode] = []
    var cupsArray : [SKSpriteNode] = []
    var towers : [[Int]] = [[2,1,0],[],[]]
    var floater : Int? = nil
    var previousTower = 0
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 0, y:0)
        background.zPosition = -1
        addChild(background)
        
        for i in 0 ... 2
        {
            buttons.append( SKSpriteNode(imageNamed:"button\(i)"))
            buttons[i].position = CGPoint(x:-200 + i * 200, y: -175)
            buttons[i].setScale( i == 1 ? 0.25 : 0.10)
            self.addChild(buttons[i])
        }
        
        func cups(_ i: Int,_ x: Int,_ y: Int)
        {
            let cup = (SKSpriteNode(imageNamed: "teaCup\(i)"))
            cup.setScale([0.12, 0.08, 0.10][i])
            cup.position = CGPoint(x: x, y: y)
            cup.zPosition = CGFloat(i)
            self.addChild(cup)
            
            cupsArray.append(cup)
        }
        
        for whichTowerAmI in 0...2
        {
            let xpos = -200 + whichTowerAmI * 200
            for cup in towers[whichTowerAmI]
            {
                let height = -60 + cup * 55
                cups(cup, Int(xpos), Int(height))
            }
        }
    }
    
    func lift(_ cup:Int, _ tower: Int)
    {
        let position = towers[tower].endIndex
        let height = 60 + (position+1) * 40
        cupsArray[cup].run(SKAction.moveTo(y: CGFloat(height), duration: 2))
    }
    
    func over(_ cup:Int, _ tower: Int)
    {
        let xpos = -200 + tower * 200
        cupsArray[cup].run(SKAction.moveTo(x: CGFloat(xpos), duration: 2), completion: {self.down(cup, tower)})
    }
    
    func down(_ cup:Int, _ tower: Int)
    {
        let position = towers[tower].endIndex
        let height = -60 + (position-1) * 55
        cupsArray[cup].run(SKAction.moveTo(y: CGFloat(height), duration: 2))
    }
    
    var whichTower : Int = 0
    
    func activated(_ index: Int)
    {
        whichTower = index
        if let cup = floater
        {
            if let top = towers[whichTower].last
            {
                print("the disc must be smaller that the one below.")
                guard cup < top else { return }
            }
            towers[whichTower].append(cup)
            over(cup, index)
            floater = nil
            if towers[whichTower].count == 3
            {popUp()}
        }
        else
        {
            floater = towers[whichTower].popLast()
            if floater != nil
            {
                lift(floater!, index)
                previousTower = whichTower
            }
        }
    }
    
    func popUp()
    {
        let popUp = SKSpriteNode(imageNamed: "youWin")
        popUp.position = CGPoint(x: 0, y: 0)
        popUp.setScale(0.5)
        popUp.zPosition = 10
        addChild(popUp)
        popUp.run(SKAction.repeat(SKAction.fadeOut(withDuration: 5), count: 1))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch: AnyObject in touches
        {
            for button in buttons
            {
                let index = buttons.firstIndex(of: button)!
                let location = touch.location(in: self)
                if button.contains(location)
                {
                    button.run(SKAction.repeat(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1), count: 2))
                    activated(index)
                }
            }
        }
    }
}
