//
//  MotionControllable.swift
//  MotionCursor
//
//  Created by NH on 2020/08/28.
//  Copyright © 2020 NH. All rights reserved.
//

import Foundation
import CoreMotion

protocol MotionControllable {
    /**
     CMMotionManagerを宣言
     */
    var motionManager: CMMotionManager { get set }
    
    /**
     Motionデータを購読する時のコールバック
     */
    func onMotion(deviceMotion:CMDeviceMotion)
}
