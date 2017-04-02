//
//  SideMenuViewController.swift
//  iMarch
//
//  Created by Constantinos Mavromoustakos on 2/14/17.
//  Copyright © 2017 Constantinos Mavromoustakos. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
    @IBInspectable var fontSize: CGFloat = 59.0
    @IBInspectable var fontFamily: String = "DIN Light"
    
    enum SideMenuButtons: Int {
        case todays
        case your
        case previous
        case about
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func touchedMenuButton(_ sender: UIButton) {
        var switchController: UIViewController?
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch sender.tag {
        case SideMenuButtons.previous.rawValue:
            let date = Date()
            let calendar = Calendar.current
            let day = calendar.component(.day, from: date)
            
            switchController = storyboard.instantiateViewController(withIdentifier: "ArchiveViewController")
            
            if let switchController = switchController  as?  ArchiveViewController {
                switchController.actions = ActionManager.actionsPriorToDay(day: day)
                switchController.titleLabelText = "PREVIOUS MARCHES"
            }
            break
        case SideMenuButtons.todays.rawValue:
            switchController = storyboard.instantiateViewController(withIdentifier: "ActionsController")
            break
        case SideMenuButtons.your.rawValue:
            switchController = storyboard.instantiateViewController(withIdentifier: "ArchiveViewController")
            
            if let switchController = switchController  as?  ArchiveViewController {
                switchController.actions = ActionManager.actionsCompleted()
                switchController.titleLabelText = "YOUR MARCHES"
            }

            break
        case SideMenuButtons.about.rawValue:
            switchController = storyboard.instantiateViewController(withIdentifier: "AboutViewController")
            break
        default:
            break
        }
        
        guard let _ = switchController else {
            return
        }
        
        self.slideMenuController()?.closeRight()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kmenuBttonTapped),
                                        object: switchController)

    }
 }
