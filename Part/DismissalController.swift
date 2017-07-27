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
    var animationController: AnimationController!

    init(presentationView view: UIView) {
        self.presentationView = view
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }
        
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }
        
        let containerView = transitionContext.containerView 
        
        containerView.addSubview(toView)
        
        self.animationController = AnimationController(fromView: fromView,
                                                      toView: self.presentationView,
                                                      containerView: containerView,
                                                      transitionDuration: self.transitionDuration(using: transitionContext))
        
        animationController.animateTransitionWithCompletion {
            self.presentationView.isHidden = false
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
