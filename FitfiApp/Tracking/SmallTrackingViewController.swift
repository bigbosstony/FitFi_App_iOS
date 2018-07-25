//
//  SmallTrackingViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-07-16.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit

class SmallTrackingViewController: UIViewController {
    
    var maxTrackingVC: MaxTrackingViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(expandTrackingSmallView)) //Change This If Needed
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Tap to expand
    @objc func expandTrackingSmallView() {
        maxTrackingVC = MaxTrackingViewController.init(nibName: "MaxTrackingViewController", bundle: nil)
        maxTrackingVC?.delegate = self
        present(maxTrackingVC!, animated: true, completion: nil)
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

extension SmallTrackingViewController: MaxTrackingDelegate {
    var message: String {
        return "Sucess"
    }
}
