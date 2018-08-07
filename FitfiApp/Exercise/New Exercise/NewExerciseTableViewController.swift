//
//  NewExerciseTableViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-08-01.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit
import CoreData

class NewExerciseTableViewController: UITableViewController {

    var categoryName: String = "Select"
    var newExerciseName: String?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "name", for: indexPath) as! NewExerciseNameTableViewCell
            cell.newExerciseName.delegate = self
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath) as! NewExerciseCategoryTableViewCell
            cell.categoryLabel.text = categoryName
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            performSegue(withIdentifier: "goToCategoryTableVC", sender: self)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        if newExerciseName != nil && categoryName != "Select" {
            let newExercise = Exercise(context: context)
            newExercise.name = newExerciseName
            newExercise.category = categoryName
            newExercise.favorite = false
            do { try context.save()} catch { print("\(error)")}
        }
        dismiss(animated: true, completion: nil)
    }
    
}

extension NewExerciseTableViewController: ReceiveCategory {
    func categoryReceived(category name: String) {
        categoryName = name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCategoryTableVC" {
            let categoryTableVC = segue.destination as! ExerciseCategoryTableViewController
            if categoryName != "Select" {
                categoryTableVC.categoryName = categoryName
            }
            categoryTableVC.delegate = self
        }
        
    }
}

//MARK: TextField Delegate
extension NewExerciseTableViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        newExerciseName = textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



