//
//  ActionCollectionViewController.swift
//  iMarch
//
//  Created by Constantinos Mavromoustakos on 1/28/17.
//  Copyright © 2017 Constantinos Mavromoustakos. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import TwitterKit

private let reuseIdentifier = "actionCell"

final class ActionCollectionViewController: UICollectionViewController {
    private var actions: Array<MarchActions>
    
    required init? (coder: NSCoder) {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        actions = ActionManager.actionsForDay(day: day)
        
        while(actions.count == 0) {
            NSLog("Searching for actions")
            actions = ActionManager.actionsForDay(day: day)
        }
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addHamburgerMenuButton()
        
        self.collectionView?.backgroundView = UIImageView(image: UIImage(named: "actions_background.png"))
    }
    
    private func addHamburgerMenuButton() {
        let hamburgerImage = UIImage(named: "hamburger-icon.png")
        
        let imageX = UIScreen.main.bounds.width - 57
        let hamburgerMenuButton = UIButton(frame: CGRect(x: imageX, y: 50, width: 27, height: 18))
        hamburgerMenuButton.setImage(hamburgerImage, for: .normal)
        hamburgerMenuButton.addTarget(self,
                                      action: #selector(hamburgerMenuTapped),
                                      for: .touchUpInside)
        
        self.view.addSubview(hamburgerMenuButton)        
    }
    
    func hamburgerMenuTapped() {
        if let slidingMenuController = slideMenuController() {
            slidingMenuController.openRight()
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! ActionCollectionViewCell

        let action = actions[indexPath.row]
        cell.titleLabel.text = "MARCH #\(action.identifier)"
        cell.descriptionLabel.text = action.title
        cell.marchAction = action
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }
}

extension ActionCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = UIScreen.main.bounds.width * 0.90
        var cellHeight = UIScreen.main.bounds.height * 0.45
       
        cellHeight = (cellHeight > 300 ? cellHeight : 300)
    
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let cellInsetX = (UIScreen.main.bounds.width * 0.09) / 2
        
        return UIEdgeInsetsMake(36, cellInsetX, 36, cellInsetX) // UIEdgeInsetsMake(0, 0, 0, 5); // top, left, bottom, right
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 13;
    }

}
