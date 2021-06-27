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
    
    //initializers
    private let sceneView = ARSCNView(frame: UIScreen.main.bounds)
    private let model = try! VNCoreMLModel(for: harshsikka_big().model)
    private var angerButton: UIButton = UIButton()
    private var disgustButton: UIButton = UIButton()
    private var fearButton: UIButton = UIButton()
    private var happyButton: UIButton = UIButton()
    private var neutralButton: UIButton = UIButton()
    private var sadButton: UIButton = UIButton()
    private var surprisedButton: UIButton = UIButton()
    private var classificationObservation: VNClassificationObservation?
    private var score: UILabel = UILabel()
    
    private var angerNode: SCNNode?
    private var disgustNode: SCNNode?
    private var fearNode: SCNNode?
    private var happyNode: SCNNode?
    private var neutralNode: SCNNode?
    private var sadNode: SCNNode?
    private var surprisedNode: SCNNode?
    

    override func viewDidLoad() {

        super.viewDidLoad()
        guard ARWorldTrackingConfiguration.isSupported else { return }
        
        view.addSubview(sceneView)
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.session.run(ARFaceTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])
        
        //score
        var scoreAmount = 0
        score.text = "\(scoreAmount)"
        
        //anger button
        self.angerButton = UIButton(type: .system, primaryAction: UIAction(title: "Anger", handler: { _ in
            
            //checks if button clicked matches what CoreML model identifies
            if let firstResult = self.classificationObservation, firstResult.confidence > 0.5 &&  firstResult.identifier == "angry" {
                print("Correct!")
                let alert = UIAlertController(title: "That's correct!", message: "+5 points", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                scoreAmount+=5
                self.score.text = "\(scoreAmount)"
            }
            else {
                let alert = UIAlertController(title: "Nice try! Keep trying!", message: "You'll get it next time", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }

        }))
        angerButton.backgroundColor = UIColor(red: 240/255, green: 164/255, blue: 164/255, alpha: 1)
        angerButton.setTitleColor(UIColor.white, for: .normal)
        angerButton.layer.cornerRadius = 4

        //disgust button
        self.disgustButton = UIButton(type: .system, primaryAction: UIAction(title: "Disgust", handler: { _ in
            
            //checks if button clicked matches what CoreML model identifies
            if let firstResult = self.classificationObservation, firstResult.confidence > 0.5 &&  firstResult.identifier == "disgust" {
                print("Button tapped!")
                let alert = UIAlertController(title: "That's correct!", message: "+5 points", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                scoreAmount+=5
                self.score.text = "\(scoreAmount)"
            }
            else {
                let alert = UIAlertController(title: "Nice try! Keep trying!", message: "You'll get it next time", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }


        }))
        disgustButton.backgroundColor = UIColor(red: 208/255, green: 240/255, blue: 169/255, alpha: 1)
        disgustButton.setTitleColor(UIColor.white, for: .normal)
        disgustButton.layer.cornerRadius = 4
        
        //fear button
        self.fearButton = UIButton(type: .system, primaryAction: UIAction(title: "Fear", handler: { _ in
           
            //checks if button clicked matches what CoreML model identifies
            if let firstResult = self.classificationObservation, firstResult.confidence > 0.5 &&  firstResult.identifier == "fear" {
                print("Button tapped!")
                let alert = UIAlertController(title: "That's correct!", message: "+5 points", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                scoreAmount+=5
                self.score.text = "\(scoreAmount)"
            }
            else {
                let alert = UIAlertController(title: "Nice try! Keep trying!", message: "You'll get it next time", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }


        }))
        fearButton.backgroundColor = UIColor(red: 220/255, green: 190/255, blue: 254/255, alpha: 1)
        fearButton.setTitleColor(UIColor.white, for: .normal)
        fearButton.layer.cornerRadius = 4
        
        //happy button
        self.happyButton = UIButton(type: .system, primaryAction: UIAction(title: "Happy", handler: { _ in
            
            //checks if button clicked matches what CoreML model identifies
            if let firstResult = self.classificationObservation, firstResult.confidence > 0.5 &&  firstResult.identifier == "happy" {
                print("Button tapped!")
                let alert = UIAlertController(title: "That's correct!", message: "+5 points", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                scoreAmount+=5
                self.score.text = "\(scoreAmount)"
            }
            else {
                let alert = UIAlertController(title: "Nice try! Keep trying!", message: "You'll get it next time", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }


        }))
        happyButton.backgroundColor = UIColor(red: 255/255, green: 240/255, blue: 147/255, alpha: 1)
        happyButton.setTitleColor(UIColor.white, for: .normal)
        happyButton.layer.cornerRadius = 4
        
        //neutral button
        self.neutralButton = UIButton(type: .system, primaryAction: UIAction(title: "Neutral", handler: { _ in
            
            //checks if button clicked matches what CoreML model identifies
            if let firstResult = self.classificationObservation, firstResult.confidence > 0.5 &&  firstResult.identifier == "neutral" {
                print("Button tapped!")
                let alert = UIAlertController(title: "That's correct!", message: "+5 points", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                scoreAmount+=5
                self.score.text = "\(scoreAmount)"
            }
            else {
                let alert = UIAlertController(title: "Nice try! Keep trying!", message: "You'll get it next time", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }


        }))
        neutralButton.backgroundColor = UIColor(red: 209/255, green: 209/255, blue: 204/255, alpha: 1)
        neutralButton.setTitleColor(UIColor.white, for: .normal)
        neutralButton.layer.cornerRadius = 4
        
        //sad button
        self.sadButton = UIButton(type: .system, primaryAction: UIAction(title: "Sad", handler: { _ in
            
            //checks if button clicked matches what CoreML model identifies
            if let firstResult = self.classificationObservation, firstResult.confidence > 0.5 &&  firstResult.identifier == "sad" {
                print("Button tapped!")
                let alert = UIAlertController(title: "That's correct!", message: "+5 points", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                scoreAmount+=5
                self.score.text = "\(scoreAmount)"
            }
            else {
                let alert = UIAlertController(title: "Nice try! Keep trying!", message: "You'll get it next time", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }


        }))
        sadButton.setTitleColor(UIColor.white, for: .normal)
        sadButton.layer.cornerRadius = 4
        sadButton.backgroundColor = UIColor(red: 121/255, green: 215/255, blue: 213/255, alpha: 1)

        //surprised button
        self.surprisedButton = UIButton(type: .system, primaryAction: UIAction(title: "Surprise", handler: { _ in
            
            //checks if button clicked matches what CoreML model identifies
            if let firstResult = self.classificationObservation, firstResult.confidence > 0.65 &&  firstResult.identifier == "surprise" {
                print("Button tapped!")
                let alert = UIAlertController(title: "That's correct!", message: "+5 points", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                scoreAmount+=5
                self.score.text = "\(scoreAmount)"
            }
            else {
                let alert = UIAlertController(title: "Nice try! Keep trying!", message: "You'll get it next time", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }


        }))
        surprisedButton.backgroundColor = UIColor(red: 255/255, green: 198/255, blue: 140/255, alpha: 1)
        surprisedButton.setTitleColor(UIColor.white, for: .normal)
        surprisedButton.layer.cornerRadius = 4


        //adding subviews to view
        view.addSubview(angerButton)
        view.addSubview(disgustButton)
        view.addSubview(happyButton)
        view.addSubview(fearButton)
        view.addSubview(happyButton)
        view.addSubview(neutralButton)
        view.addSubview(sadButton)
        view.addSubview(surprisedButton)
        view.addSubview(score)

        //scenes from scassets
        let anger = SCNScene(named: "art.scnassets/anger.scn")
        let disgust = SCNScene(named: "art.scnassets/disgust.scn")
        let fear = SCNScene(named: "art.scnassets/fear.scn")
        let happy = SCNScene(named: "art.scnassets/happy.scn")
        let neutral = SCNScene(named: "art.scnassets/neutral.scn")
        let sad = SCNScene(named: "art.scnassets/sad.scn")
        let surprised = SCNScene(named: "art.scnassets/surprised.scn")

        //node from each scene
        angerNode = anger?.rootNode.childNodes[0]
        disgustNode = disgust?.rootNode.childNodes[0]
        fearNode = fear?.rootNode.childNodes[0]
        happyNode = happy?.rootNode.childNodes[0]
        neutralNode = neutral?.rootNode.childNodes[0]
        sadNode = sad?.rootNode.childNodes[0]
        surprisedNode = surprised?.rootNode.childNodes[0]

    }
    
    override func viewWillLayoutSubviews() {
        
        //layout for subviews
        let height = self.view.frame.height
        let frame = CGRect(x: 100, y: height - 200, width: 100, height: 40)
        angerButton.frame = frame
        angerButton.setNeedsLayout()
        angerButton.layoutIfNeeded()
        
        let frame1 = CGRect(x: 220, y: height - 200, width: 100, height: 40)
        disgustButton.frame = frame1
        disgustButton.setNeedsLayout()
        disgustButton.layoutIfNeeded()
        
        let frame2 = CGRect(x: 100, y: height - 150, width: 100, height: 40)
        happyButton.frame = frame2
        happyButton.setNeedsLayout()
        happyButton.layoutIfNeeded()
        
        let frame3 = CGRect(x: 220, y: height - 150, width: 100, height: 40)
        fearButton.frame = frame3
        fearButton.setNeedsLayout()
        fearButton.layoutIfNeeded()
        
        let frame4 = CGRect(x: 100, y: height - 250, width: 100, height: 40)
        sadButton.frame = frame4
        sadButton.setNeedsLayout()
        sadButton.layoutIfNeeded()
        
        let frame5 = CGRect(x: 220, y: height - 250, width: 100, height: 40)
        surprisedButton.frame = frame5
        surprisedButton.setNeedsLayout()
        surprisedButton.layoutIfNeeded()
        
        let frame6 = CGRect(x: 160, y: height - 300, width: 100, height: 40)
        neutralButton.frame = frame6
        neutralButton.setNeedsLayout()
        neutralButton.layoutIfNeeded()
        
        let frame7 = CGRect(x: 50, y: 50, width: 50, height: 50)
        score.frame = frame7
        score.setNeedsLayout()
        score.layoutIfNeeded()
        
    }


}

extension ViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = sceneView.device else { return nil }
        let node = SCNNode(geometry: ARSCNFaceGeometry(device: device))
        
        //creates invisible mask over face
        node.geometry?.firstMaterial?.transparency = 0
        return node
    }

    

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        //captures expressions on face with ARFaceAnchhor
        guard let faceAnchor = anchor as? ARFaceAnchor,
            let faceGeometry = node.geometry as? ARSCNFaceGeometry,
            let pixelBuffer = self.sceneView.session.currentFrame?.capturedImage
            else {
            return
        }

        faceGeometry.update(from: faceAnchor.geometry)
        
        //glue AR object to camera
        let cameraNode = sceneView.pointOfView

        //Creates Vision Image Request Handler using the current frame and performs an MLRequest.
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: [:]).perform([VNCoreMLRequest(model: model) { [weak self] request, error in

            guard let firstResult = (request.results as? [VNClassificationObservation])?.first else { return }
            
            
            self?.classificationObservation = firstResult
                    var emojiNode:SCNNode? = nil

            //if confidence level of identified expression is higher than 80% create an emojiNode
                    if firstResult.confidence > 0.8 {
                        
                        //checks identifier of MLRequest
                        switch firstResult.identifier {
                        case "angry":
                            emojiNode = self?.angerNode ?? nil
                        case "disgust":
                            emojiNode = self?.disgustNode ?? nil
                        case "fear":
                            emojiNode = self?.fearNode ?? nil
                        case "happy":
                            emojiNode = self?.happyNode ?? nil
                        case "neutral":
                            emojiNode = self?.neutralNode ?? nil
                        case "sad":
                            emojiNode = self?.sadNode ?? nil
                        case "surprise":
                            emojiNode = self?.surprisedNode ?? nil
                            
                        default:
                            emojiNode = self?.neutralNode ?? nil
                        
                        }
                        
                        if let emojiNode = emojiNode {

                            //check for the existing emojiNode and remove it
                            let childCount = cameraNode?.childNodes.count ?? 0
                            if childCount > 0 {
                                
                                if let childEmojiNode =  cameraNode?.childNodes[0] {
                                    
                                    childEmojiNode.removeAllActions()
                                    childEmojiNode.removeFromParentNode()
                                }
                            }
                            emojiNode.removeAllActions()
                            
                            //adds emoji node
                            cameraNode?.addChildNode(emojiNode)

                            emojiNode.position = SCNVector3(x: 1.25, y: 3.5, z: -10)
                            
                            let action = SCNAction.rotateBy(x: 0, y: CGFloat(2 * Double.pi), z: 0, duration: 7)
                            let repAction = SCNAction.repeatForever(action)
                            emojiNode.runAction(repAction, forKey: "myrotate")
                        }
                    }
    
            }])
    }

}

