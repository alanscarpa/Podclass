//
//  UIView+Podclass.swift
//  Podclass
//
//  Created by Alan Scarpa on 3/20/16.
//  Copyright © 2016 Podclass. All rights reserved.
//

import UIKit

extension UIView {
    func setBottomBorderWithColor(color: CGColor, width: CGFloat) {
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = color
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func setTopBorderWithColor(color: CGColor, width: CGFloat) {
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = color
        border.frame = CGRect(x: 0, y: 0, width:  self.frame.size.width, height: width)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}