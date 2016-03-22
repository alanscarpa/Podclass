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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureForLesson(lesson: PCLesson) {
        self.lessonNumberLabel.text = "\(lesson.number))."
        self.lessonTitleLabel.text = "\(lesson.title)"
    }
    
    
}
