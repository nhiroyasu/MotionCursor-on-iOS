//
//  ThreeDMouseViewController.swift
//  MotionCursor
//
//  Created by NH on 2020/08/25.
//  Copyright © 2020 NH. All rights reserved.
//

import UIKit
import CoreMotion

class ThreeDMouseViewController: UIViewController, MotionControllable {

    let bluetoothManager = BluetoothManager()
    var motionManager = CMMotionManager()
    lazy var motionControl = MotionControl(controllable: self)
    
    let pitchRate: Double = 0.5
    let yawRate: Double = 0.5
    let FPS: Double = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.motionControl.motionListeningSetup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        
    }
    
    func onMotion(deviceMotion: CMDeviceMotion) {
        do {
            let mouseInfoDaeta = try encodeMouseInfo(mouseInfo: MouseInfo(type: MOUSE_TYPE.ThreeD.rawValue, acc: nil,
                                                                          atti: AttiParam(pitch: deviceMotion.attitude.pitch/pitchRate,
                                                                                          yaw: deviceMotion.attitude.yaw/yawRate,
                                                                                          roll: deviceMotion.attitude.roll)))
            bluetoothManager.notifyMotionInfo(data: mouseInfoDaeta)
        } catch {
            print("encode error")
        }
    }

}
