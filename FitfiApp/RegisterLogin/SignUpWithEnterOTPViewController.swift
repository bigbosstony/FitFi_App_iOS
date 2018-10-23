//
//  SignUpWithEnterOTPViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-10-22.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit

class SignUpWithEnterOTPViewController: UIViewController {

    var phoneNumber: String!
    let fitfiOTPKey = "hpyDZSO9CVjQ66YmmMIcsXcOUONmmIsM"

    @IBOutlet weak var OTPCodeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(phoneNumber)
        OTPCodeTextField.keyboardType = .numberPad
        OTPCodeTextField.autocorrectionType = .no
        OTPCodeTextField.delegate = self
    }
    
    @IBAction func verifyOTPButtonPressed(_ sender: UIButton) {
        //Sent Request
        if let code = OTPCodeTextField.text {
            confirmPhoneNumber(phoneNumber: phoneNumber, code: code)
        }
    }
    
}

extension SignUpWithEnterOTPViewController: UITextFieldDelegate {
    func confirmPhoneNumber(phoneNumber: String, code: String) {
        let strURL = "https://api.authy.com/protected/json/phones/verification/check?api_key="+fitfiOTPKey+"&verification_code="+code+"&phone_number="+phoneNumber+"&country_code=1"
        let url = URL(string: strURL)
        let task = URLSession.shared.dataTask(with: url! as URL)  { data, response, error in
            
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            print(json)
            if let dictionary = json as? [String: Any] {
                print(dictionary)
                if let number = dictionary["success"] as? Int {
                    print(number)
                    if(number == 0)
                    {
                        //
                    }
                    else if(number == 1)
                    {
                        //If Response Is Ture, Go to Main Screen
                        DispatchQueue.main.async {
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let newViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarViewController
                            UserDefaults.standard.setValue(true, forKey: "hasLoginKey")
                            UserDefaults.standard.setValue(phoneNumber, forKey: "phoneNumber")
                            //MARK: Delete
                            UserDefaults.standard.setValue(Date(), forKey: "date")
                            self.present(newViewController, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        task.resume()
    }
}
