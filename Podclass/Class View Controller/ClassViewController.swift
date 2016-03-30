//
//  ClassViewController.swift
//  Podclass
//
//  Created by Alan Scarpa on 3/30/16.
//  Copyright © 2016 Podclass. All rights reserved.
//

import UIKit

class ClassViewController: UIViewController {

    var currentClass = PCClass()
    var currentlySelectedCell: PCClassTableViewCell?
    var lastTappedIndexPath: NSIndexPath?
    
    @IBOutlet private weak var classTitleLabel: UILabel!
    @IBOutlet private weak var classTableView: UITableView!
    @IBOutlet private weak var classTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var nowPlayingTrackName: UILabel!
    @IBOutlet private weak var nowPlayingTrackNumber: UILabel!
    @IBOutlet weak var nowPlayingButton: UIButton!
    @IBOutlet weak var nowPlayingBackgroundView: PCView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        self.setUpUI()
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
    
    func setUpUI() {
        self.nowPlayingBackgroundView.topBorderColor = UIColor.pcOrange()
    }

    // Actions
    
    @IBAction func backButtonTapped() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentClass.syllabus.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCellWithIdentifier(PCClassTableViewCell.className(), forIndexPath: indexPath) as! PCClassTableViewCell
        cell.configureForLesson(self.currentClass.syllabus[indexPath.row])
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let tappedCell = tableView.cellForRowAtIndexPath(indexPath) as! PCClassTableViewCell
        self.updateCellStatus(tappedCell)
        self.updateNowPlayingPlayer(tappedCell.lesson)
        if tappedCell == self.currentlySelectedCell {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.currentlySelectedCell = nil
        } else {
            self.currentlySelectedCell = tappedCell
        }
        self.lastTappedIndexPath = indexPath
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        self.updateCellStatus(tableView.cellForRowAtIndexPath(indexPath) as! PCClassTableViewCell)
    }
    
    func updateCellStatus(tappedCell: PCClassTableViewCell) {
        tappedCell.isActive = !tappedCell.isActive
    }
    
    func updateNowPlayingPlayer(lesson: PCLesson) {
        self.nowPlayingTrackNumber.text = "\(lesson.number))."
        self.nowPlayingTrackName.text = lesson.title
        let playIconImage = lesson.isPlaying ? UIImage(named: "pauseButton") : UIImage(named: "playButton")
        self.nowPlayingButton.setImage(playIconImage, forState: .Normal)
    }

    @IBAction func nowPlayingButtonTapped(sender: AnyObject) {
        if let currentlySelectedCell = self.currentlySelectedCell {
            currentlySelectedCell.isActive = !currentlySelectedCell.lesson.isPlaying
            self.updateNowPlayingPlayer(currentlySelectedCell.lesson)
            if let indexPath = self.classTableView.indexPathForCell(currentlySelectedCell) {
                classTableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            self.currentlySelectedCell = nil
        } else if let indexPath = self.lastTappedIndexPath {
            let tappedCell = self.classTableView.cellForRowAtIndexPath(indexPath) as! PCClassTableViewCell
            self.classTableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .None)
            self.updateCellStatus(tappedCell)
            self.updateNowPlayingPlayer(tappedCell.lesson)
            self.currentlySelectedCell = tappedCell
        }
    }

}
