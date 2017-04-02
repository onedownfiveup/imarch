//
//  ActionLearnMoreViewController.swift
//  iMarch
//
//  Created by Constantinos Mavromoustakos on 2/17/17.
//  Copyright © 2017 Constantinos Mavromoustakos. All rights reserved.
//

import UIKit

class ActionLearnMoreViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailLabel: UITextView!
    @IBOutlet weak var marchActionButton: UIButton!
    @IBOutlet weak var link1Label: UILabel!
    @IBOutlet weak var link2Label: UILabel!
    
    var marchAction: MarchActions?
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewFromAction()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupViewFromAction() {
        guard let marchAction = self.marchAction else {
            return
        }
        
        titleLabel.text = "MARCH #\(marchAction.identifier)"

        descriptionLabel.text = marchAction.title
        detailLabel.text = marchAction.about        
        
        guard let linksArray = marchAction.additionalLinksArray() else {
            return
        }
        
        link1Label.text = linksArray[safe: 0]
        link2Label.text = linksArray[safe: 1]
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(linkTapped(tap:)))
        tapGestureRecognizer.numberOfTapsRequired = 1;
        link1Label.isUserInteractionEnabled = true
        link1Label.addGestureRecognizer(tapGestureRecognizer)

        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(linkTapped(tap:)))
        link2Label.isUserInteractionEnabled = true
        link2Label.addGestureRecognizer(tapGestureRecognizer2)
    }
    
    @objc private func linkTapped(tap: UIGestureRecognizer) {
        guard  let tappedLabel = tap.view as? UILabel, let labelUrl = tappedLabel.text else {
            return
        }
        
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ActionLinkWebViewController") as? ActionLinkWebViewController {
            if let linkUrl = URL(string: labelUrl) {
                viewController.linkUrlRequest = URLRequest(url: linkUrl)
                self.present(viewController, animated: true, completion: nil)
            }
        }
        
    }

    @IBAction func touchedHaburgerMenuButton(_ sender: Any) {
        if let slidingMenuController = self.slideMenuController() {
            slidingMenuController.openRight()
        }
    }
    
    @IBAction func touchedBackButton(_ sender: UIButton) {
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ActionsController") as? ActionCollectionViewController {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kmenuBttonTapped),
                                            object: viewController)
            
        }
    }

    @IBAction func touchedMarchNowButton(_ sender: UIButton) {
        guard let marchAction = marchAction else {
            return
        }
        
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ActionDetailViewController") as? ActionDetailViewController {
            viewController.marchAction = marchAction
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kmenuBttonTapped),
                                            object: viewController)
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
     class MarchActions: Object {
     dynamic var day = 0
     dynamic var title = ""
     dynamic var type = ""
     dynamic var recipient = ""
     dynamic var message = ""
     dynamic var text = ""
     dynamic var subject = ""
     dynamic var about = ""
     dynamic var additional_links = ""
     }
     

    */

}
