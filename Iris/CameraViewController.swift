//
//  CameraViewController.swift
//  Iris
//
//  Created by Eric Wang on 12/8/16.
//  Copyright © 2016 EricWang. All rights reserved.
//

import UIKit
import AVFoundation

enum Status: Int {
    case preview, still, error
}

class CameraViewController: UIViewController, IrisCameraDelegate {
    
    @IBOutlet weak var capturePhotoButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var rotateButton: UIButton! 
    @IBOutlet weak var cameraPreviewView: UIView! // area for previewing camera image
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var image: UIImage? // image captured by camera
    
    var camera: IrisCamera? // camera object
    var status: Status = .preview
    
    var isBackCamera = true
    
    override var prefersStatusBarHidden: Bool { return true } // hides status bar on the camera 

    /**
        When we first intialize this view controller
        instantiate our camera object
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomCamera()
    }
    
    /**
        Set up the preview layer of our camera,
        which will depend on which orientation
        our camera object currently has (rear vs front)
    */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupCameraPreviewView()
    }
    
    /**
        This is where we instantiate our camera object
    */
    func setupCustomCamera() {
        self.camera = IrisCamera(sender: self)
    }
    
    func setupCameraPreviewView() {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.camera?.session)
        self.previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.previewLayer?.frame = self.cameraPreviewView.bounds
        self.cameraPreviewView.layer.addSublayer(self.previewLayer)
    }
    
    // MARK - Camera Actions
    @IBAction func capturePhoto(_ sender: UIButton) {
        
    }
    
    @IBAction func rotateCamera(_ sender: UIButton) {
        self.camera = nil
        
        self.setupCustomCamera()
        
        if isBackCamera == true {
            isBackCamera = false
            self.camera?.cameraCheck = CameraMode.front
        }else{
            isBackCamera = true
            self.camera?.cameraCheck = CameraMode.back
        }
        
        self.setupCameraPreviewView()
    }
    
    // MARK - Camera Configuration 
    func cameraSessionConfigurationDidComplete() {
        self.camera?.startCamera()
    }
    
    func cameraSessionDidBegin() {

    }
    
    func cameraSessionDidStop() {
    
    }
}
