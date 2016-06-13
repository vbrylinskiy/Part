//
//  DismissalController.swift
//  Part
//
//  Created by Vladislav Brylinskiy on 28.04.16.
//  Copyright © 2016 void. All rights reserved.
//

import UIKit

class DismissalController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let presentationView: UIView
    
    init(presentationView view: UIView) {
        self.presentationView = view
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) else {
            return
        }
        
        guard let toView = transitionContext.viewForKey(UITransitionContextToViewKey) else {
            return
        }
        
        guard let containerView = transitionContext.containerView() else {
            return
        }
        
        containerView.addSubview(toView)
        
        let animationController = AnimationController(fromView: fromView,
                                                      toView: self.presentationView,
                                                      containerView: containerView,
                                                      transitionDuration: self.transitionDuration(transitionContext))
        
        animationController.animateTransitionWithCompletion {
            self.presentationView.hidden = false
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
