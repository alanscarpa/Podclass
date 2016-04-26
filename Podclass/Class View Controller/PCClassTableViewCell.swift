//
//  ClassTableViewCell.swift
//  Podclass
//
//  Created by Alan Scarpa on 3/30/16.
//  Copyright © 2016 Podclass. All rights reserved.
//

import UIKit
import AVFoundation

class PCClassTableViewCell: UITableViewCell {

    @IBOutlet private weak var lessonNumberLabel: UILabel!
    @IBOutlet weak var lessonTitleLabel: UILabel!
    var pauseButtonImage = UIImage(named: "pauseButton")
    var playButtonImage = UIImage(named: "playButton")
    @IBOutlet weak var lessonDurationLabel: UILabel!

    var isActive = false {
        didSet {
            self.contentView.backgroundColor = self.isActive ? UIColor.pcLightOrange() : UIColor.whiteColor()
            self.lesson.isPlaying = self.isActive
        }
    }
    var lesson = PCLesson()

    func configureForLesson(lesson: PCLesson) {
        self.lesson = lesson
        self.lessonNumberLabel.text = "\(lesson.number)"
        self.lessonTitleLabel.text = lesson.title
        self.lessonDurationLabel.text = lesson.duration
    }

}
