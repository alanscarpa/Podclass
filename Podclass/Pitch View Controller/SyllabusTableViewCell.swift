//
//  SyllabusTableViewCell.swift
//  Podclass
//
//  Created by Alan Scarpa on 3/25/16.
//  Copyright © 2016 Podclass. All rights reserved.
//

import UIKit

class SyllabusTableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var lessonNumberLabel: UILabel!
    @IBOutlet fileprivate weak var lessonTitleLabel: UILabel!
    
    func configureForLesson(_ lesson: PCLesson) {
        self.lessonNumberLabel.text = "\(lesson.number))."
        self.lessonTitleLabel.text = lesson.title
    }
}
