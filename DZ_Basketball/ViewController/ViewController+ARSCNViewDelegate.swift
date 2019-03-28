//
//  ViewController+ARSCNViewDelegate.swift
//  DZ_Basketball
//
//  Created by user on 28/03/2019.
//  Copyright © 2019 Sergey Koshlakov. All rights reserved.
//

import ARKit

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if let anchor = anchor as? ARPlaneAnchor {
            
            var existHoop = false
            
            sceneView.scene.rootNode.enumerateChildNodes { node, _ in
                if node.name == "hoop" {
                    existHoop = true
                }
            }
            
            if (!existHoop) {
                node.addChildNode(Plane(anchor: anchor))
            }
            
        }
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        if let anchor = anchor as? ARPlaneAnchor {
            guard let plane  = node.childNodes.first as? Plane else { return }
            plane.update(for: anchor)
        }
        
    }
    
}
