//
//  PCView.swift
//  Podclass
//
//  Created by Alan Scarpa on 4/2/16.
//  Copyright © 2016 Podclass. All rights reserved.
//

import UIKit

class PCView: UIView {
    
    var topBorderColor: UIColor?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let topBorderColor = self.topBorderColor {
            self.setTopBorderWithColor(topBorderColor.cgColor, width: 2)
        }
    }
    
}
