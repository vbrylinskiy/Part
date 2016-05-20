//
//  ViewController2.swift
//  Part
//
//  Created by Vladislav Brylinskiy on 20.05.16.
//  Copyright © 2016 void. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    @IBAction func push(sender: UIView) {
        let vc: UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ViewController1")
        
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
}
