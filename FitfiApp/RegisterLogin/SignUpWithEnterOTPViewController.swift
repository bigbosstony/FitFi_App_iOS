//
//  SignUpWithEnterOTPViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-10-22.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit
import CoreData

class SignUpWithEnterOTPViewController: UIViewController {

    var phoneNumber: String!
    let fitfiOTPKey = "hpyDZSO9CVjQ66YmmMIcsXcOUONmmIsM"
    let sampleExerciseURL = "" //"http://192.168.2.25/api/sample_exercise" // URL for Sample
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
                        //Download Exercise and save it to database

                        self.downloadExercises(from: self.sampleExerciseURL)
                        
                        //If Response Is Ture, Go to Main Screen
                        DispatchQueue.main.async {
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let newViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarViewController
                            UserDefaults.standard.setValue(true, forKey: "hasLoginKey")
                            UserDefaults.standard.setValue(phoneNumber, forKey: "phoneNumber")
                            //TODO: Delete, check user
                            if phoneNumber == "6476865007" {
                                UserDefaults.standard.setValue(1, forKey: "user")
                            } else {
                                UserDefaults.standard.setValue(2, forKey: "user")
                            }
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

extension SignUpWithEnterOTPViewController {
    func downloadExercises(from url: String) {
        guard let url = URL(string: url) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let responseData = data else { return }
            
            do {
                guard let responseJSONData = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String : Any]] else { return }
                for exercise in responseJSONData {
                    print(exercise)
                    let newExercise = Exercise(context: self.context)
                    newExercise.name = exercise["name"] as? String
                    newExercise.instructions = exercise["details"] as? String
                    newExercise.image = exercise["image"] as? String
                    newExercise.category = exercise["category"] as? String
                    newExercise.favorite = false
                    self.save()
                }
            } catch {
                print("error parsing json data")
            }
        }
        task.resume()
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print("\(error)")
        }
    }
}
