//
//  SignUpWithPhoneViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-10-22.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit

class SignUpWithPhoneViewController: UIViewController {

    @IBOutlet weak var phoneNumber: UITextField!
    let fitfiOTPKey = "hpyDZSO9CVjQ66YmmMIcsXcOUONmmIsM"
    override func viewDidLoad() {
        super.viewDidLoad()

        phoneNumber.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        phoneNumber.keyboardType = .numberPad
        phoneNumber.delegate = self
        phoneNumber.autocorrectionType = .no
        
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if phoneNumber.text?.count == 10 {
            //Send Request
            
            registerPhoneNumber(phoneNumber: phoneNumber.text!)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSignUpWithEnterOTPVC" {
            let destinationVC = segue.destination as! SignUpWithEnterOTPViewController
            destinationVC.phoneNumber = phoneNumber.text
        }
    }
}

extension SignUpWithPhoneViewController: UITextFieldDelegate {
    //MARK: Set Max Length to 10 Digit
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 10 // Bool
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }
}

extension SignUpWithPhoneViewController {
    func registerPhoneNumber(phoneNumber: String) {
        let strURL =  "https://api.authy.com/protected/json/phones/verification/start?api_key="+fitfiOTPKey+"&via=sms&phone_number="+phoneNumber+"&country_code=1"
        guard let requestURL = URL(string: strURL) else { print("URL Error"); return }
        
        var OTPURLRequest = URLRequest(url: requestURL)
        OTPURLRequest.httpMethod = "POST"
        
        OTPURLRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: OTPURLRequest)  { data, response, error in
            
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            print(json)
            
            if let dictionary = json as? [String: Any] {
                print(dictionary)
                if let number = dictionary["success"] as? Int {
                    print(number)
                    if(number == 0)
                    {
//                        alert
                    }
                    else if(number == 1)
                    {
                        //go to next vc
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "goToSignUpWithEnterOTPVC", sender: self)
                        }
                    }
                }
            }
        }
        
        task.resume()
    }
}
