//
//  AnimationController.swift
//  Part
//
//  Created by Vladislav Brylinskiy on 24.05.16.
//  Copyright © 2016 void. All rights reserved.
//

import UIKit

class AnimationController: NSObject {
    let fromView: UIView
    let toView: UIView
    let containerView: UIView
    let transitionDuration: Double
    
    init(fromView: UIView, toView: UIView, containerView: UIView, transitionDuration: Double) {
        self.fromView = fromView
        self.toView = toView
        self.containerView = containerView
        self.transitionDuration = transitionDuration
        
        super.init()
    }
    
    func animateTransitionWithCompletion (_ completion: @escaping ((Void) -> Void)) {
        let n = 10
        
        var toImage: UIImage
        
        let wasHidden = toView.isHidden
        
        if (wasHidden) {
            toView.isHidden = false
        }
        
        UIGraphicsBeginImageContextWithOptions(toView.bounds.size, toView.isOpaque, 1.0)
        toView.layer.render(in: UIGraphicsGetCurrentContext()!)
        toImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        if (wasHidden) {
            toView.isHidden = true
        }
        
        var dx = toView.frame.size.width / CGFloat(n)
        var dy = toView.frame.size.height / CGFloat(n)
        
        var spx = toView.frame.origin.x
        var spy = toView.frame.origin.y
        
        var finalImages:[[UIImage]] = [[UIImage]](repeating: [UIImage](repeating: UIImage(), count: n), count: n)
        var finalFrames:[[CGRect]] = [[CGRect]](repeating: [CGRect](repeating: CGRect.zero, count: n), count: n)
        for i in 0..<n {
            for j in 0..<n {
                finalFrames[i][j] = CGRect(origin: CGPoint(x:spx + dx * CGFloat(j), y: spy + dy * CGFloat(i)), size: CGSize(width: dx, height: dy))
                finalImages[i][j] = UIImage(cgImage:(toImage.cgImage?.cropping(to: CGRect(x: dx * CGFloat(j), y: dy * CGFloat(i), width: dx, height: dy))!)!)
            }
        }
        
        
        dx = fromView.frame.size.width / CGFloat(n)
        dy = fromView.frame.size.height / CGFloat(n)
        spx = fromView.frame.origin.x
        spy = fromView.frame.origin.y
        
        var viewImage: UIImage
        
        UIGraphicsBeginImageContextWithOptions(fromView.bounds.size, fromView.isOpaque, 1.0)
        fromView.layer.render(in: UIGraphicsGetCurrentContext()!)
        viewImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        fromView.isHidden = true
        
        var initialParts:[[CALayer]] = [[CALayer]](repeating: [CALayer](repeating: CALayer(), count: n), count: n)
        
        for i in 0..<n {
            for j in 0..<n {
                let initialFrame = CGRect(origin: CGPoint(x: spx + dx * CGFloat(j), y: spy + dy * CGFloat(i)), size: CGSize(width: dx, height: dy))
                
                let part = CALayer()
                part.frame = initialFrame
                
                let imageRef = viewImage.cgImage?.cropping(to: CGRect(x: dx * CGFloat(j), y: dy * CGFloat(i), width: dx, height: dy))
                
                guard let image = imageRef else {
                    continue
                }
                
                let cropImage = UIImage(cgImage: image)
                
                part.contents = cropImage.cgImage!
                
                initialParts[i][j] = part
            }
        }
        
        for i in 0..<n {
            for j in 0..<n {
                containerView.layer.addSublayer(initialParts[i][j])
            }
        }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            for i in 0..<n {
                for j in 0..<n {
                    initialParts[i][j].removeFromSuperlayer()
                }
            }
            
            completion()
        })
        
        for i in 0..<n {
            for j in 0..<n {
                let layer = initialParts[i][j]
                let animationStartTime = CACurrentMediaTime() + Double(i+j) * transitionDuration / (Double(n)+Double(n)-1)
                let frame = finalFrames[i][j]
                
                let fadeAnim:CABasicAnimation = CABasicAnimation(keyPath: "contents")
                fadeAnim.beginTime = animationStartTime
                fadeAnim.fromValue = layer.contents
                fadeAnim.fillMode = kCAFillModeForwards;
                fadeAnim.isRemovedOnCompletion = false;
                fadeAnim.toValue = finalImages[i][j].cgImage!
                fadeAnim.duration = transitionDuration
                
                let changeFrameAnim:CABasicAnimation = CABasicAnimation(keyPath: "position")
                changeFrameAnim.fillMode = kCAFillModeForwards;
                changeFrameAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                changeFrameAnim.isRemovedOnCompletion = false;
                changeFrameAnim.beginTime = animationStartTime
                changeFrameAnim.fromValue = NSValue(cgPoint: layer.position)
                changeFrameAnim.toValue = NSValue(cgPoint: CGPoint(x: frame.origin.x + frame.size.width * 0.5, y: frame.origin.y + frame.size.height * 0.5))
                changeFrameAnim.duration = transitionDuration
                
                let changeBoundsAnim:CABasicAnimation = CABasicAnimation(keyPath: "bounds")
                changeBoundsAnim.fillMode = kCAFillModeForwards;
                changeBoundsAnim.isRemovedOnCompletion = false;
                changeBoundsAnim.beginTime = animationStartTime
                changeBoundsAnim.fromValue = NSValue(cgRect: layer.bounds)
                changeBoundsAnim.toValue = NSValue(cgRect: CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height))
                changeBoundsAnim.duration = transitionDuration
                
                layer.add(fadeAnim, forKey: "contents")
                layer.add(changeFrameAnim, forKey: "position")
                layer.add(changeBoundsAnim, forKey: "bounds")
            }
        }
        
        CATransaction.commit()
    }
}
