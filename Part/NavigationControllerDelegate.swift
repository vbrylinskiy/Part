//
//  NavigationControllerDelegate.swift
//  Part
//
//  Created by Vladislav Brylinskiy on 09.05.16.
//  Copyright © 2016 void. All rights reserved.
//

import UIKit

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .Push:
            guard let view = navigationController.viewsForScreens?[toVC] else { return nil }
            return PresentationController(presentationView: view)
        case .Pop:
            guard let view = navigationController.viewsForScreens?[fromVC] else { return nil }
            navigationController.viewsForScreens?[fromVC] = nil
            return DismissalController(presentationView: view)
        default:
            return nil
        }
    }
}