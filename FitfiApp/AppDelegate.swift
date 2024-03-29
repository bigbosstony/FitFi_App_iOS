//
//  AppDelegate.swift
//  FitfiApp
//
//  Created by Yan Yu on 2018-06-05.
//  Copyright © 2018 Fitfi. All rights reserved.
//
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var createNewAccountVC: UIViewController?
    
    let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
    //MARK: Delete Me
    let date = UserDefaults.standard.data(forKey: "date")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        let context = persistentContainer.viewContext
        print("Context: ", context)
        print("File Path of SQLite and .plist: " ,FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//        print(".plist filepath: ", NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)

        if !hasLaunchedBefore {
            goToLoginScreen()
        } else {
            if !hasLoginKey {
                goToLoginScreen()
            } else {
                print("Go To Home Screen")
            }
        }
        
//        createNewAccountVC = CreateNewAccountViewController()
//        window?.addSubview((createNewAccountVC?.view!)!)
        
//        window = UIApplication.shared.keyWindow
//        window?.addSubview((createNewAccountVC?.view)!)
//        if hasLoginKey {
//            window?.addSubview((createNewAccountVC?.view)!)
//        }
        
        // Override point for customization after application launch.
        print("Application Did Finish LaunchingWithOptions")
        return true
    }
    
    func goToLoginScreen() {
//        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let initialViewController : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "FirstVC") as UIViewController
        
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController : UINavigationController = mainStoryboardIpad.instantiateViewController(withIdentifier: "rootLoginNC") as UIViewController as! UINavigationController
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        //Open Specific Tab From AppDelegate
        let myTabBar = self.window?.rootViewController as! UITabBarController // Getting Tab Bar
        myTabBar.selectedIndex = 2
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//
//        // get the navigation controller from the window and instantiate the viewcontroller I need.
//        if let viewController = storyBoard.instantiateViewController(withIdentifier: "ExerciseTableVC") as? ExerciseTableViewController,
//            let nav = window?.rootViewController as? UINavigationController {
//            print("Yes")
//            nav.pushViewController(viewController, animated: true)//use the navigation controller to present this view.
//        }
        
//        let exerciseVC = storyBoard.instantiateViewController(withIdentifier: "ExerciseTableVC") as! ExerciseTableViewController
//        self.window?.rootViewController = exerciseVC
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("Application Will Resign Active")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("Application Did Enter Background")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("Application Will Enter Foreground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("Application Did Become Active")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        print("Application Will Terminate")
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Data")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

