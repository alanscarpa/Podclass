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
    var streamingURLString: String?
    var duration = "00:00"
    var trackURLString: String {
        get {
            return streamingURLString ?? URLPrefix+self.trackID
        }
    }
    var index: Int {
        get {
            return Int(number) - 1
        }
    }
    
    var indexPath = IndexPath()
    
    convenience init(number: Int, title: String) {
        self.init()
        self.number = number
        self.title = title
        self.trackID = ""
    }
}

func ==(lhs: PCLesson, rhs: PCLesson) -> Bool {
    // TODO: change to trackID once we are using unique trackids.
    return lhs.title == rhs.title
}
