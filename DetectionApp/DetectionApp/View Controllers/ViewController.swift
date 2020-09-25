//
//  ViewController.swift
//  DetectionApp
//
//  Created by Brandi Taylor on 9/25/20.
//

import UIKit
import AVFoundation
import Vision
import CoreML

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // Instantiate a new capture session, to be created when called
    lazy var captureSession = AVCaptureSession()
    
    // Instantiate output from camera data to add to captureSession
    let cameraOutput = AVCaptureVideoDataOutput()
    
    // Define the model to be used
//    let model = try? VNCoreMLModel(for: MobileNetV2().model)
    let model = try? VNCoreMLModel(for: Resnet50().model)
    
    let detectedObjectController = DetectedObjectController()
    
    @IBOutlet weak var cameraView: CameraPreviewView!
    @IBOutlet weak var resultLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call configure session, which creates a new session when the view loads
        configureSession()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
       
        // Stop session once the view has disappeared
        captureSession.stopRunning()
    }
    
    func configureSession() {
        
        // Create a new capture device from camera
        guard let camera = AVCaptureDevice.default(for: .video) else { return }
        cameraView.videoPreviewLayer.videoGravity = .resizeAspectFill
        
        // Use camera to capture input
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else { return }
        
        // Allow camera to be added to captureSession and add it to the captureSession
        guard captureSession.canAddInput(cameraInput) else {
            fatalError("Cannot add cameraInput to session.")
        }
        
        captureSession.addInput(cameraInput)
        
        // Allow cameraOut put to be added to the captureSession
        guard captureSession.canAddOutput(cameraOutput) else {
            fatalError("Cannot add cameraOutput to session.")
        }
        
        captureSession.addOutput(cameraOutput)
        
        // Sends cameraOutput buffer to a background queue
        cameraOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "captureQueue"))
        
        // Set the session of the preview layer to the captureSession
        cameraView.session = captureSession
        
        // Begin running captureSession
        captureSession.startRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let request = VNCoreMLRequest(model: model!, completionHandler: { [self] (completedRequest, error) in
        
            if let error = error {
                fatalError("Could not complete request")
            }
            
            // Define the results of the VNCoreMLRequest as an array of VNClassificationObservations
            guard let requestResults = completedRequest.results as? [VNClassificationObservation] else { return }
            
            // Define the first result in the requestedResults Array
            guard let requestResult = requestResults.first else { return }
            
            // Send the result identifer to the main queue to update the resultLabel with the requestResult
            DispatchQueue.main.async {
                resultLabel.text = requestResult.identifier
            }
            
        })
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        
    }
    
    @IBAction func saveObjectTapped(_ sender: Any) {
        
        guard let detectedObjectName = resultLabel.text else { return }
        
        detectedObjectController.createDetectedObject(withName: detectedObjectName)
        print("Save Tapped")
//        print(detectedObjectController.detectedObjects.count)
    }
    
}

