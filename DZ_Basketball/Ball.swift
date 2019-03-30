//
//  Ball.swift
//  DZ_Basketball
//
//  Created by user on 29/03/2019.
//  Copyright © 2019 Sergey Koshlakov. All rights reserved.
//

import ARKit

class Ball: SCNNode {
    
    init(transform: simd_float4x4, ballScale: SCNVector3) {
        super.init()
        
        let sphereGeometry = SCNSphere(radius: 0.20)
        sphereGeometry.firstMaterial?.diffuse.contents = UIImage(named: "ball.png")
        geometry = sphereGeometry
        simdTransform = transform
        scale = ballScale
        name = "ball"
        
        let phisicsShape = SCNPhysicsShape(geometry: sphereGeometry, options: [
            SCNPhysicsShape.Option.collisionMargin : 0.01
            ])
        physicsBody = SCNPhysicsBody(type: .dynamic, shape: phisicsShape)
        physicsBody?.categoryBitMask = BitMask.ball
        physicsBody?.collisionBitMask =  BitMask.hoop
        physicsBody?.contactTestBitMask = BitMask.topPlane | BitMask.bottomPlane 
        
        let userDefault = UserDefaults.standard
        userDefault.float(forKey: "Power")
        
        let power = userDefault.float(forKey: "Power")
        
        let direction = SCNVector3(x: -transform.columns.2.x * power, y: -transform.columns.2.y * power, z: -transform.columns.2.z * power)
        physicsBody?.applyForce(direction, asImpulse: true)
    }
    
    convenience init(transform: simd_float4x4) {
        self.init(transform: transform, ballScale: SCNVector3(0.5, 0.5, 0.5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
