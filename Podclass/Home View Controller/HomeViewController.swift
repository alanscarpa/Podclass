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
    
    var dummyModels: [PCClass] = []
    var animationDidPlay = false
    
    @IBOutlet weak var podclassLabelTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        self.createDummyModels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !self.animationDidPlay {
            self.launchIntroAnimation()
            self.animationDidPlay = true
        }
    }
    
    fileprivate func setUp() {
        let statusBarBackgroundView = UIView(frame:
            CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0)
        )
        statusBarBackgroundView.backgroundColor = UIColor.white
        UIApplication.shared.keyWindow?.addSubview(statusBarBackgroundView)
        topBarView.setBottomBorderWithColor(UIColor.pcOrange().cgColor, width: 2.0)
        self.topBarView.alpha = 0
        self.podclassLabel.alpha = 0
        self.listenAndLearnLabel.alpha = 0
        self.classTableView.alpha = 0
        self.classTableView.register(UINib(nibName: ClassTableViewCell.className(), bundle: nil), forCellReuseIdentifier: ClassTableViewCell.className())
        self.classTableView.backgroundColor = UIColor(patternImage: UIImage(named: "tableViewBackground")!)
    }
    
    fileprivate func createDummyModels() {
        let class1 = PCClass()
        class1.name = "How to Ace the Product Management Interview"
        class1.homeImageName = "girlCoffee"
        class1.summary = "What are the most commonly asked Product Management interview questions? How can you best prepare so that you can ace your interview? Walk through the 8 Most Common Interview Questions, according to Madhu Punjabi - Product Manager at Pinterest."
        class1.whatYouLearn = "A real sense of what you will be asked in your Product Management interview. For each of the commonly asked questions, we'll go over what interviewers are looking for in a response as well as some sample responses."
        class1.whoItsFor = "Aspiring PMs who soon face their first PM interview. Folks who've become PMs at their current company by way of promotion and must now face their first real PM interview with another company. "
        class1.hashTag = "#PM-101"
        let lesson1 = PCLesson(number: 1, title: "Why do you want to work here?")
        lesson1.trackID = "0B4p7BGhD3xX5RkFST3RPdUVyb0E"
        lesson1.duration = "03:24"
        let lesson2 = PCLesson(number: 2, title: "How would you improve our product?")
        lesson2.trackID = "0B4p7BGhD3xX5X1V6UEtNcjRyMUE"
        lesson2.duration = "02:55"

        let lesson3 = PCLesson(number: 3, title: "What's your favorite product and why?")
        lesson3.trackID = "0B4p7BGhD3xX5QzU4YVg3WnNVek0"
        lesson3.duration = "03:12"

        let lesson4 = PCLesson(number: 4, title: "What are the 3 metrics we care about?")
        lesson4.trackID = "0B4p7BGhD3xX5NFp2S2Z4WjlQMk0"
        lesson4.duration = "03:59"

        let lesson5 = PCLesson(number: 5, title: "How do you prioritize between X and Y?")
        lesson5.trackID = "0B4p7BGhD3xX5cTV6YXQwT1Jwc0k"
        lesson5.duration = "03:11"

        let lesson6 = PCLesson(number: 6, title: "How would you test a feature?")
        lesson6.trackID = "0B4p7BGhD3xX5VENnZEEtb1lfNDA"
        lesson6.duration = "02:24"

        let lesson7 = PCLesson(number: 7, title: "Have you had to convince someone who didn't report to you to do something?")
        lesson7.trackID = "0B4p7BGhD3xX5RkFST3RPdUVyb0E"
        lesson7.duration = "02:55"

        let lesson8 = PCLesson(number: 8, title: "Do you have any questions for me?")
        lesson8.trackID = "0B4p7BGhD3xX5X1V6UEtNcjRyMUE"
        lesson8.duration = "03:45"

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
    
    fileprivate func launchIntroAnimation() {
        UIView.animateAndChain(withDuration: 1.0, delay: 0,
            options: [], animations: {
                self.podclassLabel.alpha = 1
            }, completion: nil).animate(withDuration: 1.0, delay: 0.05, options: [.curveEaseIn], animations: {
                self.listenAndLearnLabel.alpha = 1
            }, completion: nil).animate(withDuration: 2, delay: 0.5, options: [.curveEaseOut], animations: {
                self.podclassLabel.center.y = (self.navigationController?.navigationBar.bounds.maxY)!
                self.listenAndLearnLabel.center.y += (self.navigationController?.navigationBar.bounds.maxY)!
                self.listenAndLearnLabel.alpha = 0
            }, completion: nil).animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: {
                self.topBarView.alpha = 1
                self.classTableView.alpha = 1
            }, completion: { complete in
                self.view.layoutSubviews()
                self.podclassLabel.layer.zPosition = 10
                self.podclassLabelTopConstraint.constant = 14
            })
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dummyModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ClassTableViewCell.className(), for: indexPath) as! ClassTableViewCell
        let pcClass = self.dummyModels[(indexPath as NSIndexPath).row]
        cell.configureForClass(pcClass)
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)  {
        let vc = PitchViewController.initWithDefaultNib()
        let currentClass = self.dummyModels[(indexPath as NSIndexPath).row]
        vc.currentClass = currentClass
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

