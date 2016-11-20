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
    var lastTappedIndexPath: IndexPath?
    var audioManager: PCAudioManager {
        return PCAudioManager.sharedInstance
    }
    var playbackObserver: AnyObject?
    static let miniPlayerView = PCMiniPlayerView.fromNib()

    @IBOutlet fileprivate weak var classTitleLabel: UILabel!
    @IBOutlet fileprivate weak var classTableView: UITableView!
    @IBOutlet fileprivate weak var classTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var headerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        audioPlayerSync()
        setUpNotifications()
  
        headerImageView.image = UIImage(named: currentClass.homeImageName)
        
        let window = UIApplication.shared.keyWindow
        window?.addSubview(ClassViewController.miniPlayerView)
        ClassViewController.miniPlayerView.delegate = self
        setUpPlaybackObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
            lastTappedIndexPath = IndexPath(row: (oldIndexPath as NSIndexPath).row + 1, section: (oldIndexPath as NSIndexPath).section)
            classTableView.reloadData()
        }
    }
    
    func startedPlayingPreviousTrack() {
        if let oldIndexPath = lastTappedIndexPath {
            lastTappedIndexPath = IndexPath(row: (oldIndexPath as NSIndexPath).row - 1, section: (oldIndexPath as NSIndexPath).section)
        }
    }
    
    func audioStartedPlaying() {
        showMiniPlayer()
        classTableView.reloadData()
        SVProgressHUD.dismiss()
    }
    
    func audioStoppedPlaying() {
        if let lastTappedIndexPath = lastTappedIndexPath  {
            let cell = classTableView.cellForRow(at: lastTappedIndexPath) as! PCClassTableViewCell
            cell.isPaused = true
        }
        SVProgressHUD.dismiss()
    }
    
    func audioFailed() {
        // TODO: Show alert and handle this error state
        setUpPlaybackObserver()
        audioStoppedPlaying()
        showMiniPlayer()

        if !Reachability.connectedToNetwork() {
            present(UIAlertController().simpleAlert(.noInternet), animated: true, completion: nil)
        } else {
            present(UIAlertController().simpleAlert(.genericError), animated: true, completion: nil)
        }
    }
    
    func setUpPlaybackObserver() {
        let interval = CMTimeMake(60, 1000)
        playbackObserver = audioManager.player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { (time) in
            guard let duration = self.audioManager.player.currentItem?.asset.duration else { return }
            let endTime = CMTimeConvertScale(duration, self.audioManager.player.currentTime().timescale, .roundHalfAwayFromZero)
            if CMTimeCompare(endTime, kCMTimeZero) != 0 {
                let normalizedTime: Float = Float(self.audioManager.player.currentTime().value) / Float(endTime.value)
                self.updateProgressSlider(normalizedTime)
            }
        } as AnyObject?
    }
    
    func updateProgressSlider(_ value: Float) {
        ClassViewController.miniPlayerView.progressView.progress = value
    }
    
    func setUpTableView() {
        classTableView.allowsMultipleSelection = false
        classTableView.isMultipleTouchEnabled = false
        classTitleLabel.text = currentClass.name
        classTableView.register(UINib(nibName: PCClassTableViewCell.className(), bundle: nil), forCellReuseIdentifier: PCClassTableViewCell.className())
    }
    
    func audioPlayerSync() {
        if audioManager.hasClass(currentClass) {
            lastTappedIndexPath = audioManager.currentLesson.indexPath as IndexPath
        }
    }
    
    func miniPlayerPlayPauseButtonTapped() {
        OperationQueue.main.addOperation {
            self.audioManager.playLesson(self.audioManager.currentLesson)
        }
    }
    
    fileprivate func showMiniPlayer() {
        if audioManager.hasCurrentTracks && isVisible {
            ClassViewController.miniPlayerView.currentLesson = audioManager.currentLesson
            PCAudioPlayerNotificationManager.defaultManager.postNotification(.ShowMiniPlayer)
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentClass.syllabus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath:
        IndexPath) -> UITableViewCell {
        currentClass.syllabus[indexPath.row].indexPath = indexPath
        let lessonForRow = currentClass.syllabus[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: PCClassTableViewCell.className(), for: indexPath) as! PCClassTableViewCell
        cell.configureForLesson(lessonForRow)
        cell.isActive = audioManager.currentLesson == lessonForRow
        if cell.isActive && !audioManager.isPlaying { cell.isPaused = true }
        if cell.isActive { lastTappedIndexPath = indexPath }
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        SVProgressHUD.show()
        audioManager.currentClass = currentClass
        currentLesson = currentClass.syllabus[indexPath.row]
        
        let cell = classTableView.cellForRow(at: indexPath) as! PCClassTableViewCell
        cell.isActive = true

        if let lastTappedIndexPath = lastTappedIndexPath , indexPath != lastTappedIndexPath {
            let lastCell = classTableView.cellForRow(at: lastTappedIndexPath) as! PCClassTableViewCell
            lastCell.isActive = !lastCell.isActive
        }
        lastTappedIndexPath = indexPath

        OperationQueue.main.addOperation {
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
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func discussionButtonTapped() {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            vc?.setInitialText("@podclassxyz \(currentClass.hashTag)")
            present(vc!, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Twitter Required", message: "We use Twitter to chat.  If you have an account, go to Settings and connect.  Otherwise, sign up with Twitter and let's get tweeting!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: PCMiniPlayerDelegate
    
    func miniPlayerExpandButtonTapped() {
        let vc = PCExpandedPlayerViewController.ip_fromNib()
        vc.currentClass = currentClass
        vc.currentLesson = currentLesson
        present(vc, animated: true, completion: nil)
        PCAudioPlayerNotificationManager.defaultManager.postNotification(.HideMiniPlayer)
    }
}
