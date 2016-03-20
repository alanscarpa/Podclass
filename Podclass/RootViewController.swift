//
//  RootViewController.swift
//  Podclass
//
//  Created by Alan Scarpa on 3/20/16.
//  Copyright © 2016 Podclass. All rights reserved.
//

import UIKit
import EasyAnimation

class RootViewController: UIViewController {
        
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var podclassLabel: UILabel!
    @IBOutlet weak var listenAndLearnLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topBarView.setBottomBorderWithColor(UIColor(red: 245/255.0, green: 124/255.0, blue: 0/255.0, alpha: 1).CGColor, width: 2.0)
        self.topBarView.alpha = 0
        self.podclassLabel.alpha = 0
        self.listenAndLearnLabel.alpha = 0
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.launchIntroAnimation()
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
                }, completion: { complete in
                    return complete
                })
    }

}

