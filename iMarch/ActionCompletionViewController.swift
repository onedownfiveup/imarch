//
//  ActionCompletionViewController.swift
//  iMarch
//
//  Created by Constantinos Mavromoustakos on 2/22/17.
//  Copyright © 2017 Constantinos Mavromoustakos. All rights reserved.
//

import UIKit
import FacebookShare
import Alamofire
import TwitterKit

class ActionCompletionViewController: UIViewController {
    @IBOutlet weak var marchCountLabel: UILabel!
    var marchAction: MarchActions?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let marchAction = marchAction else {
            return
        }
        
        Alamofire.request("https://imarch.herokuapp.com/marches/\(marchAction.identifier)").responseJSON { response in
            if let data = response.result.value as? NSDictionary,
                let marchCount = data["performed_count"] as? NSNumber {
                
                self.marchCountLabel.text = marchCount.stringValue
            }
            
            
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func touchedMarchAgainButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        if let viewController = storyboard.instantiateViewController(withIdentifier: "ActionsController") as? ActionCollectionViewController {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kmenuBttonTapped),
                                            object: viewController)
        }
    }

    @IBAction func touchedHamburgerMenu(_ sender: Any) {
        if let slidingMenuController = self.slideMenuController() {
            slidingMenuController.openRight()
        }
    }

    @IBAction func touchedFacebookButton(_ sender: UIButton) {
        if let url = URL(string: "https://facebook.com/imarchtoday") {
            let content = LinkShareContent(url:url)
            try! ShareDialog.show(from: self, content: content)
        }        
    }
    
    @IBAction func touchedTwitterButton(_ sender: UIButton) {
        guard let marchAction = marchAction else {
            return
        }
        
        let composer = TWTRComposer()
        let message = "I completed MARCH #\(marchAction.identifier) on the iMarch app http://apple.co/2mebv9M"

        composer.setText(message)
        
        composer.setImage(UIImage(named: "logo_small"))
        
        // Called from a UIViewController
        composer.show(from: self) { result in
            if (result == TWTRComposerResult.cancelled) {
                print("Tweet composition cancelled")
            }
            else {
                print("Sending tweet!")
            }
        }
    }
}
