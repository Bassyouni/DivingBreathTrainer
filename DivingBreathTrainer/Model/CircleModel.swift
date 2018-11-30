//
//  CircleModel.swift
//  DivingBreathTrainer
//
//  Created by MacBook Pro on 11/30/18.
//  Copyright © 2018 Bassyouni. All rights reserved.
//

import UIKit

class CircleModel
{
    // this function to create the circle
    class func createTrackLayer(strokeColor: UIColor , fillColor: UIColor) -> CAShapeLayer {
    let Layer = CAShapeLayer()
    //Circle it self
    let circularPath = UIBezierPath(arcCenter: .zero, radius: 120, startAngle:  0, endAngle: 2 * CGFloat.pi , clockwise: true)
    Layer.path = circularPath.cgPath
    
    //a line or border layer on the cirlce
    Layer.strokeColor = strokeColor.cgColor
    Layer.lineWidth = 15
    
    //This is for the color of the circle it self
    Layer.fillColor = fillColor.cgColor
    
    
    //to make the stroke has a nice round look to it
    Layer.lineCap = CAShapeLayerLineCap.round
    
    //to put the circle in the center
//        Layer.position = myView.center
    
    return Layer
}
    
    class func pauseLayer(layer : CALayer) {
    let pausedTime : CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
    layer.speed = 0.0
    layer.timeOffset = pausedTime
    
}
    
    class func animateStroke(duration: CFTimeInterval) -> CABasicAnimation {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1.0
        basicAnimation.duration = duration
        basicAnimation.repeatCount = 1
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        return basicAnimation
    }
    
}
