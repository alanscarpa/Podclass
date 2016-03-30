//
//  SyllabusTableViewCell.swift
//  Podclass
//
//  Created by Alan Scarpa on 3/25/16.
//  Copyright © 2016 Podclass. All rights reserved.
//

import UIKit

class SyllabusTableViewCell: UITableViewCell {

    @IBOutlet private weak var lessonNumberLabel: UILabel!
    @IBOutlet weak var lessonTitleLabel: UILabel!
    
    func configureForLesson(lesson: PCLesson) {
        self.lessonNumberLabel.text = "\(lesson.number))."
        self.lessonTitleLabel.text = "\(lesson.title)"
    }
    
    
}
