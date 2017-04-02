//
//  CountrySelectViewController.swift
//  iMarch
//
//  Created by Constantinos Mavromoustakos on 2/22/17.
//  Copyright © 2017 Constantinos Mavromoustakos. All rights reserved.
//

import UIKit

class CountrySelectViewController: UIViewController {
    @IBOutlet weak var statePicker: UIPickerView!
    @IBOutlet weak var stateConfirmButton: UIButton!
    
    let stateAbbreviations = [String](Constants.stateDictionary.keys.sorted())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statePicker.dataSource = self;
        self.statePicker.delegate = self;
    }
    
    @IBAction func touchedSelectState(_ sender: Any) {
        let selectedStateIndex = statePicker.selectedRow(inComponent: 0)
        let stateAbbreviation = stateAbbreviations[selectedStateIndex]
        
        UserDefaults.standard.set(stateAbbreviation, forKey: Constants.kUserStateAbbreviationKey)
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        if let viewController = storyboard.instantiateViewController(withIdentifier: "ActionsController") as? ActionCollectionViewController {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kmenuBttonTapped),
                                            object: viewController)
        }
    }
}

extension CountrySelectViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let stateName = Constants.stateDictionary[stateAbbreviations[row]] else {
            return
        }
        
        stateConfirmButton.setTitle("I AM FROM \(stateName)", for: .normal)
    }
    
    func pickerView(_: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.stateDictionary.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 65.0
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        guard let stateName = Constants.stateDictionary[stateAbbreviations[row]] else {
            return nil
        }
        let pickerItemText =  "\(stateAbbreviations[row]) - \(stateName)"
        
        let font = UIFont(name: "Panton-BlackCaps", size: 32)
        let fontColor = UIColor.white
        
        let attributes = [NSFontAttributeName: font,
                          NSForegroundColorAttributeName: fontColor]
        
        let title = NSAttributedString(string: pickerItemText, attributes: attributes)
        
        return title
    }
}
