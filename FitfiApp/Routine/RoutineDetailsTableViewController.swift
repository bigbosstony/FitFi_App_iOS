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
    let FitFiColor = UIColor(red: 213, green: 95, blue: 31)
    //MARK: Properties
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

        self.navigationController?.navigationBar.tintColor = FitFiColor
//        self.view.tintColor = FitFiColor
        loadExercises()

        print("Routine Details View Loaded")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("Routine Details View Will Appear")
        
        self.title = selectedRoutine?.name?.capitalized
        favButton.image = (selectedRoutine?.favorite)! ? UIImage(named: "Glyphs/Favorited") : UIImage(named: "Glyphs/Favorite")
        loadExercises()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func faveButtonPressed(_ sender: UIBarButtonItem) {
        selectedRoutine?.favorite = !(selectedRoutine?.favorite)!
        favButton.image = (selectedRoutine?.favorite)! ? UIImage(named: "Glyphs/Favorited") : UIImage(named: "Glyphs/Favorite")
        save()
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "goToRoutineEdit", sender: self)
    }
    
    //MARK: Pass Data Through Navigation Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRoutineEdit" {
            let navVC = segue.destination as? UINavigationController
            let secondVC = navVC?.viewControllers.first as! NewRoutineTableViewController
//            let secondVC = segue.destination as! RoutineEditViewController
            secondVC.signal = "edit"
            secondVC.selectedRoutine = selectedRoutine
            secondVC.delegate = self
        } else if segue.identifier == "goToManualTrackingVC" {
            let thirdVC = segue.destination as! ManualTrackingVC
            thirdVC.selectedRoutine = selectedRoutine
        }
    }
    
    //MARK: Start Workout Button for Testing Only
    //Delete Me
    @IBAction func startWorkoutButtonPressed(_ sender: UIButton) {
        //Go To Manual TrackingVC
        performSegue(withIdentifier: "goToManualTrackingVC", sender: self)
    }
    
    
    
    //MARK: Temporary function, Delete me later
    func dateGenerator(_ date: Date) -> Date {
        let now = date
        var dateComponents = DateComponents()
        dateComponents.setValue(10, for: .minute)
        let next = Calendar.current.date(byAdding: dateComponents, to: now)
        return next!
    }
    
    func yesterday(_ date: Date) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.setValue(-1, for: .day) // -1 day
        
        let now = date
        let yesterday = Calendar.current.date(byAdding: dateComponents, to: now) // Add the DateComponents
        
        return yesterday!
    }
    
    
}

extension RoutineDetailsTableViewController: DataToReceive {
    func dataReceive(data: Int) {
        print("\(data)")
        if data == 0 {
            self.navigationController?.popViewController(animated: true)
//            self.dismiss(animated: true, completion: nil)
        }
    }
}

//TableView DataSource
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
        cell.selectionStyle = UITableViewCellSelectionStyle.none
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
            //sorting array of object by property value
            routineExerciseArray = routineExerciseArray.sorted(by: { $0.ranking < $1.ranking })
            print(routineExerciseArray)
        } catch {
            print("\(error)")
        }
        tableView.reloadData()
    }
    
    func save() {
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

