//
//  NavigationControllerDelegate.swift
//  Part
//
//  Created by Vladislav Brylinskiy on 09.05.16.
//  Copyright © 2016 void. All rights reserved.
//

import UIKit

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            guard let view = navigationController.viewsForScreens?[toVC] else { return nil }
            return PresentationController(presentationView: view)
        case .pop:
            guard let view = navigationController.viewsForScreens?[fromVC] else { return nil }
            navigationController.viewsForScreens?[fromVC] = nil
            return DismissalController(presentationView: view)
        default:
            return nil
        }
    }
}
