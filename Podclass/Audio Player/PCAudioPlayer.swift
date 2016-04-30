//
//  PCAudioPlayer.swift
//  Podclass
//
//  Created by Alan Scarpa on 4/10/16.
//  Copyright © 2016 Podclass. All rights reserved.
//

import Foundation
import AVFoundation

class PCAudioManager: NSObject {
    
    static let sharedInstance = PCAudioManager()
    var currentTracks = [PCLesson]()
    var currentClass = PCClass()
    override init() {
        super.init()
        self.player.addObserver(self, forKeyPath: "currentItem.status", options: [.New], context: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PCAudioManager.trackFinishedPlaying), name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
    }
    
    func trackFinishedPlaying() {
        if hasNextTrack {
            playNextTrack()
        } else {
            let trackURL = currentClass.syllabus[0].trackURLString
            if let url = NSURL(string: trackURL) {
                let newItem = AVPlayerItem(URL: url)
                player.replaceCurrentItemWithPlayerItem(newItem)
                currentLesson = currentClass.syllabus[0]
            }
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "currentItem.status" {
            let status = (object as! AVPlayer).currentItem?.status
            if status == .ReadyToPlay {
                NSNotificationCenter.defaultCenter().postNotificationName(kAudioStartedPlaying, object: nil)
            } else if status == .Failed {
                NSNotificationCenter.defaultCenter().postNotificationName(kAudioFailed, object: nil)
            }
        }
    }
    
    deinit {
        self.player.removeObserver(self, forKeyPath: "currentItem.status")
    }
    
    var player = AVPlayer()
    
    var currentTrackURLString: String? {
        get {
            return (self.player.currentItem?.asset as? AVURLAsset)?.URL.absoluteString
        }
    }
    
    var isPlaying: Bool {
        get {
            return self.player.rate != 0.0
        } set {
            self.isPlaying = newValue
        }
    }
    
    func isPlayingLesson(lesson: PCLesson) -> Bool {
        return isPlaying && lesson === self.currentLesson
    }
    
    func hasClass(theClass: PCClass) -> Bool {
        return theClass === self.currentClass
    }
    
    var currentLesson = PCLesson()
    
    var hasCurrentTracks: Bool {
        get {
            return currentClass.syllabus.count > 0
        }
    }
    
    var hasNextTrack: Bool {
        get {
            return self.currentLesson.index + 1 < currentClass.syllabus.count
        }
    }
    
    var hasPreviousTrack: Bool {
        get {
            return self.currentLesson.index - 1 >= 0
        }
    }
    
    func playNextTrack() {
        if hasNextTrack {
            currentLesson = currentClass.syllabus[currentLesson.index + 1]
            if let url = NSURL(string: currentLesson.trackURLString) {
                NSNotificationCenter.defaultCenter().postNotificationName(kStartedPlayingNextTrack, object: nil)
                self.playNewTrack(url)
            } else {
                print("ERROR:  NO URL")
            }
        }
    }
    
    func playPreviousTrack() {
        if hasPreviousTrack {
            currentLesson = currentClass.syllabus[currentLesson.index - 1]
            if let url = NSURL(string: currentLesson.trackURLString) {
                NSNotificationCenter.defaultCenter().postNotificationName(kStartedPlayingPreviousTrack, object: nil)
                self.playNewTrack(url)
            } else {
                print("ERROR:  NO URL")
            }
        }
    }
    
    func playLesson(lesson: PCLesson) {
        self.currentLesson = lesson
        if self.currentItemIsLesson(lesson) {
            if self.player.rate != 0.0 {
                // PLAYING
                self.pauseCurrentTrack()
            } else {
                // NOT PLAYING
                self.playCurrentTrack()
            }
        } else {
            if let url = NSURL(string: lesson.trackURLString) {
                self.playNewTrack(url)
            } else {
                print("ERROR:  NO URL")
            }
        }
    }
    
    
    private func playNewTrack(trackURL: NSURL) {
        let newItem = AVPlayerItem(URL: trackURL)
        self.player.replaceCurrentItemWithPlayerItem(newItem)
        self.playCurrentTrack()
    }
    
    private func playCurrentTrack() {
        // TODO:  Handle network failures and no internet
        self.player.play()
        if self.player.currentItem?.status == .ReadyToPlay {
            NSNotificationCenter.defaultCenter().postNotificationName(kAudioStartedPlaying, object: nil)
        }
    }
    
    func pauseCurrentTrack() {
        self.player.pause()
        NSNotificationCenter.defaultCenter().postNotificationName(kAudioStoppedPlaying, object: nil)
    }
    
    private func currentItemIsLesson(lesson: PCLesson) -> Bool {
        return self.currentTrackURLString == lesson.trackURLString
    }
}
