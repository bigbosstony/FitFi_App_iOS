//
//  ProfileSettingsTableViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-07-13.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit
import CoreData

class ProfileSettingsTableViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
//    let persistentStoreCoordinator = NSPersistentStoreCoordinator()
//    let fileManager = FileManager.default
    
    
//    let url: URL = URL(string: "Users/tony/Library/Developer/CoreSimulator/Devices/6CC01E08-1965-4C0F-8047-05B15A365240/data/Containers/Data/Application/773F6CA6-3894-430F-A03B-85B052E77E77/Library/Application Support/Data.sqlite")!


//    let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as [URL]

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 3
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
//        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let initialViewController : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "FirstVC") as UIViewController
        
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController : UINavigationController = mainStoryboardIpad.instantiateViewController(withIdentifier: "rootLoginNC") as UIViewController as! UINavigationController
        self.present(initialViewController, animated:true, completion:nil)
        UserDefaults.standard.set(false, forKey: "hasLoginKey")
        UserDefaults.standard.set("", forKey: "phoneNumber")
        
//        let smallTrackingVC = SmallTrackingViewController()
//        smallTrackingVC.willMove(toParent: nil)
//        smallTrackingVC.view.removeFromSuperview()
//        smallTrackingVC.removeFromParent()
        
        
//        let persistenContainer = NSPersistentContainer(name: "Data")
        
        //Delete Data From Database
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try context.execute(request)
            print("Cleaned")
        } catch {
            print(error)
        }
    }
}
