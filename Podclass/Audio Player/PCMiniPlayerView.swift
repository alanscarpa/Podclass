//
//  PCMiniPlayerView.swift
//  Podclass
//
//  Created by Alan Scarpa on 4/11/16.
//  Copyright © 2016 Podclass. All rights reserved.
//

import Foundation
import PureLayout
import AVFoundation

protocol PCMiniPlayerDelegate: class {
    func miniPlayerExpandButtonTapped()
}

class PCMiniPlayerView: UIView {
  
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var lessonTitleLabel: UILabel!
    @IBOutlet weak var lessonNumberLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var expandButton: UIButton!
    
    var bottomConstraint = NSLayoutConstraint()
    var isShowing = false
    var constraintsAreSet = false
    var currentLesson: PCLesson? {
        didSet {
            updateUIForNewTrack()
        }
    }
    weak var delegate: PCMiniPlayerDelegate?
    var audioManager: PCAudioManager {
        return PCAudioManager.sharedInstance
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpNotifications()

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !self.constraintsAreSet {
            self.autoSetDimension(.height, toSize: 70)
            self.autoPinEdge(.leading, to: .leading, of: self.superview!)
            self.autoPinEdge(.trailing, to: .trailing, of: self.superview!)
            self.bottomConstraint = self.autoPinEdge(.bottom, to: .bottom, of: self.superview!, withOffset: 70)
            self.constraintsAreSet = true
        }
    }
    
    deinit {
        PCAudioPlayerNotificationManager.defaultManager.removeObserver(self)
    }
    
    // MARK:  Notifications
    
    fileprivate func setUpNotifications() {
        PCAudioPlayerNotificationManager.defaultManager.observerNotification(.HideMiniPlayer, observer: self, selector: #selector(PCMiniPlayerView.hideMiniPlayer))
        PCAudioPlayerNotificationManager.defaultManager.observerNotification(.ShowMiniPlayer, observer: self, selector: #selector(PCMiniPlayerView.showMiniPlayer))
        PCAudioPlayerNotificationManager.defaultManager.observerNotification(.AudioStartedPlaying, observer: self, selector: #selector(PCMiniPlayerView.updateUIForNewTrack))
        PCAudioPlayerNotificationManager.defaultManager.observerNotification(.AudioStoppedPlaying, observer: self, selector: #selector(PCMiniPlayerView.updateUIForNewTrack))
    }
    
    func updateUIForNewTrack() {
        self.lessonNumberLabel.text = "\(audioManager.currentLesson.number)"
        self.lessonTitleLabel.text = audioManager.currentLesson.title
        let playIconImage = audioManager.isPlaying ? UIImage(named: "pauseButton") : UIImage(named: "playButton")
        self.playButton.setImage(playIconImage, for: UIControlState())
    }
    
    func showMiniPlayer() {
        if !self.isShowing {
            self.isShowing = !self.isShowing
            UIView.animate(withDuration: 0.3, animations: {
                self.bottomConstraint.constant = 0
                self.layoutIfNeeded()
            })
        }
    }
    
    func hideMiniPlayer() {
        if self.isShowing {
            self.isShowing = !self.isShowing
            UIView.animate(withDuration: 0.3, animations: {
                self.bottomConstraint.constant = 70
                self.layoutIfNeeded()
            })
        }
    }
    
    func resetToInitialState() {
        playButton.setImage(UIImage(named: "playButton"), for: UIControlState())
    }
    
    // MARK:  Actions
    
    @IBAction func playButtonTapped() {
        PCAudioPlayerNotificationManager.defaultManager.postNotification(.MiniPlayerPlayPauseButtonTapped)
    }
    
    @IBAction func expandButtonTapped() {
        self.delegate?.miniPlayerExpandButtonTapped()
    }
}
