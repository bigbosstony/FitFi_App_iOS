//
//  NewRoutineExerciseSelectionTVC.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-08-03.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit
import CoreData

struct Section {
    var category: String
    var exerciseArray: [Exercise]
    var collapsed: Bool
    
    init(category: String, exerciseArray: [Exercise], collapsed: Bool = false) {
        self.category = category
        self.exerciseArray = exerciseArray
        self.collapsed = collapsed
    }
}

class NewRoutineExerciseSelectionTVC: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var addButton = "Add"
    var numberOfExercises = 0
    let searchController = UISearchController(searchResultsController: nil)
    
    var sections = [Section]()
    var categoryArray = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: addButton, style: .plain, target: self, action: #selector(addTapped))
        self.title = "Exercise"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        request.resultType = NSFetchRequestResultType.dictionaryResultType
        request.propertiesToFetch = ["category"]
        request.returnsDistinctResults = true
        
        do { categoryArray = try context.fetch(request) as! [[String: String]] } catch { print("\(error)") }
        for category in categoryArray {
            
            let category = category["category"]!
//            print(category)
            let exerciseRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
            exerciseRequest.predicate = NSPredicate(format: "category MATCHES %@", category)
            do {
                let exercises = try context.fetch(exerciseRequest)
//                print(exercises)
                let newSection: Section = Section(category: category, exerciseArray: exercises)
                sections.append(newSection)
            } catch {}
        }
        for i in sections {
            print(i.category)
            for i in i.exerciseArray {
                print(i.name)
            }
        }
    }

    @objc func addTapped() {
        print("Add")
    }
    
    //MARK: Search Bar in Nav bar
    func setupNavBar() {
        navigationItem.searchController = searchController
        //TODO: Uncomment next line in the future
        navigationItem.hidesSearchBarWhenScrolling = false
        extendedLayoutIncludesOpaqueBars = true         //important
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newRoutineExerciseCell", for: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }


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

}
