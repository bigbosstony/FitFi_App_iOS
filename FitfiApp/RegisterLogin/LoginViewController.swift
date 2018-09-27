//
//  CreateNewAccountViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-07-04.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit

let baseURL : String = "http://192.168.2.25/api/"
let loginURL : String = "BebKW9Eu2rWGeDjoepKk26IQDjFtGRTYdeh2knhMWdJitEZBUeJIt291WavlWhTKUnWeZ8SISl0oGubwuSKVJvE5sXfuJ22n1UVSQgWmasocXlOo6Os7/fitfi_credentails$$$$$$$$$$$$$$$$$$$/E5sXfuJ22n1UVSQgWmasocXlOo6Os7V6seRX83pL4hdJBZEV5NPmvPU5np1NBpcNjtPwgfxlCJFjs/login"

struct LoginInfo: Codable {
    var email: String
    var password: String
}

class LoginViewController: UIViewController {

    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    var hasToken: Bool = false
    
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
        
        email.autocorrectionType = .no
        password.autocorrectionType = .no
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print("login view will dissapear")
//        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        print("Login Pressed")
        
        guard let email = self.email.text else { return }
        guard let password = self.password.text else { return }
        
        print(email, password)
        
        let url: String = baseURL + loginURL
        guard let fullURL = URL(string: url) else { print("Error: cannot create URL"); return }

        var loginURLRequest = URLRequest(url: fullURL)
        loginURLRequest.httpMethod = "POST"

        let userInfoData: [String: Any] = ["email": email, "password": password]
        let userJSONData: Data

        do {
            userJSONData = try JSONSerialization.data(withJSONObject: userInfoData, options: [])
            loginURLRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            loginURLRequest.httpBody = userJSONData
        } catch {
            print("Error: cannot create JSON from")
            return
        }

        let session = URLSession.shared

        let task = session.dataTask(with: loginURLRequest) { (data, response, error) in
            // parse the result as JSON, since that's what the API provides
            guard error == nil else {
                print("error calling POST")
                print(error!)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            do {
                guard let receivedToken = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: String] else { print("Could not get JSON from responseData as dictionary")
                    return
                }
                
                print(receivedToken)
                guard let token = receivedToken["token"] else { print("Could not get token as String from JSON")
                    return
                }
                
                if token != nil {
                    self.hasToken = true
                }
                    
            } catch  {
                print("error parsing response from POST")
                return
            }
        }
        task.resume()
        
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
        let movementDistance:CGFloat = -70
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

extension LoginViewController {
//
//    func makePostCall() {
////        let url: String = baseURL + loginURL
//         let url: String = baseURL + loginURL
//
//
//      //  let userInfoData: [String: Any] = ["email": email, "password": password]
////        let
////        let url = "https://jsonplaceholder.typicode.com/posts"
//        guard let fullURL = URL(string: url) else {
//            print("Error: cannot create URL")
//            return
//        }
//
//        var loginURLRequest = URLRequest(url: fullURL)
//        loginURLRequest.httpMethod = "POST"
//
//       let userInfoData: [String: Any] = ["email": "navjotbabrah27@gmail.com", "password": ""]
//        let userJSONData: Data
//
//        do {
//            userJSONData = try JSONSerialization.data(withJSONObject: userInfoData, options: [])
//            loginURLRequest.httpBody = userJSONData
//            loginURLRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            print(userJSONData.description)
//        } catch {
//            print("Error: cannot create JSON from todo")
//            return
//        }
//
//        let session = URLSession.shared
//
//        let task = session.dataTask(with: loginURLRequest) {
//            (data, response, error) in
//            guard error == nil else {
//                print("error calling POST on /todos/1")
//                print(error!)
//                return
//            }
//
//            guard let responseData = data else {
//                print("Error: did not receive data")
//                return
//            }
//
//            // parse the result as JSON, since that's what the API provides
//            do {
//                guard let receivedToken = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String : Any] else { print("Could not get JSON from responseData as dictionary")
//                    return
//                }
//
//                print("The todo is: " + receivedToken.description)
//
//                guard let token = receivedToken["token"] as? String else {
//                    print("Could not get todoID as int from JSON")
//                    return
//                }
//
//                print(token)
//
////                print("The ID is: \(todoID)")
//            } catch  {
//                print("error parsing response from POST on /todos")
//                return
//            }
//        }
//        task.resume()
//    }
}
