//
//  IrisCamera.swift
//  Iris
//
//  Created by Eric Wang on 12/18/16.
//  Copyright © 2016 EricWang. All rights reserved.
//

import UIKit
import AVFoundation

protocol IrisCameraDelegate {
    func cameraSessionConfigurationDidComplete()
    func cameraSessionDidBegin()
    func cameraSessionDidStop()
}

/**
    This enum tells us whether the camera is
    front facing or rear facing
*/
enum CameraMode {
    case front
    case back
}


class IrisCamera: NSObject {
    var delegate: IrisCameraDelegate?
    
    var session: AVCaptureSession!
    var sessionQueue: DispatchQueue!
    var stillImageOutput: AVCaptureStillImageOutput?
    
    var cameraCheck = CameraMode.back

    init(sender: AnyObject) {
        super.init()
        self.delegate = sender as? IrisCameraDelegate
        self.setObservers()
        self.initializeSession()
    }
    
    deinit {
        self.removeObservers()
    }
    
    func initializeSession() {
        self.session = AVCaptureSession()
        self.session.sessionPreset = AVCaptureSessionPresetPhoto
        self.sessionQueue = DispatchQueue(label: "camera session", attributes: [])
        
        self.sessionQueue.async {
            self.session.beginConfiguration()
            self.addVideoInput()
            self.addStillImageOutput()
            self.session.commitConfiguration()
            
            DispatchQueue.main.async {
                NSLog("Session initialization did complete")
                self.delegate?.cameraSessionConfigurationDidComplete()
            }
        }
    }
    
    // MARK: Configuration
    
    func addVideoInput() {
        if cameraCheck ==  CameraMode.front  {
            cameraCheck = CameraMode.back
            let device: AVCaptureDevice = self.deviceWithMediaTypeWithPosition(AVMediaTypeVideo as NSString, position: AVCaptureDevicePosition.front)
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if self.session.canAddInput(input) {
                    self.session.addInput(input)
                }
            } catch {
                print(error)
            }
        }else{
            cameraCheck = CameraMode.front
            let device: AVCaptureDevice = self.deviceWithMediaTypeWithPosition(AVMediaTypeVideo as NSString, position: AVCaptureDevicePosition.back)
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if self.session.canAddInput(input) {
                    self.session.addInput(input)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func addStillImageOutput() {
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        if self.session.canAddOutput(stillImageOutput) {
            session.addOutput(stillImageOutput)
        }
    }
    
    func deviceWithMediaTypeWithPosition(_ mediaType: NSString, position: AVCaptureDevicePosition) -> AVCaptureDevice {
        let devices: NSArray = AVCaptureDevice.devices(withMediaType: mediaType as String) as NSArray
        var captureDevice: AVCaptureDevice = devices.firstObject as! AVCaptureDevice
        for device in devices {
            let d = device as! AVCaptureDevice
            if d.position == position {
                captureDevice = d
                break;
            }
        }
        return captureDevice
    }
    
    // MARK: Observers
    
    func setObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(IrisCamera.sessionDidStart(_:)), name: NSNotification.Name.AVCaptureSessionDidStartRunning, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IrisCamera.sessionDidStop(_:)), name: NSNotification.Name.AVCaptureSessionDidStopRunning, object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func sessionDidStart(_ notification: Notification) {
        DispatchQueue.main.async {
            NSLog("Session did start")
            self.delegate?.cameraSessionDidBegin()
        }
    }
    
    func sessionDidStop(_ notification: Notification) {
        DispatchQueue.main.async {
            NSLog("Session did stop")
            self.delegate?.cameraSessionDidStop()
        }
    }
    
    // MARK - Camera Actions
    
    func startCamera() {
        self.sessionQueue.async {
            self.session.startRunning()
        }
    }
    
    func stopCamera() {
        self.sessionQueue.async {
            self.session.stopRunning()
        }
    }
    
    func captureStillImage(_ completed: @escaping (_ image: UIImage?) -> Void) {
        if let imageOutput = self.stillImageOutput {
            self.sessionQueue.async(execute: { () -> Void in
                
                var videoConnection: AVCaptureConnection?
                for connection in imageOutput.connections {
                    let c = connection as! AVCaptureConnection
                    
                    for port in c.inputPorts {
                        let p = port as! AVCaptureInputPort
                        if p.mediaType == AVMediaTypeVideo {
                            videoConnection = c;
                            break
                        }
                    }
                    
                    if videoConnection != nil {
                        break
                    }
                }
                
                if videoConnection != nil {
                    imageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { sampleBuffer, error -> Void in
                        let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                        let image: UIImage? = UIImage(data: imageData!)!
                        
                        DispatchQueue.main.async {
                            completed(image)
                        }
                    })
                } else {
                    DispatchQueue.main.async {
                        completed(nil)
                    }
                }
            })
        } else {
            completed(nil)
        }
    }
}
