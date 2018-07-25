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
    var smallTrackingVC: UIViewController!
    var window: UIWindow!
    
    let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    override func viewDidLoad() {
        let tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 49.0

        super.viewDidLoad()
        print("Tab Bar Controller Loaded")
        
        if !hasLaunchedBefore {
            print("First Time Launch The Application")
            saveExercises()
            UserDefaults.standard.setValue(true, forKey: "hasLaunchedBefore")
        } else {
            print("Non-First Time Launch")
        }
        
        smallTrackingVC = SmallTrackingViewController.init(nibName: "SmallTrackingViewController", bundle: nil)
        smallTrackingVC.view.frame = CGRect(x: 0, y: (height - tabBarHeight - 64 - 0.5), width: width, height: 64)
        
        //Add to ParentVC
        add(smallTrackingVC)
        
//        let trackingVC = SmallTrackingViewController()
//  MARK: After Adding frame it become activate
//        smallTrackingVC.view.frame = CGRect(x: 0, y: 497.5, width: 375, height: 119)
//        subView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    }

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
        addChildViewController(child)
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }
}
