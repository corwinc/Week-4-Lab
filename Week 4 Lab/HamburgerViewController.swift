//
//  HamburgerViewController.swift
//  Week 4 Lab
//
//  Created by Corwin Crownover on 2/25/16.
//  Copyright © 2016 Corwin Crownover. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {
    
    // OUTLETS
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var feedView: UIView!
    
    var menuViewController: MenuViewController!
    var feedViewController: UIViewController!
    var subscriptionViewController: UIViewController!
    
    var feedViewInitialCenter: CGPoint!
    var feedViewRight: CGPoint!
    var feedViewLeft: CGPoint!
    
    var rotation: CGFloat!
    var foreshortening: CGFloat!
    
    
    
    // VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedViewInitialCenter = feedView.center
        
        
        // MANAGING VIEW CONTROLLERS FROM MENU VC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        menuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        feedViewController = storyboard.instantiateViewControllerWithIdentifier("FeedViewController")
        subscriptionViewController = storyboard.instantiateViewControllerWithIdentifier("SubscriptionViewController")
        
        menuViewController.view.frame = menuView.frame
        menuView.addSubview(menuViewController.view)
        
        feedViewController.view.frame = feedView.frame
        feedView.addSubview(feedViewController.view)
        
        menuViewController.hamburgerViewController = self
        
        feedViewRight = CGPoint(x: 434, y: 284)
        feedViewLeft = CGPoint(x: 160, y: 284)
        
        
        // ROTATION
        //rotation = 0
        //foreshortening = 100
        //setAnchorPoint(CGPoint(x: 1.0, y: 0.5), forView: feedView)

        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    // FUNCTIONS
    @IBAction func didPan(sender: UIPanGestureRecognizer) {
        let location = sender.locationInView(view)
        let velocity = sender.velocityInView(view)
        let translation = sender.translationInView(view)
        

        
        
        // CODE FOR SCALING MENU W/ FEEDVIEW PAN, need to fix so that it fully scales to 1.0 after finger-off
        let menuScale = convertValue(feedView.center.x, r1Min: 160, r1Max: feedViewRight.x, r2Min: 0.9, r2Max: 1)
        menuView.transform = CGAffineTransformMakeScale(menuScale, menuScale)
        
        //rotation = convertValue(feedView.center.x, r1Min: 160, r1Max: feedViewRight.x, r2Min: 0, r2Max: 90)
        //feedView.transform = CGAffineTransformMakeRotation(rotation)
        //updateTransform()
        
        if sender.state == .Began {
            print("began panning")
            
            feedViewInitialCenter = feedView.center
        
        } else if sender.state == .Changed {
            print("is panning: \(location)")
            
            feedView.center = CGPoint(x: feedViewInitialCenter.x + translation.x, y: feedViewInitialCenter.y)
            

        } else if sender.state == .Ended {
            print("finished panning")
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                if velocity.x > 0 {
                    self.feedView.center = self.feedViewRight
                    self.menuView.transform = CGAffineTransformMakeScale(1, 1)
                } else if velocity.x < 0 {
                    self.feedView.center = self.feedViewLeft
                    self.menuView.transform = CGAffineTransformMakeScale(0.9, 0.9)
                }
            })
        
        }
    }

    
    func closeMenu() {
        feedView.frame.origin.x = 0
    }
    
    

    func updateTransform() {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / CGFloat(foreshortening)
        
        let angle = rotation * CGFloat(M_PI) / 180.0
        transform = CATransform3DRotate(transform, angle, 0, 1, 0)
        
        feedView.layer.transform = transform
    }

    
    func setAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPointMake(feedView.bounds.size.width * anchorPoint.x, feedView.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPointMake(feedView.bounds.size.width * feedView.layer.anchorPoint.x, feedView.bounds.size.height * feedView.layer.anchorPoint.y)
        
        newPoint = CGPointApplyAffineTransform(newPoint, feedView.transform)
        oldPoint = CGPointApplyAffineTransform(oldPoint, feedView.transform)
        
        var position = feedView.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.y
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        feedView.layer.position = position
        feedView.layer.anchorPoint = anchorPoint
    }

    
    
}