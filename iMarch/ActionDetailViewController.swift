//
//  ActionDetailViewController.swift
//  iMarch
//
//  Created by Constantinos Mavromoustakos on 2/19/17.
//  Copyright © 2017 Constantinos Mavromoustakos. All rights reserved.
//

import UIKit
import TwitterKit
import RealmSwift
import MessageUI
import Alamofire

class ActionDetailViewController: UIViewController {
    @IBOutlet weak var marchNowButton: UIButton!
    var marchAction: MarchActions?

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageTextArea: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let marchAction = marchAction else {
            return
        }
        messageTextArea.delegate = self
        
        titleLabel.text = "MARCH #\(marchAction.identifier)"
        infoLabel.text = marchAction.title
        messageTextArea.text = formatedMessageFor(action: marchAction)
        let tapper = UITapGestureRecognizer(target: self, action:#selector(endEditing))
        tapper.cancelsTouchesInView = false
        view.addGestureRecognizer(tapper)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func touchedHaburgerMenuButton(_ sender: UIButton) {
        if let slidingMenuController = self.slideMenuController() {
            slidingMenuController.openRight()
        }
    }
    
    @IBAction func touchedBackButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        if let viewController = storyboard.instantiateViewController(withIdentifier: "ActionsController") as? ActionCollectionViewController {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kmenuBttonTapped),
                                            object: viewController)
            
        }
    }

    @IBAction func touchedMarchNowButton(_ sender: Any) {
        guard let marchAction = marchAction else {
            return
        }
        
        Alamofire.request("https://imarch.herokuapp.com/marches/\(marchAction.identifier)/perform", method: .post).responseJSON { response in }
        
        ActionManager.perform(action: marchAction, message: messageTextArea.text, on: self) { () -> Void in
            var completedActionOrders = UserDefaults.standard.array(forKey: Constants.kCompletedActionsKey) as? Array<Int>
            
            if var completedActionOrders = completedActionOrders {
                completedActionOrders.append(marchAction.identifier)
                UserDefaults.standard.set(completedActionOrders, forKey: Constants.kCompletedActionsKey)
            } else {
                completedActionOrders = [marchAction.identifier]
                UserDefaults.standard.set(completedActionOrders, forKey: Constants.kCompletedActionsKey)
            }            
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            
            if let viewController = storyboard.instantiateViewController(withIdentifier: "ActionCompletionViewController") as? ActionCompletionViewController {
                viewController.marchAction = marchAction
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kmenuBttonTapped),
                                                object: viewController)
                
            }
        }

    }
    
    private func formatedMessageFor(action: MarchActions) -> String {
        guard let stateAbbreviation = UserDefaults.standard.string(forKey: Constants.kUserStateAbbreviationKey) else {
            return action.message
        }

        if action.type == "tweet_senator" {
            if let senatorsTwitterHandles = Senators.senatorsTwitterHandlesFor(state: stateAbbreviation) {
                let senatorHandlesMessage = senatorsTwitterHandles.joined(separator: " ")
                return "\(senatorHandlesMessage) \(action.message)"
            }
        }        
        return action.message
    }
}

extension ActionDetailViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ActionDetailViewController: UITextViewDelegate {    
    func endEditing() {
        messageTextArea.resignFirstResponder()
    }
}
