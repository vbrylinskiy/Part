//
//  PresentationController.swift
//  Part
//
//  Created by Vladislav Brylinskiy on 28.04.16.
//  Copyright © 2016 void. All rights reserved.
//

import UIKit

class PresentationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let fromView: UIView
    
    init(presentationView view: UIView) {
        self.fromView = view
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toView = transitionContext.viewForKey(UITransitionContextToViewKey) else {
            return
        }
        
        toView.updateConstraints()
        
        guard let containerView = transitionContext.containerView() else {
            return
        }
        
        let n = 30
        

        var toImage: UIImage
        
        UIGraphicsBeginImageContextWithOptions(toView.bounds.size, toView.opaque, 0.0)
        toView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        toImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var dx = toView.frame.size.width / CGFloat(n)
        var dy = toView.frame.size.height / CGFloat(n)

        var finalImages:[[UIImage]] = [[UIImage]](count:n, repeatedValue:[UIImage](count: n, repeatedValue:UIImage()))
        var frames:[[CGRect]] = [[CGRect]](count:n, repeatedValue:[CGRect](count: n, repeatedValue:CGRectZero))
        for i in 0..<n {
            for j in 0..<n {
                frames[i][j] = CGRect(origin: CGPoint(x: dx * CGFloat(j), y: dy * CGFloat(i)), size: CGSize(width: dx, height: dy))
                finalImages[i][j] = UIImage(CGImage:CGImageCreateWithImageInRect(toImage.CGImage, frames[i][j])!)
            }
        }
        
        var arr:[[UIView]] = [[UIView]](count:n, repeatedValue:[UIView](count: n, repeatedValue:UIView()))
        
        dx = fromView.frame.size.width / CGFloat(n)
        dy = fromView.frame.size.height / CGFloat(n)
        let spx = fromView.frame.origin.x
        let spy = fromView.frame.origin.y
        
        var viewImage: UIImage
        
        UIGraphicsBeginImageContextWithOptions(fromView.bounds.size, fromView.opaque, 0.0)
        fromView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.fromView.hidden = true
        
        for i in 0..<n {
            for j in 0..<n {
                let frame = CGRect(origin: CGPoint(x: spx + dx * CGFloat(j), y: spy + dy * CGFloat(i)), size: CGSize(width: dx, height: dy))
                let frame2 = CGRect(origin: CGPoint(x: dx * CGFloat(j), y:dy * CGFloat(i)), size: CGSize(width: dx, height: dy))
                
                let part = UIView(frame: frame)
                
                let imageRef: CGImage? = CGImageCreateWithImageInRect(viewImage.CGImage, frame2)
                
                guard let image = imageRef else {
                    continue
                }
                
                let cropImage = UIImage(CGImage: image)
                
                part.layer.contents = cropImage.CGImage!
                
                arr[i][j] = part
            }
        }

        for i in 0..<n {
            for j in 0..<n {
                containerView.addSubview(arr[i][j])
            }
        }
                
//        let gr = dispatch_group_create()
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            for i in 0..<n {
                for j in 0..<n {
                    arr[i][j].removeFromSuperview()
                }
            }
            
            containerView.addSubview(toView)
            transitionContext.completeTransition(true)
        })
        
        var x = 0
        for _ in 0..<n {
            var i = x
            var j = 0
//            dispatch_group_enter(gr)
//            UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: Double(x) * self.transitionDuration(transitionContext) / (Double(n)+Double(n)-1), options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                while i >= 0 && j < n {
//                    UIView.transitionWithView(arr[i][j],
//                        duration:self.transitionDuration(transitionContext),
//                        options: UIViewAnimationOptions.TransitionCrossDissolve,
//                        animations: {
//                            arr[i][j].image = finalImages[i][j]
//                        },
//                        completion: nil)

                    let layer = arr[i][j].layer
                    
                    let fadeAnim:CABasicAnimation = CABasicAnimation(keyPath: "contents")
                    fadeAnim.beginTime = CACurrentMediaTime() + Double(x) * self.transitionDuration(transitionContext) / (Double(n)+Double(n)-1)
                    fadeAnim.fromValue = layer.contents
                    fadeAnim.fillMode = kCAFillModeForwards;
                    fadeAnim.removedOnCompletion = false;
                    fadeAnim.toValue = finalImages[i][j].CGImage!
                    fadeAnim.duration = self.transitionDuration(transitionContext)
//                    layer.contents = finalImages[i][j].CGImage!
                    
                    let frame = frames[i][j]
                    
                    let changeFrameAnim:CABasicAnimation = CABasicAnimation(keyPath: "position")
                    changeFrameAnim.fillMode = kCAFillModeForwards;
                    changeFrameAnim.removedOnCompletion = false;
                    changeFrameAnim.beginTime = CACurrentMediaTime() + Double(x) * self.transitionDuration(transitionContext) / (Double(n)+Double(n)-1)
                    changeFrameAnim.fromValue = NSValue(CGPoint: layer.position)
                    changeFrameAnim.toValue = NSValue(CGPoint: CGPoint(x: frame.origin.x + frame.size.width * 0.5, y: frame.origin.y + frame.size.height * 0.5))
                    changeFrameAnim.duration = self.transitionDuration(transitionContext)
//                    layer.position = frame.origin
                    
                    let changeBoundsAnim:CABasicAnimation = CABasicAnimation(keyPath: "bounds")
                    changeBoundsAnim.fillMode = kCAFillModeForwards;
                    changeBoundsAnim.removedOnCompletion = false;
                    changeBoundsAnim.beginTime = CACurrentMediaTime() + Double(x) * self.transitionDuration(transitionContext) / (Double(n)+Double(n)-1)
                    changeBoundsAnim.fromValue = NSValue(CGRect: layer.bounds)
                    changeBoundsAnim.toValue = NSValue(CGRect: CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height))
                    changeBoundsAnim.duration = self.transitionDuration(transitionContext)
//                    layer.bounds = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
                    
                    layer.addAnimation(fadeAnim, forKey: "contents")
                    layer.addAnimation(changeFrameAnim, forKey: "position")
                    layer.addAnimation(changeBoundsAnim, forKey: "bounds")
                    
//                    [arr[i][j].layer addani]

//                    arr[i][j].frame = frame

                    i-=1
                    j+=1
                }
//            }) { completion in
//                dispatch_group_leave(gr)
//            }
            x += 1
        }
        
        for y in 1..<n {
            var i = x-1
            var j = y
//            dispatch_group_enter(gr)
//            UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: Double(x+y) * self.transitionDuration(transitionContext) / (Double(n)+Double(n)-1), options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                while i >= 0 && j < n {
                    
//                    arr[i][j].layer.addAnimation(CATransition(), forKey: kCATransition)
//                    arr[i][j].image = finalImages[i][j]
                    
                    let layer = arr[i][j].layer
                    
                    let fadeAnim:CABasicAnimation = CABasicAnimation(keyPath: "contents")
                    fadeAnim.fillMode = kCAFillModeForwards;
                    fadeAnim.removedOnCompletion = false;
                    fadeAnim.beginTime = CACurrentMediaTime() + Double(x+y) * self.transitionDuration(transitionContext) / (Double(n)+Double(n)-1)
                    fadeAnim.fromValue = layer.contents
                    fadeAnim.toValue = finalImages[i][j].CGImage!
                    fadeAnim.duration = self.transitionDuration(transitionContext)
//                    layer.contents = finalImages[i][j].CGImage!
                    
                    let frame = frames[i][j]
                    
                    let changeFrameAnim:CABasicAnimation = CABasicAnimation(keyPath: "position")
                    changeFrameAnim.fillMode = kCAFillModeForwards;
                    changeFrameAnim.removedOnCompletion = false;
                    changeFrameAnim.beginTime = CACurrentMediaTime() + Double(x+y) * self.transitionDuration(transitionContext) / (Double(n)+Double(n)-1)
                    changeFrameAnim.fromValue = NSValue(CGPoint: layer.position)
                    changeFrameAnim.toValue = NSValue(CGPoint: CGPoint(x: frame.origin.x + frame.size.width * 0.5, y: frame.origin.y + frame.size.height * 0.5))
                    changeFrameAnim.duration = self.transitionDuration(transitionContext)
//                    layer.position = frame.origin
                    
                    let changeBoundsAnim:CABasicAnimation = CABasicAnimation(keyPath: "bounds")
                    changeBoundsAnim.fillMode = kCAFillModeForwards;
                    changeBoundsAnim.removedOnCompletion = false;
                    changeBoundsAnim.beginTime = CACurrentMediaTime() + Double(x+y) * self.transitionDuration(transitionContext) / (Double(n)+Double(n)-1)
                    changeBoundsAnim.fromValue = NSValue(CGRect: layer.bounds)
                    changeBoundsAnim.toValue = NSValue(CGRect: CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height))
                    changeBoundsAnim.duration = self.transitionDuration(transitionContext)
//                    layer.bounds = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
                    
                    layer.addAnimation(fadeAnim, forKey: "contents")
                    layer.addAnimation(changeFrameAnim, forKey: "position")
                    layer.addAnimation(changeBoundsAnim, forKey: "bounds")
                    
                    i-=1
                    j+=1
                }
//            }) { completion in
//                dispatch_group_leave(gr)
//            }
        }
        
        CATransaction.commit()
        
//        dispatch_group_notify(gr, dispatch_get_main_queue()) {
//        }
        
    }
}
