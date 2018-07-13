//
//  TabBarViewController.swift
//  FitfiApp
//
//  Created by Yan Yu on 2018-06-18.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit
import CoreData

class TabBarViewController: UITabBarController {
    var trackingVC: UIViewController!
    var window: UIWindow!
    
    let subView = UIView()
    
    let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Tab Bar Controller Loaded")
        
        if !hasLaunchedBefore {
            print("First Time")
            saveExercises()
            UserDefaults.standard.setValue(true, forKey: "hasLaunchedBefore")
        } else {
            print("Non-First Time")
        }
        
//        subView.frame = CGRect(x: 0, y: 497.5, width: 375, height: 120)
//        subView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        trackingVC = TrackingSViewController()
//            .init(nibName: "TrackingSViewController", bundle: nil)
        trackingVC.view.frame = CGRect(x: 0, y: 497.5, width: 375, height: 119)
        
        view.addSubview(trackingVC.view!)
        trackingVC.view.isHidden = false
        
        // Do any additional setup after loading the view.
//        window = UIApplication.shared.keyWindow!
//        window.addSubview(trackingVC.view!)
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

}

extension TabBarViewController {
    func saveExercises() {
        for e in Exercises {
            let exercise = Exercise(context: self.context)
            exercise.name = e["name"]
            exercise.instructions = e["instructions"]
            exercise.image = e["image"]
            exercise.favorite = false
            save()
        }
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print("\(error)")
        }
    }

    
}
