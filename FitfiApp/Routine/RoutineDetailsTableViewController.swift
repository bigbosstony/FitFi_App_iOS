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
    
//    var deletedRoutine = false
    
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
        
        let manualAction = UIAlertAction(title: "Manual", style: .default) { (action) in
            // Respond to user selection of the action
            self.performSegue(withIdentifier: "goToManualTrackingVC", sender: self)
        }
        
        let autoAction = UIAlertAction(title: "Auto", style: .default) { (action) in
            // Respond to user selection of the action
            smallTrackingVC.autoTracking = true
//            NotificationCenter.default.post(name: .user1, object: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        
        let alert = UIAlertController(title: "Choose Your Workout Style",
                                      message: "^≠^",
                                      preferredStyle: .actionSheet)
        alert.addAction(manualAction)
        alert.addAction(autoAction)
        alert.addAction(cancelAction)
        
        // On iPad, action sheets must be presented from a popover.
//        alert.popoverPresentationController?.barButtonItem = self.trashButton
        
        self.present(alert, animated: true) {
            // The alert was presented
        }
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
        cell.setRepLabel.attributedText = setRepString(routineExerciseArray[indexPath.row].sets, routineExerciseArray[indexPath.row].reps)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
}

//Load and Save
extension RoutineDetailsTableViewController {
    
    func loadExercises(with request: NSFetchRequest<Routine_Exercise> = Routine_Exercise.fetchRequest(), predicate: NSPredicate? = nil) {
        
        if let routineName = selectedRoutine?.name {
            print(routineName)
            request.predicate = NSPredicate(format: "parentRoutine.name MATCHES %@", routineName)
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
        } else {
            print("Routine Deleted")
        }
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print("\(error)")
        }
    }
    
    func setRepString(_ set: Int16, _ rep: Int16) -> NSMutableAttributedString {
        let setLabel = String(set)
        let repLabel = String(rep)
        
        //MARK: Build multiple lines with different color and text size for nav bar title
        let attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12, weight: .regular), NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1)] as [NSAttributedString.Key : Any]
        let attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12, weight: .regular), NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.8352941176, green: 0.3725490196, blue: 0.1215686275, alpha: 1)] as [NSAttributedString.Key : Any]
        
        let attributedString1 = NSMutableAttributedString(string: setLabel + " SET", attributes:attrs2)
        let attributedString2 = NSMutableAttributedString(string: " X ", attributes:attrs1)
        let attributedString3 = NSMutableAttributedString(string: repLabel + " REP", attributes:attrs2)
        attributedString1.append(attributedString2)
        attributedString1.append(attributedString3)
        
        return attributedString1
    }
}

