//
//  NormalMouseViewController.swift
//  MotionCursor
//
//  Created by NH on 2020/08/25.
//  Copyright © 2020 NH. All rights reserved.
//

import UIKit
import CoreMotion

class NormalMouseViewController: UIViewController, MotionControllable {
    
    let bluetoothManager = BluetoothManager()
    var motionManager = CMMotionManager()
    lazy var motionControl: MotionControl = MotionControl(controllable: self)
    let rate: Double = 500.0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.motionControl.motionListeningSetup()
    }
    
    
    func onMotion(deviceMotion:CMDeviceMotion) {
        do {
            let mouseInfoDaeta = try encodeMouseInfo(mouseInfo: MouseInfo(type: MOUSE_TYPE.NORMAL.rawValue,
                                                                          acc: AccParam(x: deviceMotion.userAcceleration.x * rate,
                                                                                        y: deviceMotion.userAcceleration.y * rate,
                                                                                        z: deviceMotion.userAcceleration.z * rate), atti: nil))
            bluetoothManager.notifyMotionInfo(data: mouseInfoDaeta)
        } catch {
            print("encode error")
        }
    }
    

}
