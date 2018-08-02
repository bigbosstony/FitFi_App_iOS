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
//import RealmSwift

class ExerciseTableViewController: UITableViewController {
    //
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    var exerciseList = [[Exercise]]()
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
        
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
        //TODO: Uncomment next line in the future
//        navigationItem.hidesSearchBarWhenScrolling = false
        extendedLayoutIncludesOpaqueBars = true         //important
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return exerciseList.count
    }
    
    //Customize Header of Section
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }

    //Number of Exercise in different section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return exerciseList[section].count
    }

    //Create Cell for Section
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath) as! ExerciseTableViewCell

        cell.textLabel?.text = exerciseList[indexPath.section][indexPath.row].name
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return cell
    }
    
    //MARK: Prepare Segue and Send to Exercise Details VC
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    // MARK: Swipe to Delete selected cell
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {

            context.delete(exerciseList[indexPath.section][indexPath.row])
//            tableView.deleteRows(at: [indexPath], with: .fade)
            saveExercises()
            loadExercises()
        }
    }
    
    // MARK: - Data Manipulation Methods
    // MARK: Save New Exercise to Database
    func saveExercises() {
        do {
            try context.save()
        } catch {
            print("\(error)")
        }
    }
    
    // MARK: Load Exercise
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
    
    //MARK:  Add Exercise UIAlert Action
//    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
//        var textField = UITextField()
//
//        let alert = UIAlertController(title: "New Exercise", message: "Add a New Exercise to your library", preferredStyle: .alert)
//
//        alert.addTextField { (alertTextField) in
//            textField = alertTextField
////            print("Name: ",textField.text!)
//        }
//
//        alert.addAction(UIAlertAction(title: NSLocalizedString("Add", comment: "Default action"), style: .default, handler: { _ in
//            NSLog("The \"OK\" alert occured.")
////            print("Name from action: ", textField.text!)
//            let newExercise = Exercise(context: self.context)
//            newExercise.name = textField.text!
//            newExercise.favorite = false
//
//            self.saveExercises()
//            self.loadExercises()
//        }))
//
//        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .cancel, handler: { (_) in
//            print("Cancel button tapped")
//        }))
//
//        self.present(alert, animated: true, completion: nil)
        
//        Ignore the following
//            let entity = NSEntityDescription.entity(forEntityName: "Exercise", in: self.context)
//            let newExercise = NSManagedObject(entity: entity!, insertInto: self.context)
//            newExercise.setValue(textField.text, forKey: "name")
//            newExercise.setValue(nil, forKey: "favorite")
//            newExercise.setValue(nil, forKey: "image")
//    }
}

//MARK: Connection Between CoreData and TableView
extension ExerciseTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
}

