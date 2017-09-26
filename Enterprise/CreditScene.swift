//
//  EndScene.swift
//  Enterprise
//
//  Created by Kavun Nuggihalli on 5/16/15.
//  Copyright (c) 2015 ConsiderCode LLC. All rights reserved.
//

import Foundation
import SpriteKit

class CreditScene : SKScene {
    
    var startscene: StartScene!
    var background = SKSpriteNode(imageNamed: "creditBackground.png")

    var scoreLabel = SKLabelNode(fontNamed: "Arial")

    
    override func didMove(to view: SKView) {
        self.scene?.backgroundColor = UIColor.black
        
        //add background
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = -10
        self.addChild(background)
        
        
        //Get scene ready
        startscene = StartScene(size: self.frame.size)
        startscene.scaleMode = .aspectFill
        
        
        
    }
    
    func touchesEnded(_ touches: Set<NSObject>, with event: UIEvent) {
        if let touch =  touches.first as? UITouch {
            let count = touch.tapCount
            let location = touch.location(in: self)
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            
            Restart()
            
        }
    }
    
    func Restart(){
        //present scene
        let trans = SKTransition.flipVertical(withDuration: 1.0)
        self.view?.presentScene(startscene, transition:trans)
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        //println("x:\(player.position.x)")
        
    }
    
}
