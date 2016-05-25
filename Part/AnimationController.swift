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
    
    func animateTransitionWithCompletion (completion: (Void -> Void)) {
        let n = 20
        
        var toImage: UIImage
        
        let wasHidden = toView.hidden
        
        if (wasHidden) {
            toView.hidden = false
        }
        
        UIGraphicsBeginImageContextWithOptions(toView.bounds.size, toView.opaque, 0.0)
        toView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        toImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (wasHidden) {
            toView.hidden = true
        }
        
        var dx = toView.frame.size.width / CGFloat(n)
        var dy = toView.frame.size.height / CGFloat(n)
        
        var spx = toView.frame.origin.x
        var spy = toView.frame.origin.y
        
        var finalImages:[[UIImage]] = [[UIImage]](count:n, repeatedValue:[UIImage](count: n, repeatedValue:UIImage()))
        var finalFrames:[[CGRect]] = [[CGRect]](count:n, repeatedValue:[CGRect](count: n, repeatedValue:CGRectZero))
        for i in 0..<n {
            for j in 0..<n {
                finalFrames[i][j] = CGRect(origin: CGPoint(x:spx + dx * CGFloat(j), y: spy + dy * CGFloat(i)), size: CGSize(width: dx, height: dy))
                finalImages[i][j] = UIImage(CGImage:CGImageCreateWithImageInRect(toImage.CGImage, CGRect(x: dx * CGFloat(j), y: dy * CGFloat(i), width: dx, height: dy))!)
            }
        }
        
        
        dx = fromView.frame.size.width / CGFloat(n)
        dy = fromView.frame.size.height / CGFloat(n)
        spx = fromView.frame.origin.x
        spy = fromView.frame.origin.y
        
        var viewImage: UIImage
        
        UIGraphicsBeginImageContextWithOptions(fromView.bounds.size, fromView.opaque, 0.0)
        fromView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        fromView.hidden = true
        
        var initialParts:[[UIView]] = [[UIView]](count:n, repeatedValue:[UIView](count: n, repeatedValue:UIView()))
        
        for i in 0..<n {
            for j in 0..<n {
                let initialFrame = CGRect(origin: CGPoint(x: spx + dx * CGFloat(j), y: spy + dy * CGFloat(i)), size: CGSize(width: dx, height: dy))
                
                let part = UIView(frame: initialFrame)
                
                let imageRef = CGImageCreateWithImageInRect(viewImage.CGImage, CGRect(x: dx * CGFloat(j), y: dy * CGFloat(i), width: dx, height: dy))
                
                guard let image = imageRef else {
                    continue
                }
                
                let cropImage = UIImage(CGImage: image)
                
                part.layer.contents = cropImage.CGImage!
                
                initialParts[i][j] = part
            }
        }
        
        for i in 0..<n {
            for j in 0..<n {
                containerView.addSubview(initialParts[i][j])
            }
        }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            for i in 0..<n {
                for j in 0..<n {
                    initialParts[i][j].removeFromSuperview()
                }
            }
            
            completion()
        })
        
        for i in 0..<n {
            for j in 0..<n {
                let layer = initialParts[i][j].layer
                let animationStartTime = CACurrentMediaTime() + Double(i+j) * transitionDuration / (Double(n)+Double(n)-1)
                let frame = finalFrames[i][j]
                
                let fadeAnim:CABasicAnimation = CABasicAnimation(keyPath: "contents")
                fadeAnim.beginTime = animationStartTime
                fadeAnim.fromValue = layer.contents
                fadeAnim.fillMode = kCAFillModeForwards;
                fadeAnim.removedOnCompletion = false;
                fadeAnim.toValue = finalImages[i][j].CGImage!
                fadeAnim.duration = transitionDuration
                
                let changeFrameAnim:CABasicAnimation = CABasicAnimation(keyPath: "position")
                changeFrameAnim.fillMode = kCAFillModeForwards;
                changeFrameAnim.removedOnCompletion = false;
                changeFrameAnim.beginTime = animationStartTime
                changeFrameAnim.fromValue = NSValue(CGPoint: layer.position)
                changeFrameAnim.toValue = NSValue(CGPoint: CGPoint(x: frame.origin.x + frame.size.width * 0.5, y: frame.origin.y + frame.size.height * 0.5))
                changeFrameAnim.duration = transitionDuration
                
                let changeBoundsAnim:CABasicAnimation = CABasicAnimation(keyPath: "bounds")
                changeBoundsAnim.fillMode = kCAFillModeForwards;
                changeBoundsAnim.removedOnCompletion = false;
                changeBoundsAnim.beginTime = animationStartTime
                changeBoundsAnim.fromValue = NSValue(CGRect: layer.bounds)
                changeBoundsAnim.toValue = NSValue(CGRect: CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height))
                changeBoundsAnim.duration = transitionDuration
                
                layer.addAnimation(fadeAnim, forKey: "contents")
                layer.addAnimation(changeFrameAnim, forKey: "position")
                layer.addAnimation(changeBoundsAnim, forKey: "bounds")
            }
        }
        
        CATransaction.commit()
    }
}
