//
//  RootViewController.swift
//  Podclass
//
//  Created by Alan Scarpa on 3/20/16.
//  Copyright © 2016 Podclass. All rights reserved.
//

import UIKit
import EasyAnimation

class HomeViewController: UIViewController {
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var podclassLabel: UILabel!
    @IBOutlet weak var listenAndLearnLabel: UILabel!
    @IBOutlet weak var classTableView: UITableView!
    
    var dummyModels = []
    var animationDidPlay = false
    
    @IBOutlet weak var podclassLabelTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        self.createDummyModels()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !self.animationDidPlay {
            self.launchIntroAnimation()
            self.animationDidPlay = true
        }
    }
    
    private func setUp() {
        topBarView.setBottomBorderWithColor(UIColor.pcOrange().CGColor, width: 2.0)
        self.topBarView.alpha = 0
        self.podclassLabel.alpha = 0
        self.listenAndLearnLabel.alpha = 0
        self.classTableView.alpha = 0
        self.classTableView.registerNib(UINib(nibName: ClassTableViewCell.className(), bundle: nil), forCellReuseIdentifier: ClassTableViewCell.className())
        self.classTableView.backgroundColor = UIColor(patternImage: UIImage(named: "tableViewBackground")!)
    }
    
    private func createDummyModels() {
        let class1 = PCClass()
        class1.name = "How to Ace the Product Management Interview"
        class1.homeImageName = "girlCoffee"
        class1.summary = "What are the most commonly asked Product Management interview questions? How can you best prepare so that you can ace your interview? Walk through the 8 Most Common Interview Questions, according to Madhu Punjabi - Product Manager at Pinterest."
        class1.whatYouLearn = "A real sense of what you will be asked in your Product Management interview. For each of the commonly asked questions, we'll go over what interviewers are looking for in a response as well as some sample responses."
        class1.whoItsFor = "Aspiring PMs who soon face their first PM interview. Folks who've become PMs at their current company by way of promotion and must now face their first real PM interview with another company. "
        let lesson1 = PCLesson(number: 1, title: "Why do you want to work here?")
        let lesson2 = PCLesson(number: 2, title: "How would you improve our product?")
        let lesson3 = PCLesson(number: 3, title: "What's your favorite product and why?")
        let lesson4 = PCLesson(number: 4, title: "What are the 3 metrics we care about?")
        let lesson5 = PCLesson(number: 5, title: "How do you prioritize between X and Y?")
        let lesson6 = PCLesson(number: 6, title: "How would you test a feature?")
        let lesson7 = PCLesson(number: 7, title: "Have you had to convince someone who didn't report to you to do something?")
        let lesson8 = PCLesson(number: 8, title: "Do you have any questions for me?")
        class1.syllabus = [lesson1, lesson2, lesson3, lesson4, lesson5, lesson6, lesson7, lesson8]
        class1.producedBy = "Podclass, in conjunction with Madhu Punjabi, Product Manager @ Pinterest"
        let class2 = PCClass()
        class2.name = "Think Like An iOS Developer"
        class2.homeImageName = "girlComputer"
        let class3 = PCClass()
        class3.name = "Designing for Mobile"
        class3.homeImageName = "computerHands"
        self.dummyModels = [class1, class2, class3]
    }
    
    private func launchIntroAnimation() {
        UIView.animateAndChainWithDuration(1.0, delay: 0,
            options: [], animations: {
                self.podclassLabel.alpha = 1
            }, completion: nil).animateWithDuration(1.0, delay: 0.05, options: [.CurveEaseIn], animations: {
                self.listenAndLearnLabel.alpha = 1
            }, completion: nil).animateWithDuration(2, delay: 0.5, options: [.CurveEaseOut], animations: {
                self.podclassLabel.center.y = (self.navigationController?.navigationBar.bounds.maxY)!
                self.listenAndLearnLabel.center.y += (self.navigationController?.navigationBar.bounds.maxY)!
                self.listenAndLearnLabel.alpha = 0
            }, completion: nil).animateWithDuration(0.25, delay: 0, options: [.CurveEaseOut], animations: {
                self.topBarView.alpha = 1
                self.classTableView.alpha = 1
            }, completion: { complete in
                self.view.layoutSubviews()
                self.podclassLabel.layer.zPosition = 10
                self.podclassLabelTopConstraint.constant = 14
            })
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dummyModels.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ClassTableViewCell.className(), forIndexPath: indexPath) as! ClassTableViewCell
        if let pcClass = self.dummyModels[indexPath.row] as? PCClass {
            cell.configureForClass(pcClass)
        }
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)  {
        let vc = PitchViewController.initWithDefaultNib()
        if let currentClass = self.dummyModels[indexPath.row] as? PCClass {
            vc.currentClass = currentClass
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    

}

