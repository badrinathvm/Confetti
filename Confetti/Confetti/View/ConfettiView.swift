//
//  ConfettiView.swift
//  Confetti
//
//  Created by Badrinath on 9/1/19.
//  Copyright © 2019 Badrinath. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

enum ConfettiType {
    case confetti
    case triangle
    case star
    case diamond
    case image(UIImage)
}

private let kAnimationLayerKey = "com.confetti.animationLayer"

class ConfettiView : UIView {
    
    var emitter: CAEmitterLayer!
    var colors:[UIColor]!
    var type: ConfettiType!
    var intensity: Float!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        colors = [UIColor(red:0.95, green:0.40, blue:0.27, alpha:1.0),
                  UIColor(red:1.00, green:0.78, blue:0.36, alpha:1.0),
                  UIColor(red:0.48, green:0.78, blue:0.64, alpha:1.0),
                  UIColor(red:0.30, green:0.76, blue:0.85, alpha:1.0),
                  UIColor(red:0.58, green:0.39, blue:0.55, alpha:1.0)]
        
        type = ConfettiType.confetti
        intensity = 0.5
    }
    
    ///creates a keyframe animation to taper the birthRate property down to 0 over the specified duration.
    fileprivate func keyFrameAnimation() {
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CAEmitterLayer.birthRate))
        animation.duration = 10.0
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation.fillMode = .backwards
        animation.values = [1, 0, 0]
        animation.keyTimes = [0, 0.5, 1]
        animation.isRemovedOnCompletion = false
        
        layer.beginTime = CACurrentMediaTime()
        emitter.birthRate = 1.0
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            let transition = CATransition()
            transition.delegate = self
            transition.type = .push
            transition.duration = 1
            transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
            transition.setValue(self.emitter, forKey: kAnimationLayerKey)
            transition.isRemovedOnCompletion = false
            
            self.emitter.add(transition, forKey: nil)
            
            self.emitter.opacity = 0
        }
        layer.add(animation, forKey: nil)
        CATransaction.commit()
    }
    
    func startConfetti() {
        //A layer that emits, animates, and renders a particle system.
        emitter = CAEmitterLayer()
        
        emitter.emitterPosition = CGPoint(x: frame.size.width / 2.0, y: 0)
        emitter.emitterShape = CAEmitterLayerEmitterShape.line
        emitter.emitterSize = CGSize(width: frame.size.width, height: 1)
        
        //construct the cells
        var cells = [CAEmitterCell]()
        for color in colors {
            cells.append(confettiWithColor(color: color))
        }
        
        keyFrameAnimation()
        
        emitter.emitterCells = cells
        layer.addSublayer(emitter)
    }
    
    func stopConfetti() {
        emitter?.birthRate = 0
    }
    
    func confettiWithColor(color: UIColor) -> CAEmitterCell {
        let confetti = CAEmitterCell()
        
//        //The number of particles created every second.
        //confetti.birthRate = 2.0
//
//        //The lifetime of the cell, in seconds.
//        confetti.lifetime = 14.0 * intensity
//        confetti.lifetimeRange = 0.0
//
//        confetti.color = color.cgColor
//
        //confetti.velocity = CGFloat(350.0 * intensity)
        //confetti.velocityRange = CGFloat(80.0 * intensity)

//        //The longitudinal orientation of the emission angle
        //confetti.emissionLongitude = CGFloat(Double.pi)
        //confetti.emissionRange = CGFloat(Double.pi)
//
//        //The rotational velocity, measured in radians per second, to apply to the cell.
        //confetti.spin = CGFloat(3.5 * intensity)
        //confetti.spinRange = CGFloat(4.0 * intensity)
//
//        //Specifies the range over which the scale value can vary
        //confetti.scaleRange = CGFloat(intensity)
        //confetti.scaleSpeed = CGFloat(-0.1 * intensity)
//
    
        confetti.birthRate = 50.0
        confetti.color = color.cgColor
        confetti.lifetime = 10.0
        confetti.velocity = CGFloat(confetti.birthRate * confetti.lifetime)
        confetti.velocityRange = confetti.velocity / 2
        confetti.emissionLongitude = .pi
        confetti.emissionRange = .pi / 4
        confetti.spinRange = .pi * 8
        confetti.scaleRange = 0.25
        confetti.scale = 1.0 - confetti.scaleRange
        confetti.contents = imageForType(type: type)?.cgImage
 
        return confetti
    }
    
    func imageForType(type: ConfettiType) -> UIImage? {
        
        var fileName: String!
        
        switch type {
        case .confetti:
            fileName = "confetti"
        case .triangle:
            fileName = "triangle"
        case .star:
            fileName = "star"
        case .diamond:
            fileName = "diamond"
        case let .image(customImage):
            return customImage
        }
        
        let imagePath = Bundle.main.path(forResource: fileName, ofType: "png")
        let url = URL(fileURLWithPath: imagePath!)
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            print(error)
        }
        return nil
    }
}

// MARK: - CAAnimationDelegate
extension ConfettiView: CAAnimationDelegate {
    public func animationDidStop(_ animation: CAAnimation, finished flag: Bool) {
        if let layer = animation.value(forKey: kAnimationLayerKey) as? CALayer {
            layer.removeAllAnimations()
            layer.removeFromSuperlayer()
        }
    }
}
