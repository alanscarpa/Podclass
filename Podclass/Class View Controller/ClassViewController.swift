//
//  ClassViewController.swift
//  Podclass
//
//  Created by Alan Scarpa on 3/30/16.
//  Copyright © 2016 Podclass. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import Social
import CoreMedia
import AVFoundation

class ClassViewController: UIViewController, PCMiniPlayerDelegate {

    var currentClass = PCClass()
    var currentLesson = PCLesson()
    var currentlySelectedCell: PCClassTableViewCell?
    var lastTappedIndexPath: NSIndexPath?
    var audioManager: PCAudioManager {
        return PCAudioManager.sharedInstance
    }
    var playbackObserver: AnyObject?
    static let miniPlayerView = PCMiniPlayerView.ip_fromNib()

    @IBOutlet private weak var classTitleLabel: UILabel!
    @IBOutlet private weak var classTableView: UITableView!
    @IBOutlet private weak var classTableViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        audioPlayerSync()
        setUpNotifications()
  
        let window = UIApplication.sharedApplication().keyWindow
        window?.addSubview(ClassViewController.miniPlayerView)
        ClassViewController.miniPlayerView.delegate = self
        setUpPlaybackObserver()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        showMiniPlayer()
        SVProgressHUD.dismiss()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        classTableViewHeightConstraint.constant = classTableView.contentSize.height
    }
    
    func setUpNotifications() {
        PCAudioPlayerNotificationManager.defaultManager.observerNotification(.MiniPlayerPlayPauseButtonTapped, observer: self, selector: #selector(miniPlayerPlayPauseButtonTapped))
        PCAudioPlayerNotificationManager.defaultManager.observerNotification(.AudioStartedPlaying, observer: self, selector: #selector(audioStartedPlaying))
        PCAudioPlayerNotificationManager.defaultManager.observerNotification(.AudioStoppedPlaying, observer: self, selector: #selector(audioStoppedPlaying))
        PCAudioPlayerNotificationManager.defaultManager.observerNotification(.AudioFailed, observer: self, selector: #selector(audioFailed))
        PCAudioPlayerNotificationManager.defaultManager.observerNotification(.StartedPlayingNextTrack, observer: self, selector: #selector(startedPlayingNextTrack))
        PCAudioPlayerNotificationManager.defaultManager.observerNotification(.StartedPlayingPreviousTrack, observer: self, selector: #selector(startedPlayingPreviousTrack))
    }
    
    func startedPlayingNextTrack() {
        if let oldIndexPath = lastTappedIndexPath {
            lastTappedIndexPath = NSIndexPath(forRow: oldIndexPath.row + 1, inSection: oldIndexPath.section)
        }
    }
    
    func startedPlayingPreviousTrack() {
        if let oldIndexPath = lastTappedIndexPath {
            lastTappedIndexPath = NSIndexPath(forRow: oldIndexPath.row - 1, inSection: oldIndexPath.section)
        }
    }
    
    func audioStartedPlaying() {
        showMiniPlayer()
        classTableView.reloadData()
        SVProgressHUD.dismiss()
    }
    
    func audioStoppedPlaying() {
        if let lastTappedIndexPath = lastTappedIndexPath  {
            let cell = classTableView.cellForRowAtIndexPath(lastTappedIndexPath) as! PCClassTableViewCell
            cell.isPaused = true
        }
        SVProgressHUD.dismiss()
    }
    
    func audioFailed() {
        // TODO: Show alert and handle this error state
        setUpPlaybackObserver()
        audioStoppedPlaying()
        showMiniPlayer()
    }
    
    func setUpPlaybackObserver() {
        let interval = CMTimeMake(60, 1000)
        playbackObserver = audioManager.player.addPeriodicTimeObserverForInterval(interval, queue: dispatch_get_main_queue()) { (time) in
            let endTime = CMTimeConvertScale((self.audioManager.player.currentItem?.asset.duration)!, self.audioManager.player.currentTime().timescale, .RoundHalfAwayFromZero)
            if CMTimeCompare(endTime, kCMTimeZero) != 0 {
                let normalizedTime: Float = Float(self.audioManager.player.currentTime().value) / Float(endTime.value)
                self.updateProgressSlider(normalizedTime)
            }
        }
    }
    
    func updateProgressSlider(value: Float) {
        ClassViewController.miniPlayerView.progressView.progress = value
    }
    
    func setUpTableView() {
        classTableView.allowsMultipleSelection = false
        classTableView.multipleTouchEnabled = false
        classTitleLabel.text = currentClass.name
        classTableView.registerNib(UINib(nibName: PCClassTableViewCell.className(), bundle: nil), forCellReuseIdentifier: PCClassTableViewCell.className())
    }
    
    func audioPlayerSync() {
        if audioManager.hasClass(currentClass) {
            lastTappedIndexPath = audioManager.currentLesson.indexPath
        }
    }
    
    func miniPlayerPlayPauseButtonTapped() {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.audioManager.playLesson(self.audioManager.currentLesson)
        }
    }
    
    private func showMiniPlayer() {
        if audioManager.hasCurrentTracks && isVisible {
            ClassViewController.miniPlayerView.currentLesson = audioManager.currentLesson
            PCAudioPlayerNotificationManager.defaultManager.postNotification(.ShowMiniPlayer)
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentClass.syllabus.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:
        NSIndexPath) -> UITableViewCell {
        currentClass.syllabus[indexPath.row].indexPath = indexPath
        let lessonForRow = currentClass.syllabus[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(PCClassTableViewCell.className(), forIndexPath: indexPath) as! PCClassTableViewCell
        cell.configureForLesson(lessonForRow)
        cell.isActive = audioManager.currentLesson == lessonForRow
        if cell.isActive && !audioManager.isPlaying {
            cell.isPaused = true
        }
        if cell.isActive {
            lastTappedIndexPath = indexPath
        }
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        SVProgressHUD.show()
        audioManager.currentClass = currentClass
        currentLesson = currentClass.syllabus[indexPath.row]
        
        let cell = classTableView.cellForRowAtIndexPath(indexPath) as! PCClassTableViewCell
        cell.isActive = true

        if let lastTappedIndexPath = lastTappedIndexPath where indexPath != lastTappedIndexPath {
            let lastCell = classTableView.cellForRowAtIndexPath(lastTappedIndexPath) as! PCClassTableViewCell
            lastCell.isActive = !lastCell.isActive
        }
        lastTappedIndexPath = indexPath

        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.audioManager.playLesson(self.audioManager.currentClass.syllabus[indexPath.row])
        }
    }
    
    // MARK: Actions
    
    @IBAction func backButtonTapped() {
        PCAudioPlayerNotificationManager.defaultManager.postNotification(.HideMiniPlayer)
        PCAudioPlayerNotificationManager.defaultManager.removeObserver(self)
        if let playbackObserver = playbackObserver {
            audioManager.player.removeTimeObserver(playbackObserver)
        }
        navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func discussionButtonTapped() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            vc.setInitialText("@podclassxyz \(currentClass.hashTag)")
            presentViewController(vc, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Twitter Required", message: "We use Twitter to chat.  If you have an account, go to Settings and connect.  Otherwise, sign up with Twitter and let's get tweeting!", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: PCMiniPlayerDelegate
    
    func miniPlayerExpandButtonTapped() {
        let vc = PCExpandedPlayerViewController.ip_fromNib()
        vc.currentClass = currentClass
        vc.currentLesson = currentLesson
        presentViewController(vc, animated: true, completion: nil)
        PCAudioPlayerNotificationManager.defaultManager.postNotification(.HideMiniPlayer)
    }
}
