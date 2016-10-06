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

    @IBOutlet fileprivate weak var lessonNumberLabel: UILabel!
    @IBOutlet weak var lessonTitleLabel: UILabel!
    var pauseButtonImage = UIImage(named: "pauseButton")
    var playButtonImage = UIImage(named: "playButton")
    @IBOutlet weak var lessonDurationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
    }
    
    var isActive = false {
        didSet {
            self.contentView.backgroundColor = self.isActive ? UIColor.pcLightOrange() : UIColor.white
            self.lesson.isPlaying = self.isActive
        }
    }
    var isPaused = false {
        didSet {
            self.contentView.backgroundColor = UIColor.pcGray()
        }
    }
    var lesson = PCLesson()

    func configureForLesson(_ lesson: PCLesson) {
        self.lesson = lesson
        self.lessonNumberLabel.text = "\(lesson.number)"
        self.lessonTitleLabel.text = lesson.title
        self.lessonDurationLabel.text = lesson.duration
    }

}
