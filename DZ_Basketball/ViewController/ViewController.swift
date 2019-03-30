//
//  ViewController.swift
//  DZ_Basketball
//
//  Created by user on 28/03/2019.
//  Copyright © 2019 Sergey Koshlakov. All rights reserved.
//

import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    var player: AVAudioPlayer?
    
    var hoopExists = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        sceneView.showsStatistics = true
        
        addGesture()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .vertical

        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    // MARK: - Gesture
    
    func addGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        sceneView.addGestureRecognizer(tapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(gesture:)))
        doubleTapGesture.numberOfTapsRequired = 2
        sceneView.addGestureRecognizer(doubleTapGesture)
        
        tapGesture.require(toFail: doubleTapGesture)
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        
        if !hoopExists {
            let location = gesture.location(in: sceneView)
            let results: [ARHitTestResult] = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
            guard let result = results.first else { return }
            guard let _ = result.anchor as? ARPlaneAnchor else { return }
            
            sceneView.scene.rootNode.enumerateChildNodes { node, _ in
                if node.name == "plane" {
                    node.removeFromParentNode()
                }
            }
            
            hoopExists = true
            sceneView.scene.rootNode.addChildNode(loadHoop(on: result))
            sceneView.scene.rootNode.addChildNode(loadTopPlane(on: result))
            sceneView.scene.rootNode.addChildNode(loadBottomPlane(on: result))
        } else {
            guard let transform = sceneView.session.currentFrame?.camera.transform else { return }
            let ball = Ball(transform: transform)
            sceneView.scene.rootNode.addChildNode(ball)
            
            
            
            let path = Bundle.main.path(forResource: "basketball-net-swoosh_f1bfjtvd", ofType: "mp3")
            let url = URL(fileURLWithPath: path ?? "")
            
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
            } catch let error {
                print(error.localizedDescription)
            }
            
            
            
        }
        
    }
    
    @objc func handleDoubleTap(gesture: UITapGestureRecognizer) {

        sceneView.scene.rootNode.enumerateChildNodes { node, _ in
            if (node.name == "hoop") || (node.name == "ball")  {
                node.removeFromParentNode()
            }
        }
        
        hoopExists = false
        
        guard let anchors = sceneView.session.currentFrame?.anchors else { return }
        
        for ancor in anchors {
            sceneView.session.remove(anchor: ancor)
        }
        
        
    }
    
    // MARK: - Methods
    
    func loadHoop(on result: ARHitTestResult) -> SCNNode {
        
        let hoopScene = SCNScene(named: "art.scnassets/hoop.scn")!
        
        let hoopNode = hoopScene.rootNode.childNode(withName: "hoop", recursively: false)!
        
        configureHoopNode(hoopNode, for: result)
        
        let phisicsShape = SCNPhysicsShape(node: hoopNode, options: [
            SCNPhysicsShape.Option.type : SCNPhysicsShape.ShapeType.concavePolyhedron,
            SCNPhysicsShape.Option.collisionMargin : 0.01
            ])
        hoopNode.physicsBody = SCNPhysicsBody(type: .static, shape: phisicsShape)
        
        return hoopNode
    }
    
    func loadTopPlane(on result: ARHitTestResult) -> SCNNode {
    
        let hoopScene = SCNScene(named: "art.scnassets/hoop.scn")!
        let topPlane = hoopScene.rootNode.childNode(withName: "topPlane", recursively: false)!
        
        configureHoopNode(topPlane, for: result)
        
        return topPlane
    }
    
    func loadBottomPlane(on result: ARHitTestResult) -> SCNNode {
        
        let hoopScene = SCNScene(named: "art.scnassets/hoop.scn")!
        let bottomPlane = hoopScene.rootNode.childNode(withName: "bottomPlane", recursively: false)!
        
        configureHoopNode(bottomPlane, for: result)
        
        return bottomPlane
    }
    
    func configureHoopNode(_ node: SCNNode, for result: ARHitTestResult) {
        node.simdTransform = result.worldTransform
        node.scale = SCNVector3(0.5, 0.5, 0.5)
        node.eulerAngles.x -= .pi / 2
    }
        
}
