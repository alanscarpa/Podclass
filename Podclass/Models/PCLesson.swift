//
//  PCLesson.swift
//  Podclass
//
//  Created by Alan Scarpa on 3/26/16.
//  Copyright © 2016 Podclass. All rights reserved.
//

import Foundation

class PCLesson {
    
    let URLPrefix = "https://drive.google.com/uc?export=download&id="
    
    var number = 0
    var title = ""
    var isPlaying = false
    var trackID = ""
    var trackURLString: String {
        get {
            return URLPrefix+self.trackID
        }
    }
    var index: Int {
        get {
            return Int(number) - 1
        }
    }
    
    var indexPath = NSIndexPath()
    
    convenience init(number: Int, title: String) {
        self.init()
        self.number = number
        self.title = title
        self.trackID = ""
    }
}