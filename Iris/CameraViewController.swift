//
//  CameraViewController.swift
//  Iris
//
//  Created by Eric Wang on 12/8/16.
//  Copyright © 2016 EricWang. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    @IBOutlet weak var capturePhotoButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var cameraPreviewView: UIView! // area for previewing camera image
    
    // AVCapture variables used in custom camera
    var session: AVCaptureSession!
    var output: AVCaptureStillImageOutput!
    var input: AVCaptureDeviceInput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var captureDevice: AVCaptureDevice!
    
    var image: UIImage? // image captured by camera
    
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
        Set up the preview layer of our camera
    */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer.frame = cameraPreviewView.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false 
    }
    
    /**
        This is where we instantiate our camera object
    */
    func setupCustomCamera() {
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetPhoto
        
        captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        var error: NSError?
        
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
        } catch let captureError as NSError {
            error = captureError
            input = nil
            print(error?.localizedDescription ?? "Could not start camera")
        }
        
        if error == nil && session.canAddInput(input) {
            session.addInput(input)
            output = AVCaptureStillImageOutput()
            output.outputSettings = [ AVVideoCodecKey : AVVideoCodecJPEG ]
            
            if session.canAddOutput(output) {
                session.addOutput(output)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: session)
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                
                cameraPreviewView.layer.insertSublayer(previewLayer, at: 0)
                session.startRunning()
            }
        }
    }
    
    // MARK - Camera Actions
    @IBAction func capturePhoto(_ sender: UIButton) {
        guard let connection = output.connection(withMediaType: AVMediaTypeVideo) else { return }
        connection.videoOrientation = .portrait
        
        output.captureStillImageAsynchronously(from: connection) { (sampleBuffer, error) in
            guard sampleBuffer != nil && error == nil else { return }
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
            
            self.image = UIImage(data: imageData!)
            
        }
    }
    
    @IBAction func toggleFlash(_ sender: UIButton) {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        if (device?.hasFlash)! {
            do {
                try device?.lockForConfiguration()
                
                if (device?.flashMode == AVCaptureFlashMode.on) {
                    device?.flashMode = AVCaptureFlashMode.off
                    self.flashButton.setImage(UIImage(named: "Flash"), for: .normal)
                } else {
                    device?.flashMode = AVCaptureFlashMode.on
                    self.flashButton.setImage(UIImage(named: "FlashActive"), for: .normal)
                }
                device?.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }
}
