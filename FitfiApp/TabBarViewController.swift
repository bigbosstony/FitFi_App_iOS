//
//  TabBarViewController.swift
//  FitfiApp
//
//  Created by Yan Yu on 2018-06-18.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    var trackingVC: UIViewController!
    var window: UIWindow!
    
    let subView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Tab Bar Controller Loaded")
        
//        subView.frame = CGRect(x: 0, y: 497.5, width: 375, height: 120)
//        subView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        trackingVC = TrackingSViewController.init(nibName: "TrackingSViewController", bundle: nil)
        trackingVC.view.frame = CGRect(x: 0, y: 497.5, width: 375, height: 120)
        view.addSubview(trackingVC.view!)
        trackingVC.view.isHidden = false
        
        // Do any additional setup after loading the view.
//        window = UIApplication.shared.keyWindow!
//        window.addSubview(trackingVC.view!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
