//
//  NewRoutineExerciseSelectionTVC.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-08-03.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit
import CoreData

//protocol ReceiveRoutineExercises {
//    func routineExerciseReceived(exercise name: String)
//}

//struct Section {
//    var category: String
//    var exerciseArray: [Exercise]
//    var collapsed: Bool
//    var checkedArray: [Bool]
//
//    init(category: String, exerciseArray: [Exercise], checkedArray: [Bool], collapsed: Bool = false) {
//        self.category = category
//        self.exerciseArray = exerciseArray
//        self.collapsed = collapsed
//        self.checkedArray = checkedArray
//    }
//}

class NewRoutineExerciseSelectionTVC: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var counter = 0
//    var addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
    let searchController = UISearchController(searchResultsController: nil)
    
    var sections = [Section]()
    var categoryArray = [[String: String]]()
    var selectedExercise = [Exercise]()
    var delegate: ReceiveRoutineExercises?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.addSubview(navBar)
//        let navItem = UINavigationItem(title: "Exercise")
//
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        self.title = "Exercise"
//
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        request.resultType = NSFetchRequestResultType.dictionaryResultType
        request.propertiesToFetch = ["category"]
        request.returnsDistinctResults = true
        
        //MARK: Load Category
        do { categoryArray = try context.fetch(request) as! [[String: String]] } catch { print("\(error)") }
        //MARK: Load Exercise with Category
        for category in categoryArray {
            
            let category = category["category"]!
            //            print(category)
            let exerciseRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
            exerciseRequest.predicate = NSPredicate(format: "category MATCHES %@", category)
            do {
                let exercises = try context.fetch(exerciseRequest)
                let checkedArray = Array(repeating: false, count: exercises.count)
                let newSection: Section = Section(category: category, exerciseArray: exercises, checkedArray: checkedArray)
                sections.append(newSection)
            } catch {}
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupNavBar()
        
//        //MARK: Auto Resize Cell Height, Delete This After Testing
//        tableView.estimatedRowHeight = 44.0
//        tableView.rowHeight = UITableViewAutomaticDimension
    }

    //MARK: Save selected exercise to temp routine
    @objc func addTapped() {
        do {
            let parentRoutine = try context.fetch(Routine.fetchRequest()).last
            for exercise in selectedExercise {
                let newRoutineExercise = Routine_Exercise(context: context)
                newRoutineExercise.name = exercise.name
                newRoutineExercise.reps = 0
                newRoutineExercise.sets = 0
                newRoutineExercise.category = exercise.category
                newRoutineExercise.parentRoutine = parentRoutine as? Routine
                do { try context.save()} catch { print("\(error)")}
            }
        } catch {
            print("\(error)")
        }
        
//        delegate?.routineExerciseReceived(exercise: "New Exercise")
        dismiss(animated: true, completion: nil)
        print(selectedExercise)
    }
    
    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: UIButton) {
//        delegate?.routineExerciseReceived(exercise: "New Exercise")
        dismiss(animated: true, completion: nil)

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
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sections[section].collapsed ? 0 : sections[section].exerciseArray.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        header.titleLabel.text = sections[section].category
        header.arrowLabel.text = "⌃"
        header.setCollapsed(sections[section].collapsed)
        header.section = section
        header.delegate = self
        
        return header
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newRoutineExerciseCell", for: indexPath)
        cell.textLabel?.text = sections[indexPath.section].exerciseArray[indexPath.row].name
        cell.accessoryType = sections[indexPath.section].checkedArray[indexPath.row] ? .checkmark : .none
        
        return cell
    }
    
    //MARK: Delete Me
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        sections[indexPath.section].checkedArray[indexPath.row] = !sections[indexPath.section].checkedArray[indexPath.row]
        if sections[indexPath.section].checkedArray[indexPath.row] == true {
            selectedExercise.append(sections[indexPath.section].exerciseArray[indexPath.row])
        } else {
            let currentNoneExercise = sections[indexPath.section].exerciseArray[indexPath.row]
            selectedExercise.remove(at: selectedExercise.index(of: currentNoneExercise)!)
        }
        
//        if counter > 0 {
//            addButton.title = "Add \((counter))"
//        }
        print(selectedExercise)
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48.0
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

//extension NewRoutineExerciseSelectionTVC: CollapsibleTableViewHeaderDelegate {
//    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
//        let collapsed = !sections[section].collapsed
//
//        sections[section].collapsed = collapsed
//        header.setCollapsed(collapsed)
//        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
//    }
//
//
//}
