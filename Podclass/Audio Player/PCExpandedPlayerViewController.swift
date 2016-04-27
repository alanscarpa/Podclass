//
//  PCExpandedPlayerViewController.swift
//  Podclass
//
//  Created by Alan Scarpa on 4/18/16.
//  Copyright © 2016 Podclass. All rights reserved.
//

import UIKit
import CoreMedia

class PCExpandedPlayerViewController: UIViewController {
    
    var currentClass = PCClass()
    var currentLesson = PCLesson()
    let audioManager = PCAudioManager.sharedInstance
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var timeProgressLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var lessonTitleLabel: UILabel!
    @IBOutlet weak var classTitleLabel: UILabel!
    var playbackObserver: AnyObject?
    var totalSecondsOfCurrentTrack: Float64 = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProgressSliderToCurrentTrackTime()
        setUpPlaybackObserver()
        progressSlider.addTarget(self, action: #selector(PCExpandedPlayerViewController.sliderMoved), forControlEvents: .ValueChanged)
        
        totalSecondsOfCurrentTrack = CMTimeGetSeconds(audioManager.player.currentItem!.duration)
        timeLeftLabel.text = timeFormatted(Int(totalSecondsOfCurrentTrack))
        
        UISlider.appearance().setThumbImage(UIImage(named: "sliderImage"), forState: .Normal)
        
        mainImageView.image = UIImage(named: currentClass.homeImageName)
        classTitleLabel.text = currentClass.name
        updateTrackUI()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PCExpandedPlayerViewController.audioStartedPlaying), name: kAudioStartedPlaying, object: nil)
    }
    
    func setProgressSliderToCurrentTrackTime() {
        let endTime = CMTimeConvertScale((self.audioManager.player.currentItem?.asset.duration)!, self.audioManager.player.currentTime().timescale, .RoundHalfAwayFromZero)
        if CMTimeCompare(endTime, kCMTimeZero) != 0 {
            let normalizedTime: Float = Float(self.audioManager.player.currentTime().value) / Float(endTime.value)
            self.updateProgressSlider(normalizedTime)
        }
        let currentSeconds = CMTimeGetSeconds(self.audioManager.player.currentTime());
        self.timeProgressLabel.text = self.timeFormatted(Int(currentSeconds))
        if let currentItem = self.audioManager.player.currentItem {
            let totalSeconds = CMTimeGetSeconds(currentItem.duration)
            if !totalSeconds.isNaN {
                self.timeLeftLabel.text = "-\(self.timeFormatted(Int(totalSeconds) - Int(currentSeconds)))"
            }
        }
    }
    func updateTrackUI() {
        lessonTitleLabel.text = audioManager.currentLesson.title
        let playIconImage = audioManager.isPlaying ? UIImage(named: "pauseButton") : UIImage(named: "playButton")
        playPauseButton.setImage(playIconImage, forState: .Normal)
    }
    
    func audioStartedPlaying() {
        setUpPlaybackObserver()
        updateTrackUI()
    }
    
    func sliderMoved() {
        let newTime = CMTimeMakeWithSeconds(Double(progressSlider.value) * CMTimeGetSeconds(audioManager.player.currentItem!.duration), audioManager.player.currentTime().timescale);
        audioManager.player.seekToTime(newTime)
    }

    func setUpPlaybackObserver() {
        let interval = CMTimeMake(60, 1000)
        playbackObserver = audioManager.player.addPeriodicTimeObserverForInterval(interval, queue: dispatch_get_main_queue()) { time in
            self.setProgressSliderToCurrentTrackTime()
        }
    }
    
    func timeFormatted(totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hours: Int = totalSeconds / 3600
        
        return CMTimeGetSeconds(audioManager.player.currentItem!.duration) > 3600 ? String(format: "%02d:%02d:%02d", hours, minutes, seconds) : String(format: "%02d:%02d", minutes, seconds)
    }
    
    func updateProgressSlider(value: Float) {
        progressSlider.value = value
    }
    
    @IBAction func playPauseButtonTapped() {
        let playIconImage = !audioManager.isPlaying ? UIImage(named: "pauseButton") : UIImage(named: "playButton")
        playPauseButton.setImage(playIconImage, forState: .Normal)
        audioManager.playLesson(audioManager.currentLesson)
    }
    
    @IBAction func nextTrackButtonTapped() {
        if audioManager.hasNextTrack {
            removePlaybackObserver()
        }
        audioManager.playNextTrack()
    }
    
    @IBAction func previousTrackButtonTapped() {
        if audioManager.hasPreviousTrack {
            removePlaybackObserver()
        }
        audioManager.playPreviousTrack()
    }
    
    @IBAction func downArrowButtonTapped() {
        removePlaybackObserver()
        progressSlider.removeTarget(self, action: nil, forControlEvents: .ValueChanged)
        NSNotificationCenter.defaultCenter().removeObserver(self)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func removePlaybackObserver() {
        if let playbackObserver = playbackObserver {
            audioManager.player.removeTimeObserver(playbackObserver)
            self.playbackObserver = nil
        }
    }

}
