//
//  PCButton.swift
//  Podclass
//
//  Created by Alan Scarpa on 4/17/16.
//  Copyright © 2016 Podclass. All rights reserved.
//

import UIKit

class PCButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    func setUp() {
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.backgroundColor = UIColor.pcOrange()
        self.layer.borderColor = UIColor.pcOrange().CGColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 8
        self.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
    }

}
