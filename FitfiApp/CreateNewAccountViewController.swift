//
//  CreateNewAccountViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-07-04.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit

class CreateNewAccountViewController: UIViewController {

    @IBOutlet weak var backGroundView: UIView!
    let gradient = CAGradientLayer()
    let camoGreen = UIColor(red: 57.0 / 255.0, green: 40.0 / 255.0, blue: 29.0 / 255.0, alpha: 1.0).cgColor
    let fadedOrange = UIColor(red: 237.0 / 255.0, green: 146.0 / 255.0, blue: 98.0 / 255.0, alpha: 1.0).cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        gradient.frame = view.bounds
        gradient.colors = [camoGreen, fadedOrange]
        
        backGroundView.layer.insertSublayer(gradient, at: 0)
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
        self.present(newViewController, animated: true, completion: nil)
        UserDefaults.standard.setValue(true, forKey: "hasLoginKey")
        //MARK: Delete
        UserDefaults.standard.setValue(Date(), forKey: "date")
        
    }
}
