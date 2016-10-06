//
//  ClassTableViewCell.swift
//  Podclass
//
//  Created by Alan Scarpa on 3/20/16.
//  Copyright © 2016 Podclass. All rights reserved.
//

import UIKit

class ClassTableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var backgroundImage: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: PCLabel!
    
    func configureForClass(_ pcClass: PCClass) {
        titleLabel.text = pcClass.name
        backgroundImage.image = UIImage(named: pcClass.homeImageName)
    }
}
