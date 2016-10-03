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
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    var isVisible: Bool{
        return self.isViewLoaded && view.window != nil
    }
    
    public static func ip_fromNib() -> Self {
        let controller = self.init(nibName: ip_nibName, bundle: nil)
        return controller
    }
    
    public static var ip_nibName: String {
        return "\(self)".components(separatedBy: ".").last!
    }
}
