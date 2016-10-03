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
    
    var currentClass = PCClass()
    var currentLesson = PCLesson()
    var player = AVPlayer()
    var currentTrackURLString: String? {
        get {
            return (self.player.currentItem?.asset as? AVURLAsset)?.url.absoluteString
        }
    }

    override init() {
        super.init()
        addKVO()
        NotificationCenter.default.addObserver(self, selector: #selector(trackFinishedPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    deinit {
        removeKVO()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.status" {
            let status = (object as! AVPlayer).currentItem?.status
            print(status?.rawValue)
            if status == .readyToPlay {
                PCAudioPlayerNotificationManager.defaultManager.postNotification(.AudioStartedPlaying)
            } else if status == .failed {
                resetPlayer()
                PCAudioPlayerNotificationManager.defaultManager.postNotification(.AudioFailed)
            } else if status == .unknown {
                // TODO: Buffering
            }
        }
        
        if keyPath == "status" {
            let status = (object as! AVPlayer).status
            if status == .readyToPlay {
                print("Player ready to play")
            } else if status == .failed {
                print("Player failed")
            } else if status == .unknown {
                // TODO: Buffering
            }
        }
    }
    
    // MARK: Player Status
    
    var isPlaying: Bool {
        get {
            return self.player.rate != 0.0
        } set {
            self.isPlaying = newValue
        }
    }
    
    func isPlayingLesson(_ lesson: PCLesson) -> Bool {
        return isPlaying && lesson === self.currentLesson
    }
    
    func hasClass(_ theClass: PCClass) -> Bool {
        return theClass === self.currentClass
    }
    
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
    
    // MARK: Player Actions
    
    func playLesson(_ lesson: PCLesson) {
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
            if let url = URL(string: lesson.trackURLString) {
                self.playNewTrack(url)
            } else {
                print("ERROR:  NO URL")
            }
        }
    }
    
    func playNextTrack() {
        if hasNextTrack {
            currentLesson = currentClass.syllabus[currentLesson.index + 1]
            if let url = URL(string: currentLesson.trackURLString) {
                PCAudioPlayerNotificationManager.defaultManager.postNotification(.StartedPlayingNextTrack)
                self.playNewTrack(url)
            } else {
                print("ERROR:  NO URL")
            }
        }
    }
    
    func playPreviousTrack() {
        if hasPreviousTrack {
            currentLesson = currentClass.syllabus[currentLesson.index - 1]
            if let url = URL(string: currentLesson.trackURLString) {
                PCAudioPlayerNotificationManager.defaultManager.postNotification(.StartedPlayingPreviousTrack)
                self.playNewTrack(url)
            } else {
                print("ERROR:  NO URL")
            }
        }
    }
    
    // MARK: Notifications
    
    func trackFinishedPlaying() {
        if hasNextTrack {
            playNextTrack()
        } else {
            let trackURL = currentClass.syllabus[0].trackURLString
            if let url = URL(string: trackURL) {
                let newItem = AVPlayerItem(url: url)
                player.replaceCurrentItem(with: newItem)
                currentLesson = currentClass.syllabus[0]
            }
        }
    }
    
    // MARK: Private
    
    fileprivate func playNewTrack(_ trackURL: URL) {
        let newItem = AVPlayerItem(url: trackURL)
        self.player.replaceCurrentItem(with: newItem)
        self.playCurrentTrack()
    }
    
    fileprivate func playCurrentTrack() {
        // TODO:  Handle network failures and no internet
        player.play()
        if player.currentItem?.status == .readyToPlay {
            PCAudioPlayerNotificationManager.defaultManager.postNotification(.AudioStartedPlaying)
        }
    }
    
    fileprivate func pauseCurrentTrack() {
        self.player.pause()
        PCAudioPlayerNotificationManager.defaultManager.postNotification(.AudioStoppedPlaying)
    }
    
    fileprivate func currentItemIsLesson(_ lesson: PCLesson) -> Bool {
        return currentTrackURLString == lesson.trackURLString
    }
    
    fileprivate func resetPlayer() {
        removeKVO()
        player = AVPlayer()
        addKVO()
    }
    
    fileprivate func removeKVO() {
        player.removeObserver(self, forKeyPath: "currentItem.status")
        player.removeObserver(self, forKeyPath: "status")
    }
    
    fileprivate func addKVO() {
        player.addObserver(self, forKeyPath: "currentItem.status", options: [.new], context: nil)
        player.addObserver(self, forKeyPath: "status", options: [.new], context: nil)
    }
}
