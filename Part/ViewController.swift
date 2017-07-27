//
//  ViewController.swift
//  Part
//
//  Created by Vladislav Brylinskiy on 25.04.16.
//  Copyright © 2016 void. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var test2View: UIView!
//    var viewImage: UIImage!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var imageView: UIImageView!
        
    var arr = Array<UIView>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        imageView.image = UIImage(named: "PNG_transparency_demonstration_1")
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
//            self.imageView.image = UIImage(named: "water_PNG3290")
//            
//            let transition = CATransition()
//            transition.duration = 1.0
//            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)//[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            transition.type = kCATransitionFade
//            
//            //        [imageView.layer addAnimation:transition forKey:nil];
//            self.imageView.layer.addAnimation(transition, forKey: nil)
//        }
        
//        let gradient: CAGradientLayer = CAGradientLayer()
//        gradient.frame = self.testView.bounds
//        gradient.colors = [UIColor.lightGrayColor().CGColor, UIColor.blackColor().CGColor]
//        self.testView.layer.insertSublayer(gradient, atIndex: 0)
        
//        UIGraphicsBeginImageContextWithOptions(self.testView.bounds.size, self.testView.opaque, 0.0)
//        self.testView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
//        self.viewImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        
////        self.cropViewIntoParts()
//        
//        let n = 50
//        
//        let dx = testView.frame.size.width / CGFloat(n)
//        let dy = testView.frame.size.height / CGFloat(n)
//        
//        let spx = testView.frame.origin.x;
//        let spy = testView.frame.origin.y;
//        
//        for i in 0..<n {
//            for j in 0..<n {
//                let frame = CGRect(origin: CGPoint(x: spx + dx * CGFloat(i), y: spy + dy * CGFloat(j)), size: CGSize(width: dx, height: dy))
//                let frame2 = CGRect(origin: CGPoint(x: dx * CGFloat(i), y:dy * CGFloat(j)), size: CGSize(width: dx, height: dy))
//                
//                let part = UIView(frame: frame)
//                
//                let imageRef: CGImage? = CGImageCreateWithImageInRect(self.viewImage.CGImage, frame2)
//                
//                guard let image = imageRef else {
//                    continue
//                }
//                
//                let cropImage = UIImage(CGImage: image)
//                
//                part.backgroundColor = UIColor(patternImage: cropImage)
//                
//                arr.append(part)
////                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(j+i) * (Double(NSEC_PER_SEC)/100))), dispatch_get_main_queue()) { () -> Void in
//                self.view.addSubview(part)
////                }
//                
//                UIView.animateWithDuration(1, delay: Double(j+i*10)/500, options: [], animations: {
//                    part.frame.origin.x += (self.test2View.frame.origin.x - self.testView.frame.origin.x)
//                    part.frame.origin.y += (self.test2View.frame.origin.y - self.testView.frame.origin.y)
//                    part.frame.size.width *= (self.test2View.frame.width / self.testView.frame.width)
//                    part.frame.size.height *= (self.test2View.frame.height / self.testView.frame.height)
//                    }, completion: nil)
//            }
//        }
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
//            self.testView.hidden = true;
//        }
        
    }
    
//    func cropViewIntoParts() {
//        
//    }
    
    @IBAction func push(_ sender: UIView) {
        let vc: UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController")
        
        self.navigationController?.pushViewController(vc, fromView: sender, animated: true)
//        self.navigationController?.pushViewController(vc, animated: true)
//        vc.transitioningDelegate = self
//        vc.modalPresentationStyle = UIModalPresentationStyle.FullScreen
//        vc.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
//        
//        self.presentViewController(vc, animated: true, completion: nil)
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
////            vc.dismissViewControllerAnimated(true, completion: nil)
//            self.navigationController?.popViewControllerAnimated(true)
//        }
    }
    
//    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return PresentationController()
//    }
//    
//    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return DismissalController()
//    }
    
    
}

