//
//  ViewController.swift
//  PokerHandRecognizer
//
//  Created by Ryan Gaines on 10/15/18.
//  Copyright © 2018 Team 4. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

import Vision


class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    // COREML
    var visionRequests = [VNRequest]()
    let dispatchQueueML = DispatchQueue(label: "com.hw.dispatchqueueml") // A Serial Queue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpARKit()
        self.setUpVision()
        self.coreMLLoop()
    }
    
    func setUpARKit(){
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // Enable Default Lighting - makes the 3D text a bit poppier.
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    func setUpVision(){
        guard let selectedModel = try? VNCoreMLModel(for: Recognizer().model) else {
            fatalError("Could not load model. Ensure model has been drag and dropped (copied) to XCode Project from the GitHub.")
        }
        let dectectionRequest = VNCoreMLRequest(model: selectedModel, completionHandler: objectCompleteHandler)
        
        visionRequests = [dectectionRequest]
        
    }
    
    func objectCompleteHandler(request: VNRequest, error: Error?){
        
    }
    
    func coreMLLoop(){
        dispatchQueueML.async {
            // 1. Run Update.
            self.updateCoreML()
            
            // 2. Loop this function.
            self.coreMLLoop()
        }

    }
    
    func updateCoreML(){
        let pixbuff : CVPixelBuffer? = (sceneView.session.currentFrame?.capturedImage)
        if pixbuff == nil { return }
        let ciImage = CIImage(cvPixelBuffer: pixbuff!)
        
        let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        do {
            try imageRequestHandler.perform(self.visionRequests)
        } catch {
            print(error)
        }
        
    }
//    func classifyAsHand(_: results){
//        var cardNum = 0
//        for observation in results where observation is VNRecognizedObjectObservation {
//            guard let objectObserve = observation as? VNRecognizedObjectObservation else{
//                continue
//            }
//            let top = objectObserve.labels[0]
//        }
//    }
//
    //make a function the iterates over result ditionary
    //if card num is five, pass into function that determines hand

    
}

