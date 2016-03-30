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
    
    @IBOutlet private weak var headerImageView: UIImageView!
    @IBOutlet private weak var classTitleLabel: PCLabel!
    @IBOutlet private weak var summaryBodyLabel: UILabel!
    @IBOutlet private weak var whatYouLearnBodyLabel: UILabel!
    @IBOutlet private weak var whoItsForBodyLabel: UILabel!
    @IBOutlet private weak var producedByBodyLabel: UILabel!
    @IBOutlet private weak var syllabusTableView: UITableView!
    @IBOutlet private weak var syllabusTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var buttonBackgroundView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.setUp()
        self.configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.syllabusTableViewHeightConstraint.constant = syllabusTableView.contentSize.height
    }
    
    private func setUp() {
        self.syllabusTableView.registerNib(UINib(nibName: SyllabusTableViewCell.className(), bundle: nil), forCellReuseIdentifier: SyllabusTableViewCell.className())
    }
    
    private func configureUI() {
        
        self.headerImageView.image = UIImage(named: self.currentClass.homeImageName)
        self.classTitleLabel.text = self.currentClass.name
        self.summaryBodyLabel.text = self.currentClass.summary
        self.whatYouLearnBodyLabel.text = self.currentClass.whatYouLearn
        self.whoItsForBodyLabel.text = self.currentClass.whoItsFor
        self.producedByBodyLabel.text = self.currentClass.producedBy
    }
    
    // Actions
    
    @IBAction func backButtonTapped() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func startClassButtonTapped() {
        let classVC = ClassViewController.initWithDefaultNib()
        classVC.currentClass = self.currentClass
        self.navigationController?.pushViewController(classVC, animated: true)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentClass.syllabus.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SyllabusTableViewCell.className(), forIndexPath: indexPath) as! SyllabusTableViewCell
        cell.configureForLesson(self.currentClass.syllabus[indexPath.row])
        return cell
    }
    
   
    

}
