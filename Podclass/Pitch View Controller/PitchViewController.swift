//
//  PitchViewController.swift
//  Podclass
//
//  Created by Alan Scarpa on 3/22/16.
//  Copyright © 2016 Podclass. All rights reserved.
//

import UIKit

class PitchViewController: UIViewController {
    
    var currentClass = PCClass()
    
    @IBOutlet fileprivate weak var headerImageView: UIImageView!
    @IBOutlet fileprivate weak var classTitleLabel: PCLabel!
    @IBOutlet fileprivate weak var summaryBodyLabel: UILabel!
    @IBOutlet fileprivate weak var whatYouLearnBodyLabel: UILabel!
    @IBOutlet fileprivate weak var whoItsForBodyLabel: UILabel!
    @IBOutlet fileprivate weak var producedByBodyLabel: UILabel!
    @IBOutlet fileprivate weak var syllabusTableView: UITableView!
    @IBOutlet fileprivate weak var syllabusTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var buttonBackgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        syllabusTableViewHeightConstraint.constant = syllabusTableView.contentSize.height
    }
    
    fileprivate func setUp() {
        automaticallyAdjustsScrollViewInsets = false
        syllabusTableView.register(UINib(nibName: SyllabusTableViewCell.className(), bundle: nil), forCellReuseIdentifier: SyllabusTableViewCell.className())
    }
    
    fileprivate func configureUI() {
        headerImageView.image = UIImage(named: currentClass.homeImageName)
        classTitleLabel.text = currentClass.name
        summaryBodyLabel.text = currentClass.summary
        whatYouLearnBodyLabel.text = currentClass.whatYouLearn
        whoItsForBodyLabel.text = currentClass.whoItsFor
        producedByBodyLabel.text = currentClass.producedBy
    }
    
    // Actions
    
    @IBAction func backButtonTapped() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startClassButtonTapped() {
        let classVC = ClassViewController.initWithDefaultNib()
        classVC.currentClass = currentClass
        navigationController?.pushViewController(classVC, animated: true)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentClass.syllabus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SyllabusTableViewCell.className(), for: indexPath) as! SyllabusTableViewCell
        cell.configureForLesson(currentClass.syllabus[indexPath.row])
        return cell
    }
}
