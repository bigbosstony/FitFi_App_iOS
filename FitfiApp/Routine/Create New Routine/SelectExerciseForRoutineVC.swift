//
//  SelectExerciseForRoutineVC.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-08-07.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit
import CoreData

protocol ReceiveRoutineExercises {
    func routineExerciseReceived(from exerciseArray: [Exercise])
}

struct Section {
    var category: String
    var exerciseArray: [Exercise]
    var collapsed: Bool
    var checkedArray: [Bool]
    
    init(category: String, exerciseArray: [Exercise], checkedArray: [Bool], collapsed: Bool = false) {
        self.category = category
        self.exerciseArray = exerciseArray
        self.collapsed = collapsed
        self.checkedArray = checkedArray
    }
}

class SelectExerciseForRoutineVC: UIViewController {
    
    @IBOutlet weak var exerciseTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var delegate: ReceiveRoutineExercises?
    
    var sections = [Section]()
    var categoryArray = [[String: String]]()
    var selectedExercise = [Exercise]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseTableView.delegate = self
        exerciseTableView.dataSource = self
        
        //PREPARE DATA FOR TABLEVIEW
        //MARK: Load Category
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        request.resultType = NSFetchRequestResultType.dictionaryResultType
        request.propertiesToFetch = ["category"]
        request.returnsDistinctResults = true
        
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

    @IBAction func addButtonPressed(_ sender: UIButton) {
        delegate?.routineExerciseReceived(from: selectedExercise)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SelectExerciseForRoutineVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        sections[indexPath.section].checkedArray[indexPath.row] = !sections[indexPath.section].checkedArray[indexPath.row]
        if sections[indexPath.section].checkedArray[indexPath.row] == true {
            selectedExercise.append(sections[indexPath.section].exerciseArray[indexPath.row])
        } else {
            let currentNoneExercise = sections[indexPath.section].exerciseArray[indexPath.row]
            selectedExercise.remove(at: selectedExercise.index(of: currentNoneExercise)!)
        }
        
        print(selectedExercise)
        
        //Changing the Button Color and Text
        if selectedExercise.count > 0 {
            addButton.setTitle("Add (\(String(selectedExercise.count)))", for: .normal)
            addButton.setTitleColor(#colorLiteral(red: 0.8740790486, green: 0.4554287791, blue: 0.1562839746, alpha: 1), for: .normal)
        } else {
            addButton.setTitle("Add", for: .normal)
            addButton.setTitleColor(#colorLiteral(red: 0.6712639928, green: 0.6712799668, blue: 0.6712713838, alpha: 1), for: .normal)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
}

extension SelectExerciseForRoutineVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].collapsed ? 0 : sections[section].exerciseArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        header.titleLabel.text = sections[section].category
        //TODO: Add Section Arrow
        header.arrowLabel.text = ""
        header.setCollapsed(sections[section].collapsed)
        header.section = section
        header.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath)
        cell.textLabel?.text = sections[indexPath.section].exerciseArray[indexPath.row].name
        cell.accessoryType = sections[indexPath.section].checkedArray[indexPath.row] ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48.0
    }
}

extension SelectExerciseForRoutineVC: CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !sections[section].collapsed
        
        sections[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        exerciseTableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
    
}
