//
//  CreateNewAccountViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-07-04.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.attributedPlaceholder = NSAttributedString(string: "EMAIL ADDRESS", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        password.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        
        gradient.frame = view.bounds
        gradient.colors = [camoGreen, fadedOrange]
//        self.view.layer.insertSublayer(gradient, at: 0)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        email.delegate = self
        password.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        self.view.layer.insertSublayer(gradient, at: 0)
    }
    //
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print("login view will dissapear")
//        self.view.layer.insertSublayer(gradient, at: 0)
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

extension LoginViewController: UITextFieldDelegate {
    func animateTextField(textField: UITextField, up: Bool)
    {
        let movementDistance:CGFloat = -110
        let movementDuration: Double = 0.3
        
        var movement:CGFloat = 0
        if up
        {
            movement = movementDistance
        }
        else
        {
            movement = -movementDistance
        }
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.animateTextField(textField: textField, up: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.animateTextField(textField: textField, up: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        
        return true
    }
}
