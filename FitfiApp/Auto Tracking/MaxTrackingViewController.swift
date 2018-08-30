//
//  MaxTrackingViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-07-16.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit

protocol MaxTrackingDelegate: class {
    var message: String { get }
}

class MaxTrackingViewController: UIViewController {

    weak var delegate: MaxTrackingDelegate!
    var message: String?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Maxi Tracking VC Loaded")
        print(delegate.message)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
