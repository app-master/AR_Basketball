//
//  ViewController+SCNPhysicsContactDelegate.swift
//  DZ_Basketball
//
//  Created by user on 30/03/2019.
//  Copyright © 2019 Sergey Koshlakov. All rights reserved.
//

import ARKit

extension ViewController: SCNPhysicsContactDelegate {
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        if goal == BitMask.topPlane | BitMask.bottomPlane {
            return
        }
        
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        
        let tuple = (nodeA.name, nodeB.name)
        
        switch tuple {
        case ("ball", "topPlane"):
           goal = goal | BitMask.topPlane
        case ("ball", "bottomPlane"):
           goal = goal | BitMask.bottomPlane
        case ("topPlane", "ball"):
           goal = goal | BitMask.topPlane
        case ("bottomPlane", "ball"):
           goal = goal | BitMask.bottomPlane
        default:
            break
        }
        
        if goal == BitMask.topPlane | BitMask.bottomPlane {
            print("GOAL!!!!")
            
            score += 1
            
            DispatchQueue.main.async {
                self.scoreLabel.text = "Score: \(self.score)"
            }
            
            player?.stop()
            let path = Bundle.main.path(forResource: "score", ofType: "mp3")
            let url = URL(fileURLWithPath: path ?? "")

            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        
        
        
    }
    
}
