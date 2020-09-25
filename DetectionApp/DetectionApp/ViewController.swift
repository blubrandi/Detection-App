//
//  ViewController.swift
//  DetectionApp
//
//  Created by Brandi Taylor on 9/25/20.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // Instantiate a new capture session, to be created when called
    lazy var captureSession = AVCaptureSession()
    
    // Instantiate output from camera data to add to captureSession
    let cameraOutput = AVCaptureVideoDataOutput()
    
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
        
        // Sends cameraOutput buffer to a background queue
        cameraOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "captureQueue"))
        
        // Set the session of the preview layer to the captureSession
        cameraView.session = captureSession
        
        // Begin running captureSession
        captureSession.startRunning()
    }


}

