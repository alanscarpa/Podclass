//
//  PCAudioPlayerNotificationManager.swift
//  Podclass
//
//  Created by Alan Scarpa on 5/1/16.
//  Copyright © 2016 Podclass. All rights reserved.
//

import Foundation

enum PCAudioPlayerNotification: String {
    case AudioStartedPlaying = "AudioStartedPlaying"
    case AudioStoppedPlaying = "AudioStoppedPlaying"
    case AudioFailed = "AudioFailed"
    case StartedPlayingNextTrack = "StartedPlayingNextTrack"
    case StartedPlayingPreviousTrack = "StartedPlayingPreviousTrack"
    case TrackFinishedPlaying = "TrackFinishedPlaying"
    case ShowMiniPlayer = "ShowMiniPlayer"
    case HideMiniPlayer = "HideMiniPlayer"
    case MiniPlayerPlayPauseButtonTapped = "MiniPlayerPlayPauseButtonTapped"
}

struct PCAudioPlayerNotificationManager {
    
    static let defaultManager = PCAudioPlayerNotificationManager()
    
    // MARK: Post
    
    func postNotification(_ notification: PCAudioPlayerNotification) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: notification.rawValue), object: nil)
    }
    
    // MARK: Observe
    
    func observerNotification(_ notification: PCAudioPlayerNotification, observer: AnyObject, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: notification.rawValue), object: nil)
    }
    
    // MARK: Removal
    
    func removeObserver(_ observer: AnyObject) {
        NotificationCenter.default.removeObserver(observer)
    }
    
}
