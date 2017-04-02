//
//  ContainerViewController.swift
//  iMarch
//
//  Created by Constantinos Mavromoustakos on 2/14/17.
//  Copyright © 2017 Constantinos Mavromoustakos. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class ContainerViewController: SlideMenuController {
    var mainController: UIViewController?
    var sideMenuController: UIViewController?
    
    init(mainController: UIViewController, sideMenuController: UIViewController) {
        self.mainController = mainController
        self.sideMenuController = sideMenuController
        
        super.init(nibName: nil, bundle: nil)
        self.setupDefaultControllers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDefaultControllers()
    }
    
    private func setupDefaultControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeController: UIViewController
        
        if let _ = UserDefaults.standard.string(forKey: Constants.kUserStateAbbreviationKey) {
            homeController = storyboard.instantiateViewController(withIdentifier: "HomeController")
       } else {
            homeController = storyboard.instantiateViewController(withIdentifier: "CountrySelectViewController")
        }
        
        self.mainViewController = homeController

        let sideController = storyboard.instantiateViewController(withIdentifier: "SideMenu")
        self.rightViewController = sideController
        
        SlideMenuOptions.rightViewWidth = UIScreen.main.bounds.width
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeController(notification:)),
                                               name: NSNotification.Name(rawValue: Constants.kmenuBttonTapped),
                                               object: nil)
    }

    internal func add(viewController: UIViewController) {
        guard let currentController = slideMenuController()?.mainViewController else {
            return
        }
        
        self.mainViewController = viewController
        viewController.view.alpha = 0.2
        viewController.view.frame = viewController.view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(viewController.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            currentController.view.alpha = 0
            viewController.view.alpha = 1
        }, completion: {  finished in
            self.addChildViewController(viewController)
            viewController.didMove(toParentViewController: self)
        })
        
    }

    @objc internal func changeController(notification: NSNotification) {
        guard let viewController = notification.object as? UIViewController else {
            return
        }
        add(viewController: viewController)
    }
}
