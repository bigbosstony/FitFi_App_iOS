//
//  RoutineDetailsTableViewController.swift
//  FitfiApp
//
//  Created by Yan Yu on 2018-06-08.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit
import CoreData

class RoutineDetailsTableViewController: UITableViewController {

    @IBOutlet weak var favButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var routineExerciseArray = [Routine_Exercise]()
    
    var selectedRoutine: Routine? {
        didSet {
            loadExercises()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadExercises()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = selectedRoutine?.name?.capitalized
        favButton.image = (selectedRoutine?.favorite)! ? UIImage(named: "Glyphs/Favorited") : UIImage(named: "Glyphs/Favorite")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func faveButtonPressed(_ sender: UIBarButtonItem) {
        selectedRoutine?.favorite = !(selectedRoutine?.favorite)!
        favButton.image = (selectedRoutine?.favorite)! ? UIImage(named: "Glyphs/Favorited") : UIImage(named: "Glyphs/Favorite")
        saveRoutine()
    }

}

extension RoutineDetailsTableViewController {
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return routineExerciseArray.count
    }
    
    //MARK: Table view delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "routinedetailsCell", for: indexPath) as! RoutineDetailsTableViewCell
        cell.textLabel?.text = routineExerciseArray[indexPath.row].name
        cell.setRepLabel.text = setRepString(routineExerciseArray[indexPath.row].sets, routineExerciseArray[indexPath.row].reps)
        return cell
    }
}

//Load and Save
extension RoutineDetailsTableViewController {
    
    func loadExercises(with request: NSFetchRequest<Routine_Exercise> = Routine_Exercise.fetchRequest(), predicate: NSPredicate? = nil) {
        request.predicate = NSPredicate(format: "parentRoutine.name MATCHES %@", selectedRoutine!.name!)
        
        do {
            //save the result into itemArray
            routineExerciseArray = try context.fetch(request)
        } catch {
            print("\(error)")
        }
        tableView.reloadData()
    }
    
    func saveRoutine() {
        do {
            try context.save()
        } catch {
            print("\(error)")
        }
    }
    
    func setRepString(_ set: Int16, _ rep: Int16) -> String {
        return String(set) + " SET X " + String(rep) + " REP"
    }
}

