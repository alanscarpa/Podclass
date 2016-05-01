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
            return (self.player.currentItem?.asset as? AVURLAsset)?.URL.absoluteString
        }
    }

    override init() {
        super.init()
        addKVO()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(trackFinishedPlaying), name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
    }
    
    deinit {
        removeKVO()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "currentItem.status" {
            let status = (object as! AVPlayer).currentItem?.status
            print(status?.rawValue)
            if status == .ReadyToPlay {
                PCAudioPlayerNotificationManager.defaultManager.postNotification(.AudioStartedPlaying)
            } else if status == .Failed {
                resetPlayer()
                PCAudioPlayerNotificationManager.defaultManager.postNotification(.AudioFailed)
//                let newItem = AVPlayerItem(URL: NSURL(string: currentLesson.trackURLString)!)
//                player.replaceCurrentItemWithPlayerItem(newItem)
            } else if status == .Unknown {
                // TODO: Buffering
            }
        }
        
        if keyPath == "status" {
            let status = (object as! AVPlayer).status
            if status == .ReadyToPlay {
                print("Player ready to play")
            } else if status == .Failed {
                print("Player failed")
            } else if status == .Unknown {
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
    
    func isPlayingLesson(lesson: PCLesson) -> Bool {
        return isPlaying && lesson === self.currentLesson
    }
    
    func hasClass(theClass: PCClass) -> Bool {
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
    
    func playNextTrack() {
        if hasNextTrack {
            currentLesson = currentClass.syllabus[currentLesson.index + 1]
            if let url = NSURL(string: currentLesson.trackURLString) {
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
            if let url = NSURL(string: currentLesson.trackURLString) {
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
            if let url = NSURL(string: trackURL) {
                let newItem = AVPlayerItem(URL: url)
                player.replaceCurrentItemWithPlayerItem(newItem)
                currentLesson = currentClass.syllabus[0]
            }
        }
    }
    
    // MARK: Private
    
    private func playNewTrack(trackURL: NSURL) {
        let newItem = AVPlayerItem(URL: trackURL)
        self.player.replaceCurrentItemWithPlayerItem(newItem)
        self.playCurrentTrack()
    }
    
    private func playCurrentTrack() {
        // TODO:  Handle network failures and no internet
        player.play()
        if player.currentItem?.status == .ReadyToPlay {
            PCAudioPlayerNotificationManager.defaultManager.postNotification(.AudioStartedPlaying)
        }
    }
    
    private func pauseCurrentTrack() {
        self.player.pause()
        PCAudioPlayerNotificationManager.defaultManager.postNotification(.AudioStoppedPlaying)
    }
    
    private func currentItemIsLesson(lesson: PCLesson) -> Bool {
        return currentTrackURLString == lesson.trackURLString
    }
    
    private func resetPlayer() {
        removeKVO()
        player = AVPlayer()
        addKVO()
    }
    
    private func removeKVO() {
        player.removeObserver(self, forKeyPath: "currentItem.status")
        player.removeObserver(self, forKeyPath: "status")
    }
    
    private func addKVO() {
        player.addObserver(self, forKeyPath: "currentItem.status", options: [.New], context: nil)
        player.addObserver(self, forKeyPath: "status", options: [.New], context: nil)
    }
}
