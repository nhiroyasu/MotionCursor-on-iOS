//
//  ExUIColor.swift
//  MotionCursor
//
//  Created by NH on 2020/08/31.
//  Copyright © 2020 NH. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let r = CGFloat((hex & 0xff0000) >> 16) / CGFloat(0xff)
        let g = CGFloat((hex & 0x00ff00) >> 8) / CGFloat(0xff)
        let b = CGFloat(hex & 0x0000ff) / CGFloat(0xff)
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0.0), 1.0))
    }
}
