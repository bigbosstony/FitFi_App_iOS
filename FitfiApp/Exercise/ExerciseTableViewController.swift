//
//  ExerciseTableViewController.swift
//  FitfiApp
//
//  Created by Yan Yu on 2018-06-14.
//  Copyright © 2018 Fitfi. All rights reserved.
//


import UIKit
import CoreData

//  For Core Data: Add Entity and Attribute to .xcdatamodeld file, import CoreData
import RealmSwift

class ExerciseTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    
    var exerciseList = [[Exercise]]()
    let searchController = UISearchController(searchResultsController: nil)

    var tn = [Exercise]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)

//        setupNavBar()

//        loadExercises()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadExercises()
        setupNavBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupNavBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return exerciseList.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎
        return exerciseList[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath) as! ExerciseTableViewCell

        //⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎
        cell.textLabel?.text = exerciseList[indexPath.section][indexPath.row].name
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎
        performSegue(withIdentifier: "goToExerciseDetailsVC", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToExerciseDetailsVC" {
            let destinationVC = segue.destination as! ExerciseDetailsViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedExercise = exerciseList[indexPath.section][indexPath.row]
            }
        }
    }
    
    //MARK: Data Manipulation Methods
    func saveExercises() {
        do {
            try context.save()
        } catch {
            print("\(error)")
        }
        tableView.reloadData()
    }
    
    func loadExercises() {
        let allExercisesRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        let favoriteExercisesRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        let favoriteExercisesPredicate = NSPredicate(format: "favorite == YES")
        favoriteExercisesRequest.predicate = favoriteExercisesPredicate

        do {
            exerciseList = [try context.fetch(favoriteExercisesRequest)]
            exerciseList.append(try context.fetch(allExercisesRequest))
        } catch {
            print("\(error)")
        }
        tableView.reloadData()
    }
    
    // ◣◥◣◥◣◥◣◥◣◥◣◥◣◥ Add Action ◣◥◣◥◣◥◣◥◣◥◣◥◣◥◣◥ \\
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Exercise", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in

            let newExercise = Exercise()
            newExercise.name = textField.text
            newExercise.favorite = false
            newExercise.image = nil

            self.saveExercises()
            self.loadExercises()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Exercise"
            textField = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}

extension ExerciseTableViewController {
    
}
