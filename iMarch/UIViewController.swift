//
//  UIViewController.swift
//  iMarch
//
//  Created by Constantinos Mavromoustakos on 3/1/17.
//  Copyright © 2017 Constantinos Mavromoustakos. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func switchToController(identifer: String, withAction: MarchActions?) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        if let viewController = storyboard.instantiateViewController(withIdentifier: identifer) as? UIViewController {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kmenuBttonTapped),
                                            object: viewController)
        }
    }
}
