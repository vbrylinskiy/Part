//
//  UINavigationController+Extensions.swift
//  Part
//
//  Created by Vladislav Brylinskiy on 06.05.16.
//  Copyright © 2016 void. All rights reserved.
//

import UIKit
import ObjectiveC

private var key: UInt8 = 0

extension UINavigationController {
    
    var viewsForScreens: Dictionary<UIViewController, UIView>? {
        get {
            if let dict = objc_getAssociatedObject(self, &key) as? Dictionary<UIViewController, UIView> {
                return dict
            } else {
                let dict = Dictionary<UIViewController, UIView>()
                self.viewsForScreens = dict
                return dict
            }
        }
        
        set {
            objc_setAssociatedObject(self, &key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func pushViewController(_ viewController: UIViewController, fromView view: UIView, animated: Bool) {
        self.viewsForScreens?[viewController] = view
        self.pushViewController(viewController, animated: true)
    }
}
