//
//  CameraPreviewView.swift
//  DetectionApp
//
//  Created by Brandi Taylor on 9/25/20.
//

import UIKit
import AVFoundation

class CameraPreviewView: UIView {
    
    // Creates a subclass to add a preview layer to a UIView

    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    var session: AVCaptureSession? {
        get { return videoPreviewLayer.session }
        set { videoPreviewLayer.session = newValue }
    }

}
