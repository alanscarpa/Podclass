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

class ClassViewController: UIViewController {

    var currentClass = PCClass()
    var currentlySelectedCell: PCClassTableViewCell?
    var lastTappedIndexPath: NSIndexPath?
    let audioManager = PCAudioManager.sharedInstance

    @IBOutlet private weak var classTitleLabel: UILabel!
    @IBOutlet private weak var classTableView: UITableView!
    @IBOutlet private weak var classTableViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        self.audioPlayerSync()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ClassViewController.miniPlayerPlayPauseButtonTapped(_:)), name: kMiniPlayerPlayPauseButtonTapped, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ClassViewController.audioStartedPlaying), name: kAudioStartedPlaying, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ClassViewController.audioStoppedPlaying), name: kAudioStoppedPlaying, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ClassViewController.audioFailed), name: kAudioFailed, object: nil)
    }
    
    func audioStartedPlaying() {
        SVProgressHUD.dismiss()
    }
    
    func audioStoppedPlaying() {
        SVProgressHUD.dismiss()
    }
    
    func audioFailed() {
        // TODO: Show alert and handle this error state
        SVProgressHUD.dismiss()
    }
        
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.audioManager.hasCurrentTracks {
            NSNotificationCenter.defaultCenter().postNotificationName(kShowMiniPlayer, object: nil)
        }
        SVProgressHUD.dismiss()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.classTableViewHeightConstraint.constant = classTableView.contentSize.height
    }
    
    func setUpTableView() {
        self.classTableView.allowsMultipleSelection = false
        self.classTableView.multipleTouchEnabled = false
        self.classTitleLabel.text = currentClass.name
        self.classTableView.registerNib(UINib(nibName: PCClassTableViewCell.className(), bundle: nil), forCellReuseIdentifier: PCClassTableViewCell.className())
    }
    
    func audioPlayerSync() {
        if self.audioManager.hasClass(self.currentClass) {
            self.lastTappedIndexPath = self.audioManager.currentLesson.indexPath
        }
    }
    
    func miniPlayerPlayPauseButtonTapped(notification: NSNotification) {
        let indexPath = notification.userInfo!["indexPath"] as! NSIndexPath
        let cellToUpdate = self.classTableView.cellForRowAtIndexPath(indexPath) as! PCClassTableViewCell
        self.updateCellStatus(cellToUpdate, indexPath: indexPath)
    }

    // MARK: Actions
    
    @IBAction func backButtonTapped() {
        self.navigationController?.popViewControllerAnimated(true)
        NSNotificationCenter.defaultCenter().postNotificationName(kHideMiniPlayer, object: nil)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentClass.syllabus.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:
        NSIndexPath) -> UITableViewCell {
        self.currentClass.syllabus[indexPath.row].indexPath = indexPath
        let lessonForRow = self.currentClass.syllabus[indexPath.row]
                let cell = tableView.dequeueReusableCellWithIdentifier(PCClassTableViewCell.className(), forIndexPath: indexPath) as! PCClassTableViewCell
        cell.configureForLesson(lessonForRow)
        cell.isActive = self.audioManager.isPlayingLesson(lessonForRow)
        if cell.isActive {
            self.lastTappedIndexPath = indexPath
        }
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        SVProgressHUD.show()
        self.audioManager.currentClass = self.currentClass
        self.updateCellStatus(self.classTableView.cellForRowAtIndexPath(indexPath) as! PCClassTableViewCell, indexPath: indexPath)
        guard let lastIndexPath = self.lastTappedIndexPath where lastIndexPath != indexPath else {
            self.lastTappedIndexPath = indexPath
            return
        }
        let cell = self.classTableView.cellForRowAtIndexPath(lastIndexPath) as! PCClassTableViewCell
        self.classTableView.deselectRowAtIndexPath(lastIndexPath, animated: true)
        cell.isActive = false
        self.lastTappedIndexPath = indexPath
    }
    
    
    // MARK: Helpers
    
    func updateCellStatus(tappedCell: PCClassTableViewCell, indexPath: NSIndexPath) {
        tappedCell.isActive = !tappedCell.isActive
        NSOperationQueue.mainQueue().addOperationWithBlock { 
            self.audioManager.playLesson(self.currentClass.syllabus[indexPath.row])
        }
        if tappedCell == self.currentlySelectedCell {
            self.classTableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.currentlySelectedCell = nil
        } else {
            self.currentlySelectedCell = tappedCell
        }
    }

    @IBAction func discussionButtonTapped() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            vc.setInitialText("@podclassxyz \(currentClass.hashTag)")
            presentViewController(vc, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Twitter Required", message: "We use Twitter to chat.  If you have an account, go to Settings and connect.  Otherwise, sign up with Twitter and let's get tweeting!", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
