//
//  SocialWebViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-10-15.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit
import WebKit

class SocialWebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var urlString: String = "http://viateams.com/social"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        webView.load(request)
        print("after loding")
//        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
//    deinit {
//        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
//    }
    
    @IBAction func reload(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("Social Page Did Appear")
    }
    
}
