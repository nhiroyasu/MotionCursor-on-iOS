//
//  TrackpadView.swift
//  MotionCursor
//
//  Created by NH on 2020/08/31.
//  Copyright © 2020 NH. All rights reserved.
//

import UIKit

/**
 * トラックパッドを再現したView
 */
class TrackpadView: UIView {
    
    private var listener: TrackpadViewListener? = nil
    func setListener(listener: TrackpadViewListener) {
        self.listener = listener
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.backgroundColor = UIColor(hex: 0xf0f0f0)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.backgroundColor = UIColor(hex: 0xffffff)
        self.listener?.leftClickEnd()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // NOTE: 一定の速度以上の変化であれば、マウスの動きとして認識させる？
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.backgroundColor = UIColor(hex: 0xffffff)
    }

}

protocol TrackpadViewListener {
    func leftClickStart() -> Void
    func leftClickEnd() -> Void
    func leftClickMove() -> Void
}
