//
//  PCLesson.swift
//  Podclass
//
//  Created by Alan Scarpa on 3/26/16.
//  Copyright © 2016 Podclass. All rights reserved.
//

import Foundation

class PCLesson {
    
    var number = 0
    var title = ""
    
    convenience init(number: Int, title: String) {
        self.init()
        self.number = number
        self.title = title
    }
}