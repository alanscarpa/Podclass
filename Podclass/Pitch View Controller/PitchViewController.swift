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
    
    fileprivate func setUp() {
        self.syllabusTableView.register(UINib(nibName: SyllabusTableViewCell.className(), bundle: nil), forCellReuseIdentifier: SyllabusTableViewCell.className())
    }
    
    fileprivate func configureUI() {
        
        self.headerImageView.image = UIImage(named: self.currentClass.homeImageName)
        self.classTitleLabel.text = self.currentClass.name
        self.summaryBodyLabel.text = self.currentClass.summary
        self.whatYouLearnBodyLabel.text = self.currentClass.whatYouLearn
        self.whoItsForBodyLabel.text = self.currentClass.whoItsFor
        self.producedByBodyLabel.text = self.currentClass.producedBy
    }
    
    // Actions
    
    @IBAction func backButtonTapped() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startClassButtonTapped() {
        let classVC = ClassViewController.initWithDefaultNib()
        classVC.currentClass = self.currentClass
        self.navigationController?.pushViewController(classVC, animated: true)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentClass.syllabus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SyllabusTableViewCell.className(), for: indexPath) as! SyllabusTableViewCell
        cell.configureForLesson(self.currentClass.syllabus[(indexPath as NSIndexPath).row])
        return cell
    }
    
   
    

}
