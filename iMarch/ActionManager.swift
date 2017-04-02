//
//  ActionManager.swift
//  iMarch
//
//  Created by Constantinos Mavromoustakos on 2/20/17.
//  Copyright © 2017 Constantinos Mavromoustakos. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit
import MessageUI
import RealmSwift
import Realm

struct ActionManager {
    static func perform(action: MarchActions, message: String, on: UIViewController, completion: (() -> Void)?) {
        switch action.type {
        case "tweet":
            performTweet(action: action, message: message, on: on, completion: completion)
            break
        case "tweet_senator":
            performTweet(action: action, message: message, on: on, completion: completion)
            break
        case "email":
            performEmail(action: action, message: message, on: on, completion: completion)
            break
        case "call":
            performCallAction(action: action, message: message, on: on, completion: completion)
            break
        case "call_senator":
            performCallSenatorAction(action: action, message: message, on: on, completion: completion)
            break
        default:
            break
        }
    }
    
    private static func performCallAction(action: MarchActions, message: String, on: UIViewController, completion: (() -> Void)?) {
        if let url = URL(string: "tel://\(action.recipient)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { (Bool) -> Void in
                if let completion = completion {
                    completion()
                }
            }
        }
    }
    
    private static func performCallSenatorAction(action: MarchActions, message: String, on: UIViewController, completion: (() -> Void)?) {
        guard let stateAbbreviation = UserDefaults.standard.string(forKey: Constants.kUserStateAbbreviationKey) else {
            return
        }
        
        guard let senators = Senators.senatorsFor(state: stateAbbreviation) else {
            return
        }
        
        if let senator = senators.first {
            let telephoneNumber = "tel://\(senator.phone)".components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

            if let url = URL(string: "tel://\(telephoneNumber)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:]) { (Bool) -> Void in
                    if let completion = completion {
                        completion()
                    }
                }
            }
        }
    }
    
    private static func performTweet(action: MarchActions,message: String,  on: UIViewController, completion: (() -> Void)?) {
        ActionManager.composeTweet(message: message, on: on, completion: completion)
    }
    
    private static func composeTweet(message: String, on: UIViewController, completion: (() -> Void)?) {
        let composer = TWTRComposer()
        
        composer.setText(message)
        
        // Called from a UIViewController
        composer.show(from: on) { result in
            if (result == TWTRComposerResult.cancelled) {
                print("Tweet composition cancelled")
            }
            else {
                print("Sending tweet!")
                if let completion = completion {
                    completion()
                }
            }
        }
    }
    
    private static func performEmail(action: MarchActions, message: String, on: UIViewController, completion: (() -> Void)?) {
        let composeVC = MFMailComposeViewController()
        let delegate =  on as? MFMailComposeViewControllerDelegate
        composeVC.mailComposeDelegate = delegate
        
        if(MFMailComposeViewController.canSendMail()) {
            // Configure the fields of the interface.
            composeVC.setToRecipients([action.recipient])
            composeVC.setSubject(action.subject)
            composeVC.setMessageBody(message, isHTML: false)
            
            on.present(composeVC, animated: true, completion: nil)
            
            if let completion = completion {
                completion()
            }
        }
    }
    
    static func actionsForDay(day: Int) -> Array<MarchActions> {
        let realmConfig = self.realmConfig()
        let realm = try! Realm(configuration: realmConfig)
        
        return Array(realm.objects(MarchActions.self).filter(NSPredicate.init(format: "day == \(day)")))
    }
    
    static func actionsPriorToDay(day: Int) -> Array<MarchActions> {
        let realmConfig = self.realmConfig()
        let realm = try! Realm(configuration: realmConfig)
        
        return Array(realm.objects(MarchActions.self).filter(NSPredicate.init(format: "day < \(day)")))
    }
    
    static func actionsCompleted() -> Array<MarchActions> {
        let realmConfig = self.realmConfig()
        let realm = try! Realm(configuration: realmConfig)
        
        let completedActionOrders = UserDefaults.standard.array(forKey: Constants.kCompletedActionsKey)
        
        if let completedActionOrders = completedActionOrders {
            let filterPredicate = NSPredicate(format: "identifier IN %@", completedActionOrders)
            return Array(Set(realm.objects(MarchActions.self).filter(filterPredicate)))
        } else {
            return Array()
        }
    }
    
    fileprivate static func realmConfig() -> Realm.Configuration {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        
        let fileManager = FileManager.default
        var fileUrl = Bundle.main.url(forResource: "march_actions", withExtension: "realm")!

        guard let dirPath = paths.first else {
            return Realm.Configuration( fileURL: fileUrl, readOnly: true)
        }
        
        let marchActionsRealmURL = URL(fileURLWithPath: dirPath).appendingPathComponent("march_actions.realm")
        
        if fileManager.fileExists(atPath: marchActionsRealmURL.path) {
            fileUrl = marchActionsRealmURL
        }
        return Realm.Configuration( fileURL: fileUrl, readOnly: true)
    }
}
