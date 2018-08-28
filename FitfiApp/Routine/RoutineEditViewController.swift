//
//  RoutineEditViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-08-28.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit

protocol DataToReceive {
    func dataReceive(data: Int)
}

class RoutineEditViewController: UIViewController {
    var delegate: DataToReceive?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        delegate?.dataReceive(data: 0)
        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
    }
}
