//
//  ViewController.swift
//  Emocia
//
//  Created by Sanchitha Dinesh on 6/26/21.
//

import UIKit
import ARKit
import CoreML

class ViewController: UIViewController {
    
    private let sceneView = ARSCNView(frame: UIScreen.main.bounds)
    
    private let model = try! VNCoreMLModel(for: harshsikka_big().model)
    private var textNode: SCNNode?
    private var label: UILabel? = UILabel()
    var currentAngleY: Float = 0.0
    var currentNode: SCNNode!

    //Not Really Necessary But Can Use If You Like
    var isRotating = false
    override func viewDidLoad() {

        super.viewDidLoad()
        guard ARWorldTrackingConfiguration.isSupported else { return }

        view.addSubview(sceneView)
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.session.run(ARFaceTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])
        let scene = SCNScene(named: "art.scnassets/scene.scn")!
       
//        sceneView.scene = scene
//        sceneView.pointOfView?.addChildNode(scene.rootNode)

        label = UILabel(frame: CGRect(x: 5, y: 10, width: view.frame.width, height: view.frame.height))
        label?.center = CGPoint(x: 160, y: 285)
        label?.textAlignment = .center
        label?.text = "Wait..."
        if let label = label {
            self.view.addSubview(label)
        }
    }


    private func addTextNode(faceGeometry: ARSCNFaceGeometry) {
        let text = SCNText(string: "", extrusionDepth: 1)
        text.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.systemYellow
        text.materials = [material]

        let textNode = SCNNode(geometry: faceGeometry)
        textNode.position = SCNVector3(-0.1, 0.3, -0.5)
        textNode.scale = SCNVector3(0.003, 0.003, 0.003)
        textNode.geometry = text
        self.textNode = textNode
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    @objc func rotateObject(_ gesture: UIPanGestureRecognizer) {

        guard let nodeToRotate = currentNode else { return }

        let translation = gesture.translation(in: gesture.view!)
        var newAngleY = (Float)(translation.x)*(Float)(Double.pi)/180.0
        newAngleY += currentAngleY

        nodeToRotate.eulerAngles.y = newAngleY

        if(gesture.state == .ended) { currentAngleY = newAngleY }

        print(nodeToRotate.eulerAngles)
    }

}

extension ViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = sceneView.device else { return nil }
        let node = SCNNode(geometry: ARSCNFaceGeometry(device: device))
        
        //Projects the white lines on the face.
        node.geometry?.firstMaterial?.transparency = 0
        return node
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let faceGeometry = node.geometry as? ARSCNFaceGeometry, textNode == nil else { return }
        addTextNode(faceGeometry: faceGeometry)
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
            let faceGeometry = node.geometry as? ARSCNFaceGeometry,
            let pixelBuffer = self.sceneView.session.currentFrame?.capturedImage
            else {
            return
        }

        faceGeometry.update(from: faceAnchor.geometry)
        let cameraNode = sceneView.pointOfView

        //Creates Vision Image Request Handler using the current frame and performs an MLRequest.
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: [:]).perform([VNCoreMLRequest(model: model) { [weak self] request, error in

            guard let firstResult = (request.results as? [VNClassificationObservation])?.first else { return }
                DispatchQueue.main.async {
                    var emojiNode:SCNNode? = nil

                    // Check for the existing emojiNode and remove it
                    if let childEmojiNode =  cameraNode?.childNodes[0] {
                        childEmojiNode.removeFromParentNode()
                    }
                    
                    let anger = SCNScene(named: "art.scnassets/anger.scn")
                    let disgust = SCNScene(named: "art.scnassets/disgust.scn")
                    let fear = SCNScene(named: "art.scnassets/fear.scn")
                    let happy = SCNScene(named: "art.scnassets/happy.scn")
                    let neutral = SCNScene(named: "art.scnassets/neutral.scn")
                    let sad = SCNScene(named: "art.scnassets/sad.scn")
                    let surprised = SCNScene(named: "art.scnassets/surprised.scn")

                    let angerNode = anger?.rootNode.childNodes[0]
                    let disgustNode = disgust?.rootNode.childNodes[0]
                    let fearNode = fear?.rootNode.childNodes[0]
                    let happyNode = happy?.rootNode.childNodes[0]
                    let neutralNode = neutral?.rootNode.childNodes[0]
                    let sadNode = sad?.rootNode.childNodes[0]
                    let surprisedNode = surprised?.rootNode.childNodes[0]
                    
                    if firstResult.confidence > 0.92 {
                        self?.label?.text = firstResult.identifier
                        
                        switch firstResult.identifier {
                        case "angry":
                            emojiNode = angerNode ?? nil
                        case "disgust":
                           emojiNode = disgustNode ?? nil
                        case "fear":
                            emojiNode = fearNode ?? nil
                        case "happy":
                            emojiNode = happyNode ?? nil
                        case "neutral":
                           emojiNode = neutralNode ?? nil
                        case "sad":
                            emojiNode = sadNode ?? nil
                        case "surprised":
                            emojiNode = surprisedNode ?? nil
                            
                        default:
                            emojiNode = neutralNode ?? nil
                        
                        }
                        
                        if let emojiNode = emojiNode {
                            cameraNode?.addChildNode(emojiNode)
                            emojiNode.position = SCNVector3(x: 0, y: 0, z: -10)
                            let action = SCNAction.rotateBy(x: 0, y: CGFloat(2 * Double.pi), z: 0, duration: 10)
                            let repAction = SCNAction.repeatForever(action)
                            emojiNode.runAction(repAction, forKey: "myrotate")
                        }
                    }
                }
            }])
    }

}

