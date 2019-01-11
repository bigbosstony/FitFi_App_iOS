//
//  TabBarViewController.swift
//  FitfiApp
//
//  Created by Yan Yu on 2018-06-18.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit
import CoreData
import CoreBluetooth
import AudioToolbox
import Intents

var smallTrackingVC = SmallTrackingViewController()
let mainScreenWidth = UIScreen.main.bounds.width
let mainScreenHeight = UIScreen.main.bounds.height

//It is first commit to harsh
class TabBarViewController: UITabBarController {
//    var smallTrackingVC: UIViewController!
    var window: UIWindow!
    
    let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    let cornerRadius: CGFloat = 6

    override func viewDidLoad() {
        let tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 49.0

        super.viewDidLoad()
//        print(UIDevice.modelName)
        print("Tab Bar Controller Loaded")
        
//        NotificationCenter.default.addObserver(self, selector: #selector(methodOfReceivedNotification(notification:)), name: .user1, object: nil)
        
        if !hasLaunchedBefore {
            print("First Time Launch The Application")
            //MARK: Save default Exercise and Schedule Template
            saveExercises()

            //MARK: Save Demo Routine
            saveDemoRoutine()
            
            UserDefaults.standard.setValue(true, forKey: "hasLaunchedBefore")
        } else {
            print("Non-First Time Launch")
        }
        
        //For initialization VC from xib file
        smallTrackingVC = SmallTrackingViewController.init(nibName: "SmallTrackingViewController", bundle: nil)
        smallTrackingVC.view.frame = CGRect(x: 0, y: (height - tabBarHeight - 121 - 0.5), width: width, height: 121)
        
        //TODO: Fix Corner Radius 
        smallTrackingVC.view.layer.cornerRadius = cornerRadius
        smallTrackingVC.view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
//        print("BLE Version: \(bleVersion)")
        //
//        centralManager = CBCentralManager(delegate: self, queue: nil)
        //        MARK: Add to ParentVC
        add(smallTrackingVC)
        smallTrackingVC.view.isHidden = false
//        let trackingVC = SmallTrackingViewController()
//  MARK: After Adding frame it become activate
//        smallTrackingVC.view.frame = CGRect(x: 0, y: 497.5, width: 375, height: 119)
//        subView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        
        setupIntents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


//MARK: Save exercises to local database when first time launch the app
//TODO: Get internet connection save data from api
extension TabBarViewController {
    func saveExercises() {
        for exercise in Exercises {
            let newExercise = Exercise(context: self.context)
            newExercise.name = exercise["name"]
            newExercise.instructions = exercise["instructions"]
            newExercise.image = exercise["image"]
            newExercise.category = exercise["category"]
            newExercise.favorite = false
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

//MARK: Find Current Top VC
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

//MARK: Add to or Remove From Parrent VC Function
extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}

extension TabBarViewController {
    func setupIntents() {
        let activity = NSUserActivity(activityType: "io.github.bigbosstony.FitFi.App.sayHi") // 1
        activity.title = "Workout Schedule" // 2
        activity.userInfo = ["speech" : "hi"] // 3
        activity.isEligibleForSearch = true // 4
        activity.isEligibleForPrediction = true // 5
        activity.persistentIdentifier = NSUserActivityPersistentIdentifier("io.github.bigbosstony.FitFi.App.sayHi") // 6
        view.userActivity = activity // 7
        activity.becomeCurrent() // 8
    }
}



extension TabBarViewController {
    func saveDemoRoutine() {
        
        let newRoutine = Routine(context: context)
        newRoutine.name = "alpha"
        newRoutine.favorite = false
        
        for exercise in 0...1 {
            let newRoutineExercise = Routine_Exercise(context: context)
            newRoutineExercise.name = Exercises[exercise]["name"]
            newRoutineExercise.category = Exercises[exercise]["category"]
            newRoutineExercise.parentRoutine = newRoutine
            newRoutineExercise.sets = 2
            newRoutineExercise.reps = 3
        }
        save()
    }
}

extension TabBarViewController {
    @objc func methodOfReceivedNotification(notification: Notification) {
        print("Notification")
    }

}
