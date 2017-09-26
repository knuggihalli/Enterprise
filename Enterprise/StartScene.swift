//
//  EndScene.swift
//  Enterprise
//
//  Created by Kavun Nuggihalli on 5/16/15.
//  Copyright (c) 2015 ConsiderCode LLC. All rights reserved.
//

import Foundation
import SpriteKit
import Foundation
import AVFoundation

class StartScene : SKScene {
    
    var scoreLabel = SKLabelNode(fontNamed: "Arial-Bold")
    var highLabel = SKLabelNode(fontNamed: "Arial")
    var starLabel = SKLabelNode(fontNamed: "Arial-Bold")
    
    var background = SKSpriteNode(imageNamed: "mainBackground.png")
    var gamescene: GameScene!
    var shopscene: StoreScene!
    var creditscene: CreditScene!
    
    var start = SKSpriteNode(imageNamed: "play.png")
    var shop = SKSpriteNode(imageNamed: "shop.png")
    var credits = SKSpriteNode(imageNamed: "credits.png")
    
    override func didMove(to view: SKView) {
        //add background
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = -10
        self.addChild(background)
        
        
        //Get scene ready
        gamescene = GameScene(size: self.frame.size)
        gamescene.scaleMode = .aspectFill
        creditscene = CreditScene(size: self.frame.size)
        creditscene.scaleMode = .aspectFill
        
        //Get menu ready
        
        start.size.width = self.size.width/4
        start.size.height = self.size.width/6
        start.position = CGPoint(x: self.size.width/2, y: self.size.height/2+50)
        start.name = "start"
        addChild(start)
        
        let act1 = SKAction.scale(to: 1.05, duration: 0.8)
        let act2 = SKAction.scale(to: 1.0, duration: 0.8)
        start.run(SKAction.repeatForever(SKAction.sequence([act1,act2])))
        
        shop.size.width = self.size.width/4
        shop.size.height = self.size.width/6
        shop.position = CGPoint(x: self.size.width/2, y: start.position.y-start.size.height-20)
        shop.name = "shop"
        addChild(shop)

        credits.size.width = self.size.width/4
        credits.size.height = self.size.width/6
        credits.position = CGPoint(x: self.size.width/2, y: start.position.y-start.size.height*2-40)
        credits.name = "credits"
        addChild(credits)
        
        //Set user defaults
        var score = 0
        UserDefaults.standard.set(score, forKey:"Score")
        UserDefaults.standard.synchronize()
        
        
        let firstLaunch = UserDefaults.standard.bool(forKey: "FirstLaunch")
        if firstLaunch  {
            //This is after the second launch
            var highscore: Int = UserDefaults.standard.value(forKey: "HighScore") as! Int
            var starscore: Int = UserDefaults.standard.value(forKey: "StarScore") as! Int
            //and highscore
            highLabel.text = "HS: \(highscore)pts"
            highLabel.fontSize = 18
            highLabel.fontColor = SKColor.lightGray
            highLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/8)
            self.addChild(highLabel)
            
            scoreLabel.text = ""
            scoreLabel.fontSize = 16
            scoreLabel.fontColor = SKColor.darkGray
            scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/8)
            self.addChild(scoreLabel)
            
            starLabel.text = "$\(starscore)"
            starLabel.fontSize = 20
            starLabel.fontColor = SKColor.lightGray
            starLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/6)
            self.addChild(starLabel)
           
        }
        else {
            //Put default stuff here
            
            UserDefaults.standard.set(true, forKey: "FirstLaunch")
            var score = 0
            UserDefaults.standard.set(score, forKey:"HighScore")
            UserDefaults.standard.synchronize()
            var star_count = 0
            UserDefaults.standard.set(star_count, forKey:"StarScore")
            UserDefaults.standard.synchronize()
            
            //All The enemies
            UserDefaults.standard.set(score, forKey:"Tutorial")
            UserDefaults.standard.synchronize()
            
        }
      

    }
    
    //touch functions
    func touchesEnded(_ touches: Set<NSObject>, with event: UIEvent) {
        if let touch =  touches.first as? UITouch {
            let count = touch.tapCount
            let location = touch.location(in: self)
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            
            if(touchedNode.name == "start"){
                Start()
            }
            if(touchedNode.name == "shop"){
                Shop()
            }
            if(touchedNode.name == "credits"){
                let trans = SKTransition.flipVertical(withDuration: 1.0)
                self.view?.presentScene(creditscene, transition:trans)
            }

        }
    }
    
    func Start(){
        //present scene
        let trans = SKTransition.flipVertical(withDuration: 1.0)
        self.view?.presentScene(gamescene, transition:trans)
    }
    func Shop(){
        //present scene
        let trans = SKTransition.flipVertical(withDuration: 1.0)
        self.view?.presentScene(shopscene, transition:trans)
    }
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        //println("x:\(player.position.x)")

        
        let highscore: Int = UserDefaults.standard.value(forKey: "HighScore") as! Int
        self.highLabel.text = "HS: \(highscore)pts"
        
        self.scoreLabel.color = SKColor.darkGray
        self.highLabel.color = SKColor.black
    }
    
}
