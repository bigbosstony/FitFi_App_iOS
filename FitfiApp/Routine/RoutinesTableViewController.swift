//
//  RoutinesTableViewController.swift
//  FitfiApp
//
//  Created by Yan Yu on 2018-06-14.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit
import CoreData

class RoutinesTableViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var routineList = [[Routine]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadRoutines()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Create New Temp Routine and go to new routine page
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToNewRoutinePage", sender: self)
        print("Going to Add New Routine VC")
    }
    
    // MARK: - Table view data source
    //TODO: Section of Routine
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return routineList.count
    }

    //TODO: Number of Row in Each Section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return routineList[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "routinesTableviewCell", for: indexPath)// as! RoutinesTableViewCell
        
        cell.textLabel?.text = routineList[indexPath.section][indexPath.row].name?.capitalized
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        // Configure the cell...

        return cell
    }

    //Section Title
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    //Header view
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
    }
    
    //Height for Header
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    func loadRoutines() {
        let allRoutinesRequest: NSFetchRequest<Routine> = Routine.fetchRequest()
        let favoriteRoutinesRequest: NSFetchRequest<Routine> = Routine.fetchRequest()
        favoriteRoutinesRequest.predicate = NSPredicate(format: "favorite == YES")
        
        do {
            routineList = [try context.fetch(favoriteRoutinesRequest)]
            routineList.append(try context.fetch(allRoutinesRequest))
        } catch {
            print("Loading Routines Error: \(error)")
        }
        tableView.reloadData()
    }
}

// MARK: Delete Routine
extension RoutinesTableViewController {
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
    
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
//     tableView.deleteRows(at: [indexPath],` with: .fade)
        context.delete(routineList[indexPath.section][indexPath.row])
        do { try context.save()} catch { print("\(error)")}
        loadRoutines()
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
     }

}

// TableView Delegate
extension RoutinesTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToRoutineDetailsTableview", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRoutineDetailsTableview" {
            let destinationVC = segue.destination as! RoutineDetailsTableViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedRoutine = routineList[indexPath.section][indexPath.row]
            }
        }
    }
}
