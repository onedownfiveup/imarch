//
//  ViewController.swift
//  iMarch
//
//  Created by Constantinos Mavromoustakos on 1/28/17.
//  Copyright © 2017 Constantinos Mavromoustakos. All rights reserved.
//

import UIKit

class HomeController: UIViewController {    
    @IBAction func hamburgerIconTouched(_ sender: Any) {
        if let slidingMenuController = self.slideMenuController() {
            slidingMenuController.openRight()
        }
    }
    
    @IBAction func marchButtonTouched(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        if let viewController = storyboard.instantiateViewController(withIdentifier: "ActionsController") as? ActionCollectionViewController {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kmenuBttonTapped),
                                            object: viewController)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

