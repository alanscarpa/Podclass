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
    
    @IBOutlet fileprivate weak var topBarView: UIView!
    @IBOutlet fileprivate weak var podclassLabel: UILabel!
    @IBOutlet fileprivate weak var listenAndLearnLabel: UILabel!
    @IBOutlet fileprivate weak var classTableView: UITableView!
    
    var dummyModels: [PCClass] = []
    var animationDidPlay = false
    
    @IBOutlet weak var podclassLabelTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        createDummyModels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !animationDidPlay {
            launchIntroAnimation()
            animationDidPlay = true
        }
    }
    
    fileprivate func setUp() {
        let statusBarBackgroundView = UIView(frame:
            CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0)
        )
        statusBarBackgroundView.backgroundColor = UIColor.white
        UIApplication.shared.keyWindow?.addSubview(statusBarBackgroundView)
        topBarView.setBottomBorderWithColor(UIColor.pcOrange().cgColor, width: 2.0)
        topBarView.alpha = 0
        podclassLabel.alpha = 0
        listenAndLearnLabel.alpha = 0
        classTableView.alpha = 0
        classTableView.register(UINib(nibName: ClassTableViewCell.className(), bundle: nil), forCellReuseIdentifier: ClassTableViewCell.className())
        classTableView.backgroundColor = UIColor(patternImage: UIImage(named: "tableViewBackground")!)
    }
    
    fileprivate func createDummyModels() {
        let class1 = PCClass()
        class1.name = "How to Switch Careers 5 Times"
        class1.homeImageName = "girlCoffee"
        class1.summary = "What are the most commonly asked Product Management interview questions? How can you best prepare so that you can ace your interview? Walk through the 8 Most Common Interview Questions, according to Madhu Punjabi - Product Manager at Pinterest."
        class1.whatYouLearn = "A real sense of what you will be asked in your Product Management interview. For each of the commonly asked questions, we'll go over what interviewers are looking for in a response as well as some sample responses."
        class1.whoItsFor = "Aspiring PMs who soon face their first PM interview. Folks who've become PMs at their current company by way of promotion and must now face their first real PM interview with another company."
        class1.hashTag = "#PC-101"
        let lesson1 = PCLesson(number: 1, title: "How to Switch Careers 5 Times")
        lesson1.trackID = "0B4p7BGhD3xX5TW02aTJjZm1fX3M"
        lesson1.duration = "14:51"
        class1.syllabus = [lesson1]
        class1.producedBy = "Podclass.  Follow Steph on Twitter: @sostephoh"
        
        let class2 = PCClass()
        class2.name = "Tools of the Trade"
        class2.homeImageName = "girlComputer"
        class2.summary = "This episode from ConceptsInCode teaches you about the essential tools every programmer should know about."
        class2.whatYouLearn = "Quality Coding, Trello, Atlassian, Jira, Pivotal Tracker, Software Estimation, The Cone of Uncertainty, Using Microsoft Project for Agile, BitBucket, SourceTree, Git, GitHub, Tower \n \n Read more at http://conceptsincode.com/#3PjMxHgcP6s4myjw.99"
        class2.whoItsFor = "People new to the programming world and trying to figure out which tools they should start to learn."
        let lesson = PCLesson(number: 1, title: "Tools of the Trade")
        lesson.streamingURLString = "http://traffic.libsyn.com/conceptsincode/CIC_006_Tools_of_the_Trade.mp3?dest-id=280420"
        lesson.duration = "46:33"
        class2.syllabus = [lesson]
        class2.producedBy = "http://conceptsincode.com/"
        
        let class3 = PCClass()
        class3.name = "Analysis Paralysis"
        class3.homeImageName = "computerHands"
        class3.summary = "What is analysis paralysis and how does it affect programmers?"
        class3.whoItsFor = "Anyone who has ever felt analysis paralysis.  Not just limited to programmers!"
        class3.whatYouLearn = "Learn what the pros think about analysis paralysis."
        
        let class3Lesson = PCLesson(number: 1, title: "Analysis Paralysis")
        class3Lesson.streamingURLString = "https://media.simplecast.com/episodes/audio/52652/Analysis_Paralysis.mp3"
        class3Lesson.duration = "19:18"
        class3.syllabus = [class3Lesson]
        class3.producedBy = "Developer Tea https://spec.fm/podcasts/developer-tea"
        dummyModels = [class1, class2, class3]
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
        return dummyModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ClassTableViewCell.className(), for: indexPath) as! ClassTableViewCell
        let pcClass = dummyModels[indexPath.row]
        cell.configureForClass(pcClass)
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)  {
        let vc = PitchViewController.initWithDefaultNib()
        let currentClass = dummyModels[indexPath.row]
        vc.currentClass = currentClass
        navigationController?.pushViewController(vc, animated: true)
    }
}
