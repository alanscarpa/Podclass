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
    
    func postNotification(notification: PCAudioPlayerNotification) {
        NSNotificationCenter.defaultCenter().postNotificationName(notification.rawValue, object: nil)
    }
    
    // MARK: Observe
    
    func observerNotification(notification: PCAudioPlayerNotification, observer: AnyObject, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: notification.rawValue, object: nil)
    }
    
    // MARK: Removal
    
    func removeObserver(observer: AnyObject) {
        NSNotificationCenter.defaultCenter().removeObserver(observer)
    }
    
}