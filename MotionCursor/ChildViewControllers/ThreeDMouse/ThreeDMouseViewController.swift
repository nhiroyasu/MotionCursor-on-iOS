//
//  ThreeDMouseViewController.swift
//  MotionCursor
//
//  Created by NH on 2020/08/25.
//  Copyright © 2020 NH. All rights reserved.
//

import UIKit
import CoreMotion

class ThreeDMouseViewController: UIViewController, MotionControllable, TrackpadViewListener {
    // MARK: - View Contents ...
    @IBOutlet weak var trackpadView: TrackpadView!
    
    // MARK: - Manager etc ...
    let bluetoothManager = BluetoothManager.shared
    var motionManager = CMMotionManager()
    lazy var motionControl = MotionControl(controllable: self)
    
    // MARK: - Propaty
    let pitchRate: Double = 0.5
    let yawRate: Double = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.trackpadView.setListener(listener: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.motionControl.startListeningMotion()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // TODO: Bluetoothの切断処理
        self.motionControl.stopListeningMotion()
    }
    
    func onMotion(deviceMotion: CMDeviceMotion) {
        do {
            let mouseInfoData = try encodeMouseInfo(mouseInfo: MouseInfo(type: MOUSE_TYPE.ThreeD.rawValue, acc: nil,
                                                                          atti: AttiParam(pitch: deviceMotion.attitude.pitch/pitchRate,
                                                                                          yaw: deviceMotion.attitude.yaw/yawRate,
                                                                                          roll: deviceMotion.attitude.roll)))
            self.bluetoothManager.notifyMotionInfo(data: mouseInfoData)
        } catch {
            print("encode error")
        }
    }

    
    func leftClickStart() {}
    
    func leftClickEnd() {
        do {
            let mouseAction = MouseAction(type: .LEFT_CLICK, action: .DOWN)
            let mouseActionData = try encodeMouseAction(mouseAction: mouseAction)
            self.bluetoothManager.notifyMotionAction(data: mouseActionData)
        } catch {
            print("encode error")
        }
    }
    
    func leftClickMove() {}
}
