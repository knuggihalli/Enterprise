//
//  GameScene.swift
//  Enterprise
//
//  Created by Kavun Nuggihalli on 5/16/15.
//  Copyright (c) 2015 ConsiderCode LLC. All rights reserved.
//

import SpriteKit
import Foundation
import AVFoundation
import CoreMotion

//Physics catagories
struct physicsCat {
    static let enemy : UInt32 = 1
    static let bullet : UInt32 = 2
    static let player : UInt32 = 3
    static let rock : UInt32 = 4
    static let pack : UInt32 = 5
    static let star : UInt32 = 6
    static let bar : UInt32 = 7
}

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    //Character Variables
    var player = SKSpriteNode(imageNamed: "enterprise.png")
    var fire_emiter = SKEmitterNode(fileNamed: "FireParticle")
    var shield = SKSpriteNode(imageNamed: "shield1.png")
    
    //Score variables
    var score = Int()
    var starscore = Int(0)
    var scoreLabel = SKLabelNode(fontNamed: "Arial")
    var healthLabel = SKLabelNode(fontNamed: "Arial")
    var starLabel = SKLabelNode(fontNamed: "Arial")
    let total_health = 10
    var health = Int()
    var health_bar = SKSpriteNode(imageNamed: "hbar.png")
    var health_size = SKSpriteNode(imageNamed: "health.png")
    var health_width = CGFloat(0)
    var starAmount = SKSpriteNode(imageNamed: "money.png")
    
    //hit amounts
    var amount = 0
    var gamount = 0
    var ramount = 0
    var bamount = 0
    var r2amount = 0
    var rock_amount = 0
    
    //Music and Sounds
    var laserSound = SKAction.playSoundFileNamed("laser.wav", waitForCompletion: false)
    var bangSound = SKAction.playSoundFileNamed("bang.wav", waitForCompletion: false)
    var rockSound = SKAction.playSoundFileNamed("rock_hit.aiff", waitForCompletion: true)
    var popSound = SKAction.playSoundFileNamed("pop.wav", waitForCompletion: false)
    var powerupSound = SKAction.playSoundFileNamed("powerup.wav", waitForCompletion: false)
    var hurtSound = SKAction.playSoundFileNamed("hurt.wav", waitForCompletion: false)
    var gameEndSound = SKAction.playSoundFileNamed("gameend.wav", waitForCompletion: true)
    var moneySound = SKAction.playSoundFileNamed("coinsound.wav", waitForCompletion: false)
    
    //Background Defaults
    var back = SKSpriteNode(imageNamed: "blue.png")
    var bar = SKSpriteNode(imageNamed: "bar.png")
    
    
    //End Scene Controls
    var endscene: EndScene!
    
    override func didMove(to view: SKView) {
        
        //World Properties
        back.size.width = self.size.width
        back.size.height = self.size.height*2
        back.anchorPoint = CGPoint.zero
        back.position = CGPoint(x: 0, y: 0)
        back.zPosition = -20
        let action = SKAction.moveTo(y: -self.size.height, duration: 2.0)
        let actionDone = SKAction.removeFromParent()
        back.run(SKAction.sequence([action, actionDone]))
        self.addChild(back)
        
        self.scene?.backgroundColor = UIColor.black
        physicsWorld.contactDelegate = self
        health = 0
        score = 0
        
        //Add star amount
        starAmount.size.width = self.frame.size.width/3
        starAmount.size.height = self.frame.size.width/6.5
        starAmount.anchorPoint = CGPoint.zero
        starAmount.position = CGPoint(x: self.frame.size.width-starAmount.size.width-2, y: self.frame.size.height-starAmount.size.height-2)
        starAmount.zPosition = 10
        addChild(starAmount)
        
        //Add health bar
        health_size.size.width = self.size.width/2-5
        health_size.size.height = self.size.height/26.5
        health_size.anchorPoint = CGPoint.zero
        health_size.position = CGPoint(x: 5, y: self.size.height-health_bar.size.height+health_size.size.height+2)
        health_size.zPosition = 9
        health_width = health_size.size.width
        addChild(health_size)
        
        health_bar.size.width = self.size.width/2
        health_bar.size.height = self.size.height/12
        health_bar.anchorPoint = CGPoint.zero
        health_bar.position = CGPoint(x: 5, y: self.size.height-health_bar.size.height-5)
        health_bar.zPosition = 10
        addChild(health_bar)
        
        //add bar
        bar.size.width = self.size.width
        bar.anchorPoint = CGPoint.zero
        bar.position = CGPoint(x: 0, y: -bar.size.height)
        bar.zPosition = 9
        bar.size.height = self.size.height/10
        bar.physicsBody = SKPhysicsBody(rectangleOf: bar.size)
        bar.physicsBody?.affectedByGravity = false
        bar.physicsBody?.categoryBitMask = physicsCat.bar
        bar.physicsBody?.contactTestBitMask = physicsCat.enemy
        bar.physicsBody?.isDynamic = false
        addChild(bar)
        
        //add sheild
        shield.size.width = player.size.width+10
        shield.size.height = player.size.height+10
        shield.position = CGPoint(x: 0, y: self.frame.size.height/2)
        addChild(shield)
        
        
        //Initilize end scene
        endscene = EndScene(size: self.frame.size)
        endscene.scaleMode = .aspectFill
        
        //Player added to screen
        player.position = CGPoint(x: self.size.width/2, y: self.size.height/3)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = physicsCat.player
        player.physicsBody?.contactTestBitMask = physicsCat.enemy
        player.physicsBody?.isDynamic = false
        fire_emiter?.zPosition = -5;
        player.addChild(fire_emiter!)
        player.name = "player"
        player.setScale(0.6)
        self.addChild(player)
        
        
        //Spawn enemy and background
        var backgroundTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameScene.background), userInfo: nil, repeats: true)
        
        var enemyTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(GameScene.spawnRomulan), userInfo: nil, repeats: true)
        var enemyTimer2 = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(GameScene.spawnRomulan2), userInfo: nil, repeats: true)
        var enemyTimer3 = Timer.scheduledTimer(timeInterval: 6.0, target: self, selector: #selector(GameScene.spawnRomulan3), userInfo: nil, repeats: true)
        var enemyTimer4 = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(GameScene.spawnRomulan4), userInfo: nil, repeats: true)
        var enemyTimer5 = Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(GameScene.spawnRomulan5), userInfo: nil, repeats: true)

        var rockTimer = Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(GameScene.spawnRock), userInfo: nil, repeats: true)
        var healthTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(GameScene.spawnHealth), userInfo: nil, repeats: true)
        
        var StarTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(GameScene.spawnStar), userInfo: nil, repeats: true)
        
        var bulletTimer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(GameScene.spawnBullet), userInfo: nil, repeats: true)
        
        
        //Adding the score to screen
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 14
        scoreLabel.position = CGPoint(x: health_bar.position.x+scoreLabel.frame.size.width/2+10, y: health_bar.position.y+scoreLabel.frame.size.height/2+5)
        scoreLabel.zPosition = 12
        self.addChild(scoreLabel)
        
        starLabel.text = "\(starscore)"
        starLabel.fontSize = 16
        starLabel.position = CGPoint(x: starAmount.position.x+starAmount.size.width/2, y: starAmount.position.y+starAmount.size.height/3)
        starLabel.fontColor = SKColor.black
        starLabel.zPosition = 12
        self.addChild(starLabel)
        
        //Add health to screen
        healthLabel.text = "Health: \(total_health)x"
        //self.view?.addSubview(healthLabel)
        
       
    }
    
    //Colision Dectection
    func didBegin(_ contact: SKPhysicsContact) {
        let firstbody : SKPhysicsBody = contact.bodyA
        let secondbody : SKPhysicsBody = contact.bodyB
        
        //Bullet and Enemy
        if ((firstbody.categoryBitMask == physicsCat.enemy) && (secondbody.categoryBitMask == physicsCat.bullet)){
            collideBullet(firstbody.node as! SKSpriteNode, Bullet: secondbody.node as! SKSpriteNode)
        }
        else if ((firstbody.categoryBitMask == physicsCat.bullet) && (secondbody.categoryBitMask == physicsCat.enemy)){
            collideBullet(secondbody.node as! SKSpriteNode, Bullet: firstbody.node as! SKSpriteNode)
        }
            
        //Anything and Bar
        else if (firstbody.categoryBitMask == physicsCat.bar) && (secondbody.categoryBitMask == physicsCat.enemy){
            collideBar(secondbody.node as! SKSpriteNode, Bar: firstbody.node as! SKSpriteNode)
        }
        else if(firstbody.categoryBitMask == physicsCat.enemy) && (secondbody.categoryBitMask == physicsCat.bar){
            collideBar(firstbody.node as! SKSpriteNode, Bar: secondbody.node as! SKSpriteNode)
        }
            
        //Player and Enemy Collide
        else if ((firstbody.categoryBitMask == physicsCat.player) && (secondbody.categoryBitMask == physicsCat.enemy)){
            collidePlayer(secondbody.node as! SKSpriteNode, Player: firstbody.node as! SKSpriteNode)
        }
        else if(firstbody.categoryBitMask == physicsCat.enemy) && (secondbody.categoryBitMask == physicsCat.player){
            collidePlayer(firstbody.node as! SKSpriteNode, Player: secondbody.node as! SKSpriteNode)
        }
            
        //Player and Rock Collide
        else if (firstbody.categoryBitMask == physicsCat.player) && (secondbody.categoryBitMask == physicsCat.rock){
            collideRock(secondbody.node as! SKSpriteNode, Player: firstbody.node as! SKSpriteNode)
        }
        else if(firstbody.categoryBitMask == physicsCat.rock) && (secondbody.categoryBitMask == physicsCat.player){
            collideRock(firstbody.node as! SKSpriteNode, Player: secondbody.node as! SKSpriteNode)
        }
        
        //Player and Health Collide
        else if (firstbody.categoryBitMask == physicsCat.player) && (secondbody.categoryBitMask == physicsCat.pack){
            collideHealth(secondbody.node as! SKSpriteNode, Player: firstbody.node as! SKSpriteNode)
        }
        else if(firstbody.categoryBitMask == physicsCat.pack) && (secondbody.categoryBitMask == physicsCat.player){
            collideHealth(firstbody.node as! SKSpriteNode, Player: secondbody.node as! SKSpriteNode)
        }
        
        //Player and Star Collide
        else if (firstbody.categoryBitMask == physicsCat.player) && (secondbody.categoryBitMask == physicsCat.star){
            collideStar(secondbody.node as! SKSpriteNode, Player: firstbody.node as! SKSpriteNode)
        }
        else if(firstbody.categoryBitMask == physicsCat.star) && (secondbody.categoryBitMask == physicsCat.player){
            collideStar(firstbody.node as! SKSpriteNode, Player: secondbody.node as! SKSpriteNode)
        }
        
        //Bullet and Rock Collide
        else if (firstbody.categoryBitMask == physicsCat.bullet) && (secondbody.categoryBitMask == physicsCat.rock){
            collideBulletRock(secondbody.node as! SKSpriteNode, Bullet: firstbody.node as! SKSpriteNode)
        }
        else if(firstbody.categoryBitMask == physicsCat.rock) && (secondbody.categoryBitMask == physicsCat.bullet){
            collideBulletRock(firstbody.node as! SKSpriteNode, Bullet: secondbody.node as! SKSpriteNode)
        }
    }
    func collideBullet(_ Enemy: SKSpriteNode, Bullet: SKSpriteNode){
        
        Enemy.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        Enemy.physicsBody?.collisionBitMask = 0x0
        Bullet.removeFromParent()
        
        if(Enemy.name == "enemy"){
            if(amount >= 3){
                amount = 0
                Enemy.removeFromParent()
                Bullet.removeFromParent()
                score += 1
                scoreLabel.text = "Score: \(score)"
                self.run(bangSound)
            }else{
                amount += 1
                self.run(popSound)
            }
        }else if(Enemy.name == "genemy"){
            if(gamount >= 6){
                gamount = 0
                Enemy.removeFromParent()
                Bullet.removeFromParent()
                score += 1
                scoreLabel.text = "Score: \(score)"
                self.run(bangSound)
            }else{
                gamount += 1
                self.run(popSound)
            }
        }else if(Enemy.name == "renemy"){
            if(ramount >= 10){
                ramount = 0
                Enemy.removeFromParent()
                Bullet.removeFromParent()
                score += 1
                scoreLabel.text = "Score: \(score)"
                self.run(bangSound)
            }else{
                ramount += 1
                self.run(popSound)
            }
        }
        else if(Enemy.name == "benemy"){
            if(bamount >= 4){
                bamount = 0
                Enemy.removeFromParent()
                Bullet.removeFromParent()
                score += 1
                scoreLabel.text = "Score: \(score)"
                self.run(bangSound)
            }else{
                bamount += 1
                self.run(popSound)
            }
        }
        else if(Enemy.name == "r2enemy"){
            if(r2amount >= 15){
                r2amount = 0
                Enemy.removeFromParent()
                Bullet.removeFromParent()
                score += 1
                scoreLabel.text = "Score: \(score)"
                self.run(bangSound)
            }else{
                r2amount += 1
                self.run(popSound)
            }
        }
        
    }
    func collideBulletRock(_ Rock: SKSpriteNode, Bullet: SKSpriteNode){
        if(rock_amount >= 3){
            self.run(bangSound)
            Rock.removeFromParent()
            Bullet.removeFromParent()
            rock_amount = 0
        }else{
            rock_amount += 1
            self.run(popSound)
        }
        
    }
    func collidePlayer(_ Enemy: SKSpriteNode, Player: SKSpriteNode){
        Enemy.removeFromParent()
        health += 1
        let health_score = total_health - health
        healthLabel.text = "Health: \(health_score)x"
        self.run(hurtSound)
        health_size.size.width = health_width * CGFloat(health_score)/10
        //Player.removeFromParent()
        //self.view?.presentScene(EndScene())
        //scoreLabel.removeFromSuperview()
    }
    func collideRock(_ Rock: SKSpriteNode, Player: SKSpriteNode){
        self.run(bangSound)
        Rock.removeFromParent()
        health += 1
        let health_score = total_health - health
        healthLabel.text = "Health: \(health_score)x"
        self.run(hurtSound)
        health_size.size.width = health_width * CGFloat(health_score)/10
        //Player.removeFromParent()
        //self.view?.presentScene(EndScene())
        //scoreLabel.removeFromSuperview()
    }
    func collideHealth(_ Pack: SKSpriteNode, Player: SKSpriteNode){
        Pack.removeFromParent()
        health -= 1
        let health_score = total_health - health
        healthLabel.text = "Health: \(health_score)x"
        self.run(powerupSound)
        health_size.size.width = health_width * CGFloat(health_score)/10
        //Player.removeFromParent()
        //self.view?.presentScene(EndScene())
        //scoreLabel.removeFromSuperview()
    }
    func collideStar(_ Star: SKSpriteNode, Player: SKSpriteNode){
        Star.removeFromParent()
        
        
        if(Star.name == "BronzeStar"){
            score = score+1
            starscore = starscore+1
            scoreLabel.text = "Score: \(score)"
            starLabel.text = "\(starscore)"
            self.run(moneySound)
        }
        else if(Star.name == "SilverStar"){
            score = score+2
            starscore = starscore+2
            scoreLabel.text = "Score: \(score)"
            starLabel.text = "\(starscore)"
            self.run(moneySound)
        }
        else if(Star.name == "GoldStar"){
            score = score+4
            starscore = starscore+3
            scoreLabel.text = "Score: \(score)"
            starLabel.text = "\(starscore)"
            self.run(moneySound)
        }
        //Player.removeFromParent()
        //self.view?.presentScene(EndScene())
        //scoreLabel.removeFromSuperview()
    }
    func collideBar(_ Enemy: SKSpriteNode, Bar: SKSpriteNode){
        health += 1
        let health_score = total_health - health
        healthLabel.text = "Health: \(health_score)x"
        self.run(hurtSound)
        health_size.size.width = health_width * CGFloat(health_score)/10
        //Player.removeFromParent()
        //self.view?.presentScene(EndScene())
        //scoreLabel.removeFromSuperview()
    }
    
    //Background generation function
    func background(){
        let background = SKSpriteNode(imageNamed: "blue.png")
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint(x: 0, y: self.size.height)
        background.zPosition = -10;
        background.size.width = self.size.width
        background.size.height = self.size.height
        let action = SKAction.moveTo(y: -self.size.height*2, duration: 4.0)
        let actionDone = SKAction.removeFromParent()
        background.run(SKAction.sequence([action, actionDone]))
        self.addChild(background)
    }
    
    //Spawn Functions
    func spawnBullet(){
        let bullet = SKSpriteNode(imageNamed: "laser.png")
        bullet.zPosition = -5
        bullet.position = CGPoint(x: player.position.x, y: player.position.y)
        //let action = SKAction.moveToY(self.size.height+30, duration: 1.0)
        //let actionDone = SKAction.removeFromParent()
        //bullet.runAction(SKAction.sequence([action, actionDone]))
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.categoryBitMask = physicsCat.bullet
        bullet.physicsBody?.contactTestBitMask = physicsCat.enemy
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.isDynamic = false
        let daction = SKAction.moveTo(y: self.size.height, duration: 0.6)
        let eaction = SKAction.removeFromParent()
        bullet.run(SKAction.sequence([daction, eaction]))
        bullet.setScale(0.7)
        //self.runAction(laserSound)
        self.addChild(bullet)
    }
    func spawnRomulan(){
        let enemy = SKSpriteNode(imageNamed: "enemyBlue1.png")
        let min = self.frame.origin.x + (enemy.size.width-10)
        let max = self.size.width - (enemy.size.width-10)
        let dif = randomInRange(Int(min), hi :Int(max))
        enemy.position = CGPoint(x: CGFloat(dif), y: self.size.height)
        let dur = TimeInterval(randomInRange(4, hi :5))
        let action = SKAction.moveTo(y: -70, duration: dur)
        let actionDone = SKAction.removeFromParent()
        enemy.run(SKAction.sequence([action, actionDone]))
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.categoryBitMask = physicsCat.enemy
        enemy.physicsBody?.contactTestBitMask = physicsCat.bullet
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.isDynamic = true
        enemy.name = "enemy"
        enemy.setScale(0.6)
        enemy.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        enemy.physicsBody?.collisionBitMask = 0x0
        self.addChild(enemy)
        
    }
    func spawnRomulan2(){
    
        let genemy = SKSpriteNode(imageNamed: "enemyGreen4.png")
        let min = self.frame.origin.x + (genemy.size.width-10)
        let max = self.size.width - (genemy.size.width-10)
        let dif = randomInRange(Int(min), hi :Int(max))
        genemy.position = CGPoint(x: CGFloat(dif), y: self.size.height)
        let gdur = TimeInterval(randomInRange(6, hi :8))
        let gaction = SKAction.moveTo(y: -70, duration: gdur)
        let gactionDone = SKAction.removeFromParent()
        
        let dif_space = randomInRange(0, hi: Int(self.size.width))
        let move1 = SKAction.moveTo(x: CGFloat(dif_space), duration: 4.0)
        let move2 = SKAction.moveTo(x: CGFloat(dif), duration: 3.0)
        genemy.run(SKAction.repeatForever(SKAction.sequence([move1,move2])))
        
        
        genemy.run(SKAction.sequence([gaction, gactionDone]))
        genemy.physicsBody = SKPhysicsBody(rectangleOf: genemy.size)
        genemy.physicsBody?.categoryBitMask = physicsCat.enemy
        genemy.physicsBody?.contactTestBitMask = physicsCat.bullet
        genemy.physicsBody?.affectedByGravity = false
        genemy.physicsBody?.isDynamic = true
        genemy.name = "genemy"
        genemy.setScale(0.6)
        genemy.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        genemy.physicsBody?.collisionBitMask = 0x0
        if(score > 10){
            self.addChild(genemy)
        }

    }
    func spawnRomulan3(){
        let renemy = SKSpriteNode(imageNamed: "enemyRed3.png")
        let min = self.frame.origin.x + (renemy.size.width-10)
        let max = self.size.width - (renemy.size.width-10)
        let dif = randomInRange(Int(min), hi :Int(max))
        renemy.position = CGPoint(x: CGFloat(dif), y: self.size.height)
        let rdur = TimeInterval(randomInRange(15, hi :20))
        let raction = SKAction.moveTo(y: -70, duration: rdur)
        let ractionDone = SKAction.removeFromParent()
        renemy.run(SKAction.sequence([raction, ractionDone]))
        renemy.physicsBody = SKPhysicsBody(rectangleOf: renemy.size)
        renemy.physicsBody?.categoryBitMask = physicsCat.enemy
        renemy.physicsBody?.contactTestBitMask = physicsCat.bullet
        renemy.physicsBody?.affectedByGravity = false
        renemy.physicsBody?.isDynamic = true
        renemy.name = "renemy"
        renemy.setScale(0.6)
        renemy.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        renemy.physicsBody?.collisionBitMask = 0x0
        if(score > 25){
            self.addChild(renemy)
        }
    }
    func spawnRomulan4(){
        let benemy = SKSpriteNode(imageNamed: "enemyBlack2.png")
        let min = self.frame.origin.x + (benemy.size.width-10)
        let max = self.size.width - (benemy.size.width-10)
        let dif = randomInRange(Int(min), hi :Int(max))
        benemy.position = CGPoint(x: CGFloat(dif), y: self.size.height)
        let bdur = TimeInterval(randomInRange(2, hi :3))
        let baction = SKAction.moveTo(y: -70, duration: bdur)
        let bactionDone = SKAction.removeFromParent()
        benemy.run(SKAction.sequence([baction, bactionDone]))
        benemy.physicsBody = SKPhysicsBody(rectangleOf: benemy.size)
        benemy.physicsBody?.categoryBitMask = physicsCat.enemy
        benemy.physicsBody?.contactTestBitMask = physicsCat.bullet
        benemy.physicsBody?.affectedByGravity = false
        benemy.physicsBody?.isDynamic = true
        benemy.name = "benemy"
        benemy.setScale(0.6)
        benemy.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        benemy.physicsBody?.collisionBitMask = 0x0
        if(score > 45){
            self.addChild(benemy)
        }
    }
    func spawnRomulan5(){
        let benemy = SKSpriteNode(imageNamed: "enemyRed5.png")
        let min = self.frame.origin.x + (benemy.size.width-10)
        let max = self.size.width - (benemy.size.width-10)
        let dif = randomInRange(Int(min), hi :Int(max))
        benemy.position = CGPoint(x: CGFloat(dif), y: self.size.height)
        let bdur = TimeInterval(randomInRange(22, hi :28))
        let baction = SKAction.moveTo(y: -70, duration: bdur)
        let bactionDone = SKAction.removeFromParent()
        
        let dif_space = randomInRange(0, hi: Int(self.size.width))
        let move1 = SKAction.moveTo(x: CGFloat(dif_space), duration: 6.0)
        let move2 = SKAction.moveTo(x: CGFloat(dif), duration: 7.0)
        benemy.run(SKAction.repeatForever(SKAction.sequence([move1,move2])))
        
        benemy.run(SKAction.sequence([baction, bactionDone]))
        benemy.physicsBody = SKPhysicsBody(rectangleOf: benemy.size)
        benemy.physicsBody?.categoryBitMask = physicsCat.enemy
        benemy.physicsBody?.contactTestBitMask = physicsCat.bullet
        benemy.physicsBody?.affectedByGravity = false
        benemy.physicsBody?.isDynamic = true
        benemy.name = "r2enemy"
        benemy.setScale(0.6)
        benemy.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        benemy.physicsBody?.collisionBitMask = 0x0
        if(score > 80){
            self.addChild(benemy)
        }
    }
    func spawnRock(){
        let rock = SKSpriteNode(imageNamed: "meteorBrown_big3.png")
        let min = self.frame.origin.x + (rock.size.width-10)
        let max = self.size.width - (rock.size.width-10)
        let dif = randomInRange(Int(min), hi :Int(max))
        rock.position = CGPoint(x: CGFloat(dif), y: self.size.height)
        let dur = TimeInterval(randomInRange(4, hi :5))
        let action = SKAction.moveTo(y: -70, duration: dur)
        let actionDone = SKAction.removeFromParent()
        rock.run(SKAction.sequence([action, actionDone]))
        rock.physicsBody = SKPhysicsBody(rectangleOf: rock.size)
        rock.physicsBody?.categoryBitMask = physicsCat.rock
        rock.physicsBody?.contactTestBitMask = physicsCat.player
        rock.physicsBody?.affectedByGravity = false
        rock.physicsBody?.isDynamic = true
        rock.name = "rock"
        rock.setScale(0.65)
        if(score <= 10){
            self.addChild(rock)
        }
        
        
        let grock = SKSpriteNode(imageNamed: "meteorGrey_big3.png")
        grock.position = CGPoint(x: CGFloat(dif), y: self.size.height)
        let gdur = TimeInterval(randomInRange(3, hi :4))
        let gaction = SKAction.moveTo(y: -70, duration: gdur)
        let gactionDone = SKAction.removeFromParent()
        grock.run(SKAction.sequence([gaction, gactionDone]))
        grock.physicsBody = SKPhysicsBody(rectangleOf: rock.size)
        grock.physicsBody?.categoryBitMask = physicsCat.rock
        grock.physicsBody?.contactTestBitMask = physicsCat.player
        grock.physicsBody?.affectedByGravity = false
        grock.physicsBody?.isDynamic = true
        grock.name = "grock"
        grock.setScale(0.65)
        if(score > 10 && score < 25){
            self.addChild(grock)
        }
        
        let ggrock = SKSpriteNode(imageNamed: "meteorGrey_big3.png")
        ggrock.position = CGPoint(x: CGFloat(dif), y: self.size.height)
        let ggdur = TimeInterval(randomInRange(1, hi :2))
        let ggaction = SKAction.moveTo(y: -70, duration: ggdur)
        let ggactionDone = SKAction.removeFromParent()
        ggrock.run(SKAction.sequence([ggaction, ggactionDone]))
        ggrock.physicsBody = SKPhysicsBody(rectangleOf: rock.size)
        ggrock.physicsBody?.categoryBitMask = physicsCat.rock
        ggrock.physicsBody?.contactTestBitMask = physicsCat.player
        ggrock.physicsBody?.affectedByGravity = false
        ggrock.physicsBody?.isDynamic = true
        ggrock.name = "ggrock"
        ggrock.setScale(0.65)
        if(score > 25){
            self.addChild(ggrock)
        }
        

    }
    func spawnHealth(){
        let pack = SKSpriteNode(imageNamed: "powerupRed_bolt.png")
        let min = self.frame.origin.x + (pack.size.width-10)
        let max = self.size.width - (pack.size.width-10)
        let dif = randomInRange(Int(min), hi :Int(max))
        pack.position = CGPoint(x: CGFloat(dif), y: self.size.height)
        let dur = TimeInterval(randomInRange(3, hi :4))
        let action = SKAction.moveTo(y: -70, duration: dur)
        let actionDone = SKAction.removeFromParent()
        pack.run(SKAction.sequence([action, actionDone]))
        pack.physicsBody = SKPhysicsBody(rectangleOf: pack.size)
        pack.physicsBody?.categoryBitMask = physicsCat.pack
        pack.physicsBody?.contactTestBitMask = physicsCat.player
        pack.physicsBody?.affectedByGravity = false
        pack.physicsBody?.isDynamic = true
        pack.name = "pack"
        pack.setScale(0.8)
        pack.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        pack.physicsBody?.collisionBitMask = 0x0
        if(health >= 7){
         self.addChild(pack)
         self.run(popSound)
        }
    }
    func spawnStar(){
        let star = SKSpriteNode(imageNamed: "star_bronze.png")
        let min = self.frame.origin.x + (star.size.width-10)
        let max = self.size.width - (star.size.width-10)
        let dif = randomInRange(Int(min), hi :Int(max))
        star.position = CGPoint(x: CGFloat(dif), y: self.size.height)
        let dur = TimeInterval(randomInRange(4, hi :5))
        let action = SKAction.moveTo(y: -70, duration: dur)
        let actionDone = SKAction.removeFromParent()
        star.run(SKAction.sequence([action, actionDone]))
        star.physicsBody = SKPhysicsBody(rectangleOf: star.size)
        star.physicsBody?.categoryBitMask = physicsCat.star
        star.physicsBody?.contactTestBitMask = physicsCat.player
        star.physicsBody?.affectedByGravity = false
        star.physicsBody?.isDynamic = true
        star.name = "BronzeStar"
        star.setScale(0.8)
        star.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        star.physicsBody?.collisionBitMask = 0x0

        if(score <= 40){
            self.addChild(star)
        }
        
        let sstar = SKSpriteNode(imageNamed: "star_silver.png")
        var smin = self.frame.origin.x + (star.size.width-10)
        var smax = self.size.width - (star.size.width-10)
        var sdif = randomInRange(Int(min), hi :Int(max))
        sstar.position = CGPoint(x: CGFloat(dif), y: self.size.height)
        var sdur = TimeInterval(randomInRange(3, hi :4))
        let saction = SKAction.moveTo(y: -70, duration: dur)
        let sactionDone = SKAction.removeFromParent()
        sstar.run(SKAction.sequence([action, actionDone]))
        sstar.physicsBody = SKPhysicsBody(rectangleOf: star.size)
        sstar.physicsBody?.categoryBitMask = physicsCat.star
        sstar.physicsBody?.contactTestBitMask = physicsCat.player
        sstar.physicsBody?.affectedByGravity = false
        sstar.physicsBody?.isDynamic = true
        sstar.name = "SilverStar"
        sstar.setScale(0.8)
        sstar.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        sstar.physicsBody?.collisionBitMask = 0x0
        if(score > 40 && score < 120){
            self.addChild(sstar)
        }
        
        let gstar = SKSpriteNode(imageNamed: "star_gold.png")
        var gmin = self.frame.origin.x + (star.size.width-10)
        var gmax = self.size.width - (star.size.width-10)
        var gdif = randomInRange(Int(min), hi :Int(max))
        gstar.position = CGPoint(x: CGFloat(dif), y: self.size.height)
        var gdur = TimeInterval(randomInRange(1, hi :3))
        let gaction = SKAction.moveTo(y: -70, duration: dur)
        let gactionDone = SKAction.removeFromParent()
        gstar.run(SKAction.sequence([action, actionDone]))
        gstar.physicsBody = SKPhysicsBody(rectangleOf: star.size)
        gstar.physicsBody?.categoryBitMask = physicsCat.star
        gstar.physicsBody?.contactTestBitMask = physicsCat.player
        gstar.physicsBody?.affectedByGravity = false
        gstar.physicsBody?.isDynamic = true
        gstar.name = "GoldStar"
        gstar.setScale(0.8)
        gstar.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        gstar.physicsBody?.collisionBitMask = 0x0
        if(score > 120){
            self.addChild(gstar)
        }
    }
    
    //Logic functions
    func randomInRange(_ lo: Int, hi : Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
    
    
    //Touch Functions
    func touchesMoved(_ touches: Set<NSObject>, with event: UIEvent) {
        if let touch =  touches.first as? UITouch {
            let location = touch.location(in: self)
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            
            if(touchedNode.name == "player"){
                player.position.x = location.x
                player.position.y = location.y+20
            }
        }
    }
    
    func touchesBegan(_ touches: Set<NSObject>, with event: UIEvent) {
        if let touch =  touches.first as? UITouch {
            let location = touch.location(in: self)
            let count = touch.tapCount
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            
        }
    }
    
    func touchesEnded(_ touches: Set<NSObject>, with event: UIEvent) {
        if let touch =  touches.first as? UITouch {
           let count = touch.tapCount
        }
    }


    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        //println("test :\(destX)")
        //Call Scores and health
        scoreLabel.text = "Score: \(score)"
        //healthLabel.text = "Health: \(10-health)x"
        
        //println("score:\(score)")
        //println("health :\(10-health))")
        
        shield.position = player.position
        
        if (player.position.x > self.frame.size.width){
            let bringbackx = SKAction.move(to: CGPoint(x: self.frame.size.width-1, y: player.position.y), duration: 0)
            player.run(bringbackx)
        }
        if(player.position.x < 0 ){
            let bringbackx = SKAction.move(to: CGPoint(x: 1, y: player.position.y), duration: 0)
            player.run(bringbackx)
        }
        if(player.position.y >= self.frame.size.height){
            player.removeFromParent()
            health += 1
            let health_score = total_health - health
            healthLabel.text = "Health: \(health_score)x"
        }
        
        if(health >= 10){
            self.run(gameEndSound)
            let starScoreCurrent: Int = UserDefaults.standard.value(forKey: "StarScore") as! Int
            let SScore = starScoreCurrent + starscore
            UserDefaults.standard.set(score, forKey:"Score")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.set(SScore, forKey:"StarScore")
            UserDefaults.standard.synchronize()
            self.view?.presentScene(endscene)
        }
        
    }
}

