//
//  ActionLinkWebViewController.swift
//  iMarch
//
//  Created by Constantinos Mavromoustakos on 2/18/17.
//  Copyright © 2017 Constantinos Mavromoustakos. All rights reserved.
//

import UIKit

class ActionLinkWebViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    var linkUrlRequest: URLRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let linkUrlRequest = linkUrlRequest {
            self.webView.loadRequest(linkUrlRequest)
        }
    }

    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
