//
//  AppDelegate.swift
//  iMarch
//
//  Created by Constantinos Mavromoustakos on 1/28/17.
//  Copyright © 2017 Constantinos Mavromoustakos. All rights reserved.
//

import UIKit
import RealmSwift
import Fabric
import TwitterKit
import AWSS3
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UITextView.appearance().tintColor = UIColor.yellow
        
        loadRealmDatabase()
        createLocalNotificationsForMarches()
        
        Fabric.with([Twitter.self])
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if Twitter.sharedInstance().application(app, open:url, options: options) {
            return true
        }
        
        // If you handle other (non Twitter Kit) URLs elsewhere in your app, return true. Otherwise
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        loadRealmDatabase()

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    fileprivate func createLocalNotificationsForMarches() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            let date = Date()
            let triggerDate = Calendar.current.dateComponents([.hour], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
          
            let content = UNMutableNotificationContent()
            content.title = "iMarch - daily march reminder"
            content.body = "iMarch - Democracy needs your voice"
            content.sound = UNNotificationSound.default()

            let identifier = "MarchNotification"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

            center.add(request, withCompletionHandler: { (error) in
                if let error = error {
                    // Something went wrong
                }
            })

        }
    }

    fileprivate func loadRealmDatabase() {
        //        createLocalNotificationsForMarches()
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
                                                                identityPoolId:"<replace with your own>")
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        var senatorFileURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last
        senatorFileURL?.appendPathComponent("senators.realm")
        
        var actionsFileURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last
        actionsFileURL?.appendPathComponent("march_actions.realm")
        
        do {
            if let actionsFileURL = actionsFileURL {
                try FileManager.default.removeItem(at: actionsFileURL)
            }
            if let senatorFileURL = senatorFileURL {
                try FileManager.default.removeItem(at: senatorFileURL)
            }
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        
        // The file URL of the download destination.
        let expression = AWSS3TransferUtilityDownloadExpression ()
        let transferUtility = AWSS3TransferUtility.default()
       
        transferUtility.download( to: actionsFileURL!, bucket: "imarch", key: "march_actions.realm", expression: expression, completionHandler: nil).continueWith {
            (task) -> AnyObject! in if let error = task.error {
                print("Error: \(error.localizedDescription)")
            }
            return nil;
        }
        
        transferUtility.download( to: senatorFileURL!, bucket: "imarch", key: "senators.realm", expression: expression, completionHandler: nil).continueWith {
            (task) -> AnyObject! in if let error = task.error {
                print("Error: \(error.localizedDescription)")
            }
            return nil;
        }

    }


}

