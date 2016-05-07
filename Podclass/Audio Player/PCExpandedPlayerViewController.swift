//
//  PCExpandedPlayerViewController.swift
//  Podclass
//
//  Created by Alan Scarpa on 4/18/16.
//  Copyright © 2016 Podclass. All rights reserved.
//

import UIKit
import CoreMedia
import AVFoundation
import SVProgressHUD

class PCExpandedPlayerViewController: UIViewController {
    
    var currentClass = PCClass()
    var currentLesson = PCLesson()
    var audioManager: PCAudioManager {
        return PCAudioManager.sharedInstance
    }
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
        
        if let currentItem = audioManager.player.currentItem {
            totalSecondsOfCurrentTrack = CMTimeGetSeconds(currentItem.duration)
            timeLeftLabel.text = timeFormatted(Int(totalSecondsOfCurrentTrack))
        }
        
        UISlider.appearance().setThumbImage(UIImage(named: "sliderImage"), forState: .Normal)
        
        mainImageView.image = UIImage(named: currentClass.homeImageName)
        classTitleLabel.text = currentClass.name
        updateTrackUI()
        
        PCAudioPlayerNotificationManager.defaultManager.observerNotification(.AudioStartedPlaying, observer: self, selector: #selector(audioStartedPlaying))
        PCAudioPlayerNotificationManager.defaultManager.observerNotification(.AudioFailed, observer: self, selector: #selector(audioFailed))
    }
    
    // MARK: Notifications
    
    func audioStartedPlaying() {
        SVProgressHUD.dismiss()
        setUpPlaybackObserver()
        updateTrackUI()
    }
    
    func audioFailed() {
        SVProgressHUD.dismiss()
        setUpPlaybackObserver()
        updateTrackUI()
        if !Reachability.connectedToNetwork() {
            presentViewController(UIAlertController().simpleAlert(.NoInternet), animated: true, completion: nil)
        } else {
            presentViewController(UIAlertController().simpleAlert(.GenericError), animated: true, completion: nil)
        }
    }
    
    func setProgressSliderToCurrentTrackTime() {
        if let currentItem = self.audioManager.player.currentItem {
            let endTime = CMTimeConvertScale(currentItem.asset.duration, self.audioManager.player.currentTime().timescale, .RoundHalfAwayFromZero)
            if CMTimeCompare(endTime, kCMTimeZero) != 0 {
                let normalizedTime: Float = Float(audioManager.player.currentTime().value) / Float(endTime.value)
                self.updateProgressSlider(normalizedTime)
            }
            let currentSeconds = CMTimeGetSeconds(audioManager.player.currentTime());
            timeProgressLabel.text = timeFormatted(Int(currentSeconds))
            if let currentItem = audioManager.player.currentItem {
                let totalSeconds = CMTimeGetSeconds(currentItem.duration)
                if !totalSeconds.isNaN {
                    timeLeftLabel.text = "-\(timeFormatted(Int(totalSeconds) - Int(currentSeconds)))"
                }
            }
        }
    }
    
    func updateTrackUI() {
        lessonTitleLabel.text = audioManager.currentLesson.title
        let playIconImage = audioManager.isPlaying ? UIImage(named: "pauseButton") : UIImage(named: "playButton")
        playPauseButton.setImage(playIconImage, forState: .Normal)
    }
    
    func sliderMoved() {
        if let currentItem = audioManager.player.currentItem {
            let newTime = CMTimeMakeWithSeconds(Double(progressSlider.value) * CMTimeGetSeconds(currentItem.duration), audioManager.player.currentTime().timescale);
            audioManager.player.seekToTime(newTime)
        }
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
        if let currentItem = audioManager.player.currentItem {
            return CMTimeGetSeconds(currentItem.duration) > 3600 ? String(format: "%02d:%02d:%02d", hours, minutes, seconds) : String(format: "%02d:%02d", minutes, seconds)
        } else {
            return "Error"
        }
    }
    
    func updateProgressSlider(value: Float) {
        progressSlider.value = value
    }
    
    // MARK: Actions
    
    @IBAction func playPauseButtonTapped() {
        let playIconImage = !audioManager.isPlaying ? UIImage(named: "pauseButton") : UIImage(named: "playButton")
        playPauseButton.setImage(playIconImage, forState: .Normal)
        audioManager.playLesson(audioManager.currentLesson)
    }
    
    @IBAction func nextTrackButtonTapped() {
        if audioManager.hasNextTrack {
            SVProgressHUD.show()
            removePlaybackObserver()
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.audioManager.playNextTrack()
            }
        }
    }
    
    @IBAction func previousTrackButtonTapped() {
        if audioManager.hasPreviousTrack {
            SVProgressHUD.show()
            removePlaybackObserver()
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.audioManager.playPreviousTrack()
            }
        }
    }
    
    @IBAction func downArrowButtonTapped() {
        removePlaybackObserver()
        progressSlider.removeTarget(self, action: nil, forControlEvents: .ValueChanged)
        NSNotificationCenter.defaultCenter().removeObserver(self)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Private
    
    private func removePlaybackObserver() {
        if let playbackObserver = playbackObserver {
            audioManager.player.removeTimeObserver(playbackObserver)
            self.playbackObserver = nil
        }
    }

}
