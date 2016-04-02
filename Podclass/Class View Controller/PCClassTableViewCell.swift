//
//  ClassTableViewCell.swift
//  Podclass
//
//  Created by Alan Scarpa on 3/30/16.
//  Copyright © 2016 Podclass. All rights reserved.
//

import UIKit


class PCClassTableViewCell: UITableViewCell {

    @IBOutlet private weak var lessonNumberLabel: UILabel!
    @IBOutlet weak var lessonTitleLabel: UILabel!
    @IBOutlet weak var playIconImageView: UIImageView!
    var pauseButtonImage = UIImage(named: "pauseButton")
    var playButtonImage = UIImage(named: "playButton")
    var isActive = false {
        didSet {
            self.playIconImageView.image = self.isActive ? self.pauseButtonImage : self.playButtonImage
            self.contentView.backgroundColor = self.isActive ? UIColor.pcLightOrange() : UIColor.whiteColor()
            self.lesson.isPlaying = self.isActive
        }
    }
    var lesson = PCLesson()

    func configureForLesson(lesson: PCLesson) {
        self.lesson = lesson
        self.lessonNumberLabel.text = "\(lesson.number))."
        self.lessonTitleLabel.text = "\(lesson.title)"
    }

}
