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

//It is first commit to harsh
class TabBarViewController: UITabBarController {
    var smallTrackingVC: UIViewController!
    var window: UIWindow!
    
    let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    
    //BLE model version
    let modelName = UIDevice.modelName
    
    lazy var bleVersion = {
        return self.deviceModelToBLEVersion(modelName)
    }()
    
    func deviceModelToBLEVersion(_ deviceModel: String) -> Double {
        switch deviceModel {
        case "iPhone 5", "iPhone5c", "iPhone 5s":
            return 4.0
        case "iPhone 6", "iPhone 6 Plus", "iPhone 6s", "iPhone SE", "iPhone 6s Plus", "iPhone 7", "iPhone 7 Plus", "iPad 6":
            return 4.2
        case "iPhone 8", "iPhone 8 Plus", "iPhone X":
            return 5.0
        default:
            return 0.0
        }
    }
    
    //Setup COre Bluetooth Properties
    var centralManager: CBCentralManager!
    var blePeripheral: CBPeripheral!
    
    let bleServiceCBUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")  //6E400001-B5A3-F393-E0A9-E50E24DCCA9E
    let bleCharacteristicCBUUID = CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")
    
    override func viewDidLoad() {
        let tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 49.0

        super.viewDidLoad()
        print(UIDevice.modelName)
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
        
        //MARK: Add to ParentVC
//        add(smallTrackingVC)
        
        print("BLE Version: \(bleVersion)")
        //
        centralManager = CBCentralManager(delegate: self, queue: nil)
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

extension TabBarViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        <#code#>
    }
    
    
}

//MARK: Save exercises to local database when first time launch the app
//TODO: Get internet connection save data from api

extension TabBarViewController {
    func saveExercises() {
        for e in Exercises {
            let exercise = Exercise(context: self.context)
            exercise.name = e["name"]
            exercise.instructions = e["instructions"]
            exercise.image = e["image"]
            exercise.category = e["category"]
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
