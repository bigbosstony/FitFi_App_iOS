//
//  MaxTrackingViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-07-16.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit

protocol MaxTrackingDelegate: class {
    var message: Int { get }
}

class MaxTrackingViewController: UIViewController {

    weak var delegate: MaxTrackingDelegate!
    var message: Int?
    
    var timer = Timer()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Maxi Tracking VC Loaded")
        //MARK: Testing Timer
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(updateRandomInt), userInfo: nil, repeats: true)

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Testing Function
    @objc func updateRandomInt() {
        print(delegate.message)
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
