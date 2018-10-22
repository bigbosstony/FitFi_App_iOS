//
//  FirstViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-09-19.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet var backGroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        gradient.frame = view.bounds
        gradient.colors = [camoGreen, fadedOrange]
//        self.view.layer.insertSublayer(gradient, at: 0)

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        self.view.layer.insertSublayer(gradient, at: 0)
    }
//
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)

//        backGroundView.layer.insertSublayer(gradient, at: 0)
    }

}
