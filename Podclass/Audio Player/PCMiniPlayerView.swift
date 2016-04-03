//
//  PCMiniPlayerView.swift
//  Podclass
//
//  Created by Alan Scarpa on 4/11/16.
//  Copyright © 2016 Podclass. All rights reserved.
//

import Foundation
import PureLayout

class PCMiniPlayerView: PCView {
  
    @IBOutlet weak var lessonTitleLabel: UILabel!
    @IBOutlet weak var lessonNumberLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var expandButton: UIButton!
    var bottomConstraint = NSLayoutConstraint()
    var isShowing = false
    var constraintsAreSet = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PCMiniPlayerView.hideMiniPlayer), name: kHideMiniPlayer, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PCMiniPlayerView.updateUIForNewTrack), name: kShowMiniPlayer, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PCMiniPlayerView.updateUIForNewTrack), name: kAudioStartedPlaying, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PCMiniPlayerView.updateUIForNewTrack), name: kAudioStoppedPlaying, object: nil)
        self.topBorderColor = UIColor.pcOrange()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !self.constraintsAreSet {
            self.autoSetDimension(.Height, toSize: 70)
            self.autoPinEdge(.Leading, toEdge: .Leading, ofView: self.superview!)
            self.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self.superview!)
            self.bottomConstraint = self.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.superview!, withOffset: 70)
            self.constraintsAreSet = true
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK:  Notifications
    
    func updateUIForNewTrack() {
        if !self.isShowing {
            self.isShowing = !self.isShowing
            UIView.animateWithDuration(0.3, animations: { 
                self.bottomConstraint.constant = 0
                self.layoutIfNeeded()
            })
        }
        self.lessonNumberLabel.text = "\(PCAudioManager.sharedInstance.currentLesson.number))."
        self.lessonTitleLabel.text = PCAudioManager.sharedInstance.currentLesson.title
        let playIconImage = PCAudioManager.sharedInstance.isPlaying ? UIImage(named: "pauseButton") : UIImage(named: "playButton")
        self.playButton.setImage(playIconImage, forState: .Normal)
    }
    
    func hideMiniPlayer() {
        if self.isShowing {
            self.isShowing = !self.isShowing
            UIView.animateWithDuration(0.3, animations: {
                self.bottomConstraint.constant = 70
                self.layoutIfNeeded()
            })
        }
    }
    
    // MARK:  Actions
    @IBAction func playButtonTapped() {
        NSNotificationCenter.defaultCenter().postNotificationName(kMiniPlayerPlayPauseButtonTapped, object: nil, userInfo: ["indexPath" : PCAudioManager.sharedInstance.currentLesson.indexPath])
//        if let currentlySelectedCell = self.currentlySelectedCell {
//            currentlySelectedCell.isActive = !currentlySelectedCell.lesson.isPlaying
//            self.updateNowPlayingPlayer(currentlySelectedCell.lesson)
//            if let indexPath = self.classTableView.indexPathForCell(currentlySelectedCell) {
//                classTableView.deselectRowAtIndexPath(indexPath, animated: true)
//            }
//            self.currentlySelectedCell = nil
//        } else if let indexPath = self.lastTappedIndexPath,
//            let tappedCell = self.classTableView.cellForRowAtIndexPath(indexPath) as? PCClassTableViewCell {
//            self.classTableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .None)
//            self.updateCellStatus(tappedCell)
//            self.updateNowPlayingPlayer(tappedCell.lesson)
//            self.currentlySelectedCell = tappedCell
//        }
    }
    
    @IBAction func expandButtonTapped() {
    }
}