//
//  Defaults.swift
//  Podclass
//
//  Created by Alan Scarpa on 11/20/16.
//  Copyright © 2016 Podclass. All rights reserved.
//

import Foundation

class Defaults {
    
    static let appDidFinishInitialLaunchKey = "appDidFinishInitialLaunch"
    
    static var appDidFinishInitialLaunch: Bool {
        return UserDefaults.standard.bool(forKey: appDidFinishInitialLaunchKey)
    }
    
    static func setAppDidFinishInitialLaunch() {
        UserDefaults.standard.set(true, forKey: appDidFinishInitialLaunchKey)
    }
    
}
