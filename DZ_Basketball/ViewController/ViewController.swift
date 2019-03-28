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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        addGesture()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .vertical

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: --Methods
    
    func addGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        sceneView.addGestureRecognizer(tapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(gesture:)))
        doubleTapGesture.numberOfTapsRequired = 2
        sceneView.addGestureRecognizer(doubleTapGesture)
        
        tapGesture.require(toFail: doubleTapGesture)
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        
        let location = gesture.location(in: sceneView)
        let results: [ARHitTestResult] = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        guard let result = results.first else { return }
        guard let _ = result.anchor as? ARPlaneAnchor else { return }
        
        sceneView.scene.rootNode.enumerateChildNodes { node, _ in
            if node.name == "Plane" {
                node.removeFromParentNode()
            }
        }
        
        let hoopScene = SCNScene(named: "art.scnassets/hoop.scn")!
        let hoopNode = hoopScene.rootNode.childNode(withName: "hoop", recursively: false)!
        hoopNode.simdTransform = result.worldTransform
        hoopNode.scale = SCNVector3(0.5, 0.5, 0.5)
        hoopNode.eulerAngles.x -= .pi / 2
        
        sceneView.scene.rootNode.addChildNode(hoopNode)
    }
    
    @objc func handleDoubleTap(gesture: UITapGestureRecognizer) {

        sceneView.scene.rootNode.enumerateChildNodes { node, _ in
            if node.name == "hoop" {
                node.removeFromParentNode()
            }
        }
        
    }
    
}
