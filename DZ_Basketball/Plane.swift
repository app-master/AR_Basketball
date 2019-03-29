//
//  Plane.swift
//  DZ_Basketball
//
//  Created by user on 28/03/2019.
//  Copyright © 2019 Sergey Koshlakov. All rights reserved.
//

import ARKit

class Plane: SCNNode {
    
    var anchor: ARPlaneAnchor
    
    init(anchor: ARPlaneAnchor) {
        self.anchor = anchor
        super.init()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        let planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        planeGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        geometry = planeGeometry
        opacity = 0.25
        name = "plane"
        eulerAngles.x = -.pi / 2
        position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        
    }
    
    func update(for anchor: ARPlaneAnchor) {
        
        guard let plane = geometry as? SCNPlane else { return }
        
        self.anchor = anchor
        
        plane.width = CGFloat(anchor.extent.x)
        plane.height = CGFloat(anchor.extent.z)
        position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        
    }
    
}
