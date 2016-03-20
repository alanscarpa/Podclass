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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        self.createDummyModels()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.launchIntroAnimation()
    }
    
    private func setUp() {
        topBarView.setBottomBorderWithColor(UIColor.pcOrange().CGColor, width: 2.0)
        self.topBarView.alpha = 0
        self.podclassLabel.alpha = 0
        self.listenAndLearnLabel.alpha = 0
        self.classTableView.alpha = 0
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.classTableView.registerNib(UINib(nibName: ClassTableViewCell.className(), bundle: nil), forCellReuseIdentifier: ClassTableViewCell.className())
    }
    
    private func createDummyModels() {
        let class1 = PCClass()
        class1.name = "How to Ace the Product Management Interview"
        class1.homeImageName = "girlCoffee"
        let class2 = PCClass()
        class2.name = "Think Like An iOS Developer"
        class2.homeImageName = "computerHands"
        let class3 = PCClass()
        class3.name = "Designing for Mobile"
        class3.homeImageName = "girlComputer"
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
                return complete
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
    
    

}

