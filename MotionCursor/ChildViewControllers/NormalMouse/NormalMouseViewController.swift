//
//  NormalMouseViewController.swift
//  MotionCursor
//
//  Created by NH on 2020/08/25.
//  Copyright © 2020 NH. All rights reserved.
//

import UIKit
import CoreMotion

class NormalMouseViewController: UIViewController {
    
    let bm = BluetoothManager()
    let motionManager = CMMotionManager()
    let rate: Double = 500.0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.motionListeningSetup()
    }
    
    
    // MARK: - Motion Contents
    func motionListeningSetup() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
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
            let mouseInfoDaeta = try encodeMouseInfo(mouseInfo: MouseInfo(type: MOUSE_TYPE.NORMAL.rawValue,
                                                                          acc: AccParam(x: deviceMotion.userAcceleration.x * rate,
                                                                                        y: deviceMotion.userAcceleration.y * rate,
                                                                                        z: deviceMotion.userAcceleration.z * rate), atti: nil))
            bm.notify(data: mouseInfoDaeta)
        } catch {
            print("encode error")
        }
    }
    

}
