//
//  PresentationController.swift
//  Part
//
//  Created by Vladislav Brylinskiy on 28.04.16.
//  Copyright © 2016 void. All rights reserved.
//

import UIKit

class PresentationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let presentationView: UIView
    var animationController: GLAnimationConroller!
    
    init(presentationView view: UIView) {
        self.presentationView = view
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2.0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }
        
        let containerView = transitionContext.containerView
        
        self.animationController = GLAnimationConroller(fromView: self.presentationView,
                                                         toView: toView,
                                                         containerView: containerView,
                                                         transitionDuration: self.transitionDuration(using: transitionContext))
        
        animationController.animateTransitionWithCompletion {
            containerView.addSubview(toView)
            transitionContext.completeTransition(true)
        }
        
    }
}
