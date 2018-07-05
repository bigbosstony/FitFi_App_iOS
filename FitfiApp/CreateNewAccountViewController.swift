//
//  CreateNewAccountViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-07-04.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit

class CreateNewAccountViewController: UIViewController {

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
    @IBAction func loginPressed(_ sender: UIButton) {
        print("Login Pressed")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarViewController
        self.present(newViewController, animated: false, completion: nil)}
    
}
