//
//  ArchiveViewController.swift
//  iMarch
//
//  Created by Constantinos Mavromoustakos on 2/23/17.
//  Copyright © 2017 Constantinos Mavromoustakos. All rights reserved.
//

import UIKit

class ArchiveViewController: UIViewController {
    var titleLabelText = ""

    fileprivate let reuseIdentifier = "ArchiveViewCell"
    var actions: Array<MarchActions>

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    required init? (coder: NSCoder) {
        actions = ActionManager.actionsForDay(day: 2)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.text = titleLabelText
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func touchedHamburgerMenue(_ sender: UIButton) {
        if let slidingMenuController = self.slideMenuController() {
            slidingMenuController.openRight()
        }
    }
}

extension ArchiveViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        if let viewController = storyboard.instantiateViewController(withIdentifier: "ActionDetailViewController") as? ActionDetailViewController {
            viewController.marchAction = actions[indexPath.row]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kmenuBttonTapped),
                                            object: viewController)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = UIScreen.main.bounds.width * 0.90
        let cellHeight = UIScreen.main.bounds.height * 0.27
        
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let cellInsetX = (UIScreen.main.bounds.width * 0.09) / 2
        
        return UIEdgeInsetsMake(0, cellInsetX, 0, cellInsetX) // UIEdgeInsetsMake(0, 0, 0, 5); // top, left, bottom, right
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 13;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ArchiveCollectionViewCell
        
        let action = actions[indexPath.row]
        cell.titleLabel.text = "MARCH #\(action.identifier)"
        cell.descriptionLabel.text = action.title
        
        return cell
    }
}
