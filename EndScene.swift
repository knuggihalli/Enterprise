//
//  EndScene.swift
//  Enterprise
//
//  Created by Kavun Nuggihalli on 5/16/15.
//  Copyright (c) 2015 ConsiderCode LLC. All rights reserved.
//

import Foundation
import SpriteKit

class EndScene : SKScene {
    
    var gamescene: GameScene!
    var creditscene: CreditScene!
    var background = SKSpriteNode(imageNamed: "mainBackground.png")
    
    //Score
    var scored = false
    var score: Int = UserDefaults.standard.value(forKey: "Score") as! Int
    var highscore: Int = UserDefaults.standard.value(forKey: "HighScore") as! Int
    var starscore: Int = UserDefaults.standard.value(forKey: "StarScore") as! Int
    
    var scoreLabel = SKLabelNode(fontNamed: "Arial-Bold")
    var highLabel = SKLabelNode(fontNamed: "Arial")
    var starLabel = SKLabelNode(fontNamed: "Arial")
    
    var start = SKSpriteNode(imageNamed: "play.png")
    var credits = SKSpriteNode(imageNamed: "credits.png")
    
    override func didMove(to view: SKView) {
        self.scene?.backgroundColor = UIColor.black
        
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
        
        credits.size.width = self.size.width/4
        credits.size.height = self.size.width/6
        credits.position = CGPoint(x: self.size.width/2, y: start.position.y-start.size.height-20)
        credits.name = "credits"
        addChild(credits)
        
        highLabel.text = "HS: \(highscore)pts"
        highLabel.fontSize = 18
        highLabel.fontColor = SKColor.lightGray
        highLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/8)
        self.addChild(highLabel)
        
        scoreLabel.text = ""
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = SKColor.lightGray
        scoreLabel.position = CGPoint(x: credits.position.x,y: credits.position.y-credits.size.height-20)
        self.addChild(scoreLabel)

        starLabel.text = "$\(starscore)"
        starLabel.fontSize = 20
        starLabel.fontColor = SKColor.lightGray
        starLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/6)
        self.addChild(starLabel)
        
        if(score > highscore){
            UserDefaults.standard.set(score, forKey:"HighScore")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    func touchesEnded(_ touches: Set<NSObject>, with event: UIEvent) {
        if let touch =  touches.first as? UITouch {
            let count = touch.tapCount
            let location = touch.location(in: self)
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            
            if(touchedNode.name == "start"){
                Restart()
            }
            if(touchedNode.name == "credits"){
                self.view?.presentScene(creditscene)
            }
            
        }
    }
    
    func Restart(){
        //present scene
        let reset_score = 0
        UserDefaults.standard.set(reset_score, forKey:"Score")
        UserDefaults.standard.synchronize()
        self.view?.presentScene(gamescene)
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        //println("x:\(player.position.x)")
        let score: Int = UserDefaults.standard.value(forKey: "Score") as! Int
        let highscore: Int = UserDefaults.standard.value(forKey: "HighScore") as! Int
        let starscore: Int = UserDefaults.standard.value(forKey: "StarScore") as! Int
        self.starLabel.text = "$\(starscore)"
        
        if(score > highscore){
            self.scoreLabel.text = "HighScore: \(score)"
            self.highLabel.text = " "
            UserDefaults.standard.set(score, forKey:"HighScore")
            UserDefaults.standard.synchronize()
            
            let reset = 0
            
            UserDefaults.standard.set(reset, forKey:"Score")
            UserDefaults.standard.synchronize()
            
            scored = true
            
        }else{
            if(scored == true){
                self.scoreLabel.text = "HighScore: \(highscore)"
            }else{
                self.scoreLabel.text = "Score: \(score)"
                self.highLabel.text = "HighScore: \(highscore)"
            }
        }
        
    }
    
}
