//
//  MeasureState_ManualMeasureState.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 02.10.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation
import SceneKit
import CoreGraphics
import UIKit

@available(iOS 11.0, *)
internal final class MeasureState_ManualMeasureState: MeasureState_General {
 
    private final var timer = Timer.init()
    private final var startPosition: SCNVector3? = nil
    
    private final var currentPosition: SCNVector3? {
        var result: SCNVector3? = nil
        self.interact { (controller) in
             guard let currentFrame = controller.handler.sceneView.session.currentFrame else {
             return
             }
             var translation = matrix_identity_float4x4
             // 20cm in front of the camera
             translation.columns.3.z = -0.0
             let transform = simd_mul(currentFrame.camera.transform, translation)
             result = SCNVector3.init(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
        }
        return result
    }

    private final func handleMeasureSituation() {
        guard let startValue = self.startPosition else {
            self.interact { (controller) in
                self.startPosition = controller.handler.sceneView.unprojectPoint(SCNVector3Zero)
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (_) in
                    guard let startValue = self.startPosition else {
                        return
                    }
                    self.interact({ (controller) in
                        let endValue = controller.handler.sceneView.unprojectPoint(SCNVector3Zero)
                        controller.handler.measurementLabel.text = "\(((endValue.distanceFromPos(pos: startValue) * 10000).rounded() / 100)) cm"
                    })
                })
            }
            return
        }
        self.interact { (controller) in
            let endValue = controller.handler.sceneView.unprojectPoint(SCNVector3Zero)
            controller.handler.resultButton.currentDistance = endValue.distanceFromPos(pos: startValue)
            controller.handler.resultButton.currentLine = (startValue, endValue)
            controller.handler.currentState = controller.handler.walkingState
        }
    }
    
    override internal final func appaerState() {
        print("ManualMeasureState")
        self.handleMeasureSituation()
    }
    
    override internal final func disappaerState() {
        self.startPosition = nil
        self.timer.invalidate()
    }
    
    override internal final func handleTouchesBegan(at point: CGPoint) {
        self.handleMeasureSituation()
    }
}
