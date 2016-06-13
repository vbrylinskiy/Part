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
    
    init(presentationView view: UIView) {
        self.presentationView = view
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.0
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toView = transitionContext.viewForKey(UITransitionContextToViewKey) else {
            return
        }
        
        guard let containerView = transitionContext.containerView() else {
            return
        }
        
        toView.updateConstraints()
        
        let animationController = AnimationController(fromView: self.presentationView,
                                                      toView: toView,
                                                      containerView: containerView,
                                                      transitionDuration: self.transitionDuration(transitionContext))
        
        animationController.animateTransitionWithCompletion {
            containerView.addSubview(toView)
            transitionContext.completeTransition(true)
        }
        
    }
}
