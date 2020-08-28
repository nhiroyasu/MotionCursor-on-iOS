//
//  ThreeDMouseViewController.swift
//  MotionCursor
//
//  Created by NH on 2020/08/25.
//  Copyright © 2020 NH. All rights reserved.
//

import UIKit
import CoreMotion

class ThreeDMouseViewController: UIViewController {

    let bm = BluetoothManager()
    let motionManager = CMMotionManager()
    let pitchRate: Double = 0.5
    let yawRate: Double = 0.5
    let FPS: Double = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.motionListeningSetup()
    }
    

    // MARK: - Motion Contents
    func motionListeningSetup() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 1.0 / self.FPS
            motionManager.startDeviceMotionUpdates(to: .main) { (motionOptional, error) in
                if let e = error {
                    print("error on [Start DeviceMotionUpdates]", e)
                    return
                }
                
                guard let motion = motionOptional else {
                    print("motion is null")
                    return
                }
                
                self.onMotionData(deviceMotion: motion)
            }
            
        } else {
            print("this device is not motion active")
        }
    }
    
    func onMotionData(deviceMotion:CMDeviceMotion) {
        do {
            let mouseInfoDaeta = try encodeMouseInfo(mouseInfo: MouseInfo(type: MOUSE_TYPE.ThreeD.rawValue, acc: nil,
                                                                          atti: AttiParam(pitch: deviceMotion.attitude.pitch/pitchRate,
                                                                                          yaw: deviceMotion.attitude.yaw/yawRate,
                                                                                          roll: deviceMotion.attitude.roll)))
            bm.notify(data: mouseInfoDaeta)
        } catch {
            print("encode error")
        }
    }
}
