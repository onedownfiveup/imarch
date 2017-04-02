//
//  AboutViewController.swift
//  iMarch
//
//  Created by Constantinos Mavromoustakos on 2/23/17.
//  Copyright © 2017 Constantinos Mavromoustakos. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func touchedBackButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        if let viewController = storyboard.instantiateViewController(withIdentifier: "ActionsController") as? ActionCollectionViewController {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kmenuBttonTapped),
                                            object: viewController)
        }
    }
    
    @IBAction func touchedMenuButton(_ sender: UIButton) {
        if let slidingMenuController = self.slideMenuController() {
            slidingMenuController.openRight()
        }
    }
    
    @IBAction func touchedTwitterButton(_ sender: UIButton) {
        if let url = URL(string: "https://twitter.com/iMarchToday"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler:  nil)
        }
    }
    
    @IBAction func touchedFacebookButton(_ sender: UIButton) {
        if let url = URL(string: "https://facebook.com/iMarchToday"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler:  nil)
        }
    }
}
