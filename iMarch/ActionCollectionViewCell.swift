//
//  ActionCollectionViewCell.swift
//  iMarch
//
//  Created by Constantinos Mavromoustakos on 1/29/17.
//  Copyright © 2017 Constantinos Mavromoustakos. All rights reserved.
//

import UIKit

class ActionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var doItButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var learnMoreButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var doItButtonTrailingMargin: NSLayoutConstraint!
    @IBOutlet weak var learnMoreButtonLeadingMargin: NSLayoutConstraint!
    
    var marchAction: MarchActions?
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBAction func touchedLearnMoreButton(_ sender: Any) {
        if let viewController = storyboard.instantiateViewController(withIdentifier: "ActionLearnMoreController") as? ActionLearnMoreViewController {
            viewController.marchAction = marchAction
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kmenuBttonTapped),
                                            object: viewController)
        }
    }
    @IBAction func touchedMarchNowButton(_ sender: UIButton) {
        if let viewController = storyboard.instantiateViewController(withIdentifier: "ActionDetailViewController") as? ActionDetailViewController {
            viewController.marchAction = marchAction
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kmenuBttonTapped),
                                            object: viewController)
        }
    }
}
