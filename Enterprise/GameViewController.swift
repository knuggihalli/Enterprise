//
//  GameViewController.swift
//  Nifty Ninja
//
//  Created by Kavun Nuggihalli on 3/7/15.
//  Copyright (c) 2015 ConsiderCode LLC. All rights reserved.
//

import UIKit
import SpriteKit



class GameViewController: UIViewController {
    
    var scene: StartScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configure The View
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = true
        
        //create and configure scene
        scene = StartScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill

        
        //present scene
        skView.presentScene(scene)
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
