//
//  UIViewController+Podclass.swift
//  Podclass
//
//  Created by Alan Scarpa on 3/22/16.
//  Copyright © 2016 Podclass. All rights reserved.
//

import UIKit

extension UIViewController {
    
    class func initWithDefaultNib() -> Self {
        return self.init(nibName: nibName(), bundle: nil)
    }
    
    class func nibName() -> String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
    
}