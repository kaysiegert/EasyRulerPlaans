//
//  CancelButton.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 02.10.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 12.0, *)
internal final class CancelButton: UIButton {
    
    private final let handler: MeasureState_Handler
    
    init(frame: CGRect, handler: MeasureState_Handler) {
        self.handler = handler
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override internal final func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.handler.currentState = self.handler.endState
    }
}
