//
//  UIView+ViewTransition.swift
//  Part
//
//  Created by Vladislav Brylinskiy on 09.05.16.
//  Copyright © 2016 void. All rights reserved.
//

import UIKit

extension UIView {
    func convertSubview(fromView: UIView, intoView: UIView) {
        guard fromView.superview?.isEqual(self) ?? false else { return }
        
//        let startFrame = fromView.frame
//        let finalFrame = intoView.frame
//        
//        fromView.frame = finalFrame
        
    }
}
