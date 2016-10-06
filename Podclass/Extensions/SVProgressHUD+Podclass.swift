//
//  SVProgressHUD+Podclass.swift
//  Podclass
//
//  Created by Alan Scarpa on 10/6/16.
//  Copyright © 2016 Podclass. All rights reserved.
//

import Foundation
import SVProgressHUD

extension SVProgressHUD {
    static func defaultSetUp() {
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setBackgroundColor(UIColor.pcTransOrange())
        SVProgressHUD.setDefaultMaskType(.clear)
    }
}
