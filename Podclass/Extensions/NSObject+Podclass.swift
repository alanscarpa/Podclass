//
//  NSObject+Podclass.swift
//  Podclass
//
//  Created by Alan Scarpa on 3/20/16.
//  Copyright © 2016 Podclass. All rights reserved.
//

import Foundation

extension NSObject {
    class func className() -> String {
        return NSStringFromClass(self as AnyClass).componentsSeparatedByString(".").last!
    }
    
}