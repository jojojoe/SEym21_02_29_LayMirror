//
//  LyMmLayoutTypeManager.swift
//  LMymLayMirrorEff
//
//  Created by JOJO on 2021/7/15.
//

import Foundation
import UIKit



class LyMmLayoutTypeManager {
    
    static let `default` = LyMmLayoutTypeManager()
    
    func processLayoutFrames(canvasWidth: CGFloat, canvasHeight: CGFloat, layoutType: String) -> [CGRect] {
        if layoutType == "stitch_1" {
            let rect1 = CGRect(x: 0, y: 0, width: canvasWidth, height: canvasHeight)
            return [rect1]
        } else if layoutType == "stitch_2" {
            let rect1 = CGRect(x: 0, y: 0, width: canvasWidth/2, height: canvasHeight)
            let rect2 = CGRect(x: canvasWidth/2, y: 0, width: canvasWidth/2, height: canvasHeight)
            return [rect1, rect2]
        } else if layoutType == "stitch_3" {
            let rect1 = CGRect(x: 0, y: 0, width: canvasWidth, height: canvasHeight/2)
            let rect2 = CGRect(x: 0, y: canvasHeight/2, width: canvasWidth, height: canvasHeight/2)
            return [rect1, rect2]
        } else if layoutType == "stitch_4" {
            let rect1 = CGRect(x: 0, y: 0, width: canvasWidth, height: canvasHeight/3)
            let rect2 = CGRect(x: 0, y: canvasHeight/3, width: canvasWidth, height: canvasHeight*(2/3))
            return [rect1, rect2]
        } else if layoutType == "stitch_5" {
            let rect1 = CGRect(x: 0, y: 0, width: canvasWidth, height: canvasHeight*(2/3))
            let rect2 = CGRect(x: 0, y: canvasHeight*(2/3), width: canvasWidth, height: canvasHeight*(1/3))
            return [rect1, rect2]
        } else if layoutType == "stitch_6" {
            let rect1 = CGRect(x: 0, y: 0, width: canvasWidth/3, height: canvasHeight)
            let rect2 = CGRect(x: canvasWidth/3, y: 0, width: canvasWidth*(2/3), height: canvasHeight)
            return [rect1, rect2]
        } else if layoutType == "stitch_7" {
            let rect1 = CGRect(x: 0, y: 0, width: canvasWidth*(2/3), height: canvasHeight)
            let rect2 = CGRect(x: canvasWidth*(2/3), y: 0, width: canvasWidth*(1/3), height: canvasHeight)
            return [rect1, rect2]
        } else if layoutType == "stitch_8" {
            let rect1 = CGRect(x: 0, y: 0, width: canvasWidth/2, height: canvasHeight)
            let rect2 = CGRect(x: canvasWidth/2, y: 0, width: canvasWidth/2, height: canvasHeight/2)
            let rect3 = CGRect(x: canvasWidth/2, y: canvasHeight/2, width: canvasWidth/2, height: canvasHeight/2)
            return [rect1, rect2, rect3]
        } else if layoutType == "stitch_9" {
            let rect1 = CGRect(x: 0, y: 0, width: canvasWidth, height: canvasHeight/2)
            let rect2 = CGRect(x: 0, y: canvasHeight/2, width: canvasWidth/2, height: canvasHeight/2)
            let rect3 = CGRect(x: canvasWidth/2, y: canvasHeight/2, width: canvasWidth/2, height: canvasHeight/2)
            return [rect1, rect2, rect3]
        } else if layoutType == "stitch_10" {
            let rect1 = CGRect(x: 0, y: 0, width: canvasWidth/2, height: canvasHeight/2)
            let rect2 = CGRect(x: 0, y: canvasHeight/2, width: canvasWidth/2, height: canvasHeight/2)
            let rect3 = CGRect(x: canvasWidth/2, y: 0, width: canvasWidth/2, height: canvasHeight)
            return [rect1, rect2, rect3]
        } else if layoutType == "stitch_11" {
            let rect1 = CGRect(x: 0, y: 0, width: canvasWidth/2, height: canvasHeight/2)
            let rect2 = CGRect(x: canvasWidth/2, y: 0, width: canvasWidth/2, height: canvasHeight/2)
            let rect3 = CGRect(x: 0, y: canvasHeight/2, width: canvasWidth, height: canvasHeight/2)
            return [rect1, rect2, rect3]
        } else if layoutType == "stitch_12" {
            let rect1 = CGRect(x: 0, y: 0, width: canvasWidth*(2/3), height: canvasHeight/2)
            let rect2 = CGRect(x: 0, y: canvasHeight/2, width: canvasWidth*(2/3), height: canvasHeight/2)
            let rect3 = CGRect(x: canvasWidth*(2/3), y: 0, width: canvasWidth*(1/3), height: canvasHeight)
            return [rect1, rect2, rect3]
        } else if layoutType == "stitch_13" {
            let rect1 = CGRect(x: 0, y: 0, width: canvasWidth*(1/3), height: canvasHeight)
            let rect2 = CGRect(x: canvasWidth*(1/3), y: 0, width: canvasWidth*(2/3), height: canvasHeight/2)
            let rect3 = CGRect(x: canvasWidth*(1/3), y: canvasHeight/2, width: canvasWidth*(2/3), height: canvasHeight/2)
            return [rect1, rect2, rect3]
        } else if layoutType == "stitch_14" {
            let rect1 = CGRect(x: 0, y: 0, width: canvasWidth, height: canvasHeight*(1/3))
            let rect2 = CGRect(x: 0, y: canvasHeight*(1/3), width: canvasWidth*(1/2), height: canvasHeight*(2/3))
            let rect3 = CGRect(x: canvasWidth*(1/2), y: canvasHeight*(1/3), width: canvasWidth*(1/2), height: canvasHeight*(2/3))
            return [rect1, rect2, rect3]
        } else if layoutType == "stitch_15" {
            let rect1 = CGRect(x: 0, y: 0, width: canvasWidth*(1/2), height: canvasHeight*(2/3))
            let rect2 = CGRect(x: canvasWidth*(1/2), y: 0, width: canvasWidth*(1/2), height: canvasHeight*(2/3))
            let rect3 = CGRect(x: 0, y: canvasHeight*(2/3), width: canvasWidth, height: canvasHeight*(1/3))
            return [rect1, rect2, rect3]
        } else if layoutType == "stitch_16" {
            let rect1 = CGRect(x: 0, y: 0, width: canvasWidth*(1/3), height: canvasHeight)
            let rect2 = CGRect(x: canvasWidth*(1/3), y: 0, width: canvasWidth*(1/3), height: canvasHeight)
            let rect3 = CGRect(x: canvasWidth*(2/3), y: 0, width: canvasWidth*(1/3), height: canvasHeight)
            return [rect1, rect2, rect3]
        } else if layoutType == "stitch_17" {
            let rect1 = CGRect(x: 0, y: 0, width: canvasWidth, height: canvasHeight/3)
            let rect2 = CGRect(x: 0, y: canvasHeight/3, width: canvasWidth, height: canvasHeight*(1/3))
            let rect3 = CGRect(x: 0, y: canvasHeight*(2/3), width: canvasWidth, height: canvasHeight*(1/3))
            return [rect1, rect2, rect3]
        }
        return [CGRect.zero]
    }
    
}


