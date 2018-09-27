//
//  SignUpViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-09-19.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var emailLineView: UIView!
    @IBOutlet weak var passwordLineView: UIView!
    @IBOutlet weak var firstNameLineView: UIView!
    @IBOutlet weak var lastNameLineView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.attributedPlaceholder = NSAttributedString(string: "EMAIL ADDRESS", attributes: [NSAttributedStringKey.foregroundColor : UIColor.gray])
        password.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [NSAttributedStringKey.foregroundColor : UIColor.gray])
        firstName.attributedPlaceholder = NSAttributedString(string: "FIRST NAME", attributes: [NSAttributedStringKey.foregroundColor : UIColor.gray])
        lastName.attributedPlaceholder = NSAttributedString(string: "LAST NAME", attributes: [NSAttributedStringKey.foregroundColor : UIColor.gray])
        
        // Do any additional setup after loading the view.
        
        email.delegate = self
        password.delegate = self
        firstName.delegate = self
        lastName.delegate = self
        
        email.autocorrectionType = .no
        password.autocorrectionType = .no
        firstName.autocorrectionType = .no
        lastName.autocorrectionType = .no
        
    }

}

extension SignUpViewController: UITextFieldDelegate {
    
    func animateTextField(textField: UITextField, up: Bool)
    {
        let movementDistance:CGFloat = -140
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
//        self.view.viewWithTag(textField.tag + 1)?.constraints.first?.constant = 2
//        self.view.viewWithTag(textField.tag + 1)?.updateConstraints()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.animateTextField(textField: textField, up: false)
//        self.view.viewWithTag(textField.tag + 1)?.constraints.first?.constant = 1
//        self.view.viewWithTag(textField.tag + 1)?.updateConstraints()
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
