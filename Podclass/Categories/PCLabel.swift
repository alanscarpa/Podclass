//
//  PCLabel.swift
//  Podclass
//
//  Created by Alan Scarpa on 3/20/16.
//  Copyright © 2016 Podclass. All rights reserved.
//

import UIKit

@IBDesignable
class PCLabel: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUp()
    }
    
    func setUp() {
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.layer.borderColor = UIColor.pcOrange().CGColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 4
    }

}
