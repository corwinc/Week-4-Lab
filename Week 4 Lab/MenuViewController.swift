//
//  MenuViewController.swift
//  Week 4 Lab
//
//  Created by Corwin Crownover on 3/2/16.
//  Copyright © 2016 Corwin Crownover. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    
    // OUTLETS
    var hamburgerViewController: HamburgerViewController!
    
    
    // VIEW DID LOAD

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // FUNCTIONS
    @IBAction func onSubscriptionButton(sender: AnyObject) {
        hamburgerViewController.feedView.addSubview(hamburgerViewController.subscriptionViewController.view)
        
        UIView.animateWithDuration(0.3) { () -> Void in
            self.hamburgerViewController.closeMenu()
        }
    }
    

}
