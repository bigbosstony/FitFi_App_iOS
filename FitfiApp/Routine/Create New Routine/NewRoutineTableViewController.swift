//
//  NewRoutineTableViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-07-03.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit
import CoreData

class NewRoutineTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var exerciseList = [Exercise]()
    var currentPickedExercise: [String]?
    var currentPickedExerciseList = [[String]]()
    
    @IBOutlet weak var routineName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Load Exercise to List
        do {
            exerciseList = try context.fetch(Exercise.fetchRequest())
        } catch {
            print("Loading Exercises Error: \(error)")
        }
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
//        guard let list = currentPickedExerciseList else {
//            return 0
//        }
        return currentPickedExerciseList.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Current Row: \(indexPath.row)")
    }
    
//
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! NewRoutineTableViewCell
        cell.textLabel?.text = currentPickedExerciseList[indexPath.row][0]
        cell.setTextField.delegate = self
        cell.repTextField.delegate = self
        cell.setTextField.text = currentPickedExerciseList[indexPath.row][1]
        cell.repTextField.text = currentPickedExerciseList[indexPath.row][2]
        cell.setTextField?.tag = indexPath.row * 10 //currentPickedExerciseList[indexPath.row]
        cell.repTextField?.tag = indexPath.row * 10 + 1 //currentPickedExerciseList[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        // Configure the cell...
        return cell
    }
    

    // MARK: Save to database When finished
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        if currentPickedExerciseList.count == 0 {
            let alertView = UIAlertController(title: "Create Routine Failed",
                                              message: "Please Add At Least One Exercise",
                                              preferredStyle:. alert)
            let okAction = UIAlertAction(title: "Dismiss", style: .default)
            alertView.addAction(okAction)
            present(alertView, animated: true)
        } else {
            let newRoutine = Routine(context: context)
            newRoutine.name = routineName.text!
            newRoutine.favorite = false
            save()
            for exercise in currentPickedExerciseList {
                let newRoutineExercise = Routine_Exercise(context: context)
                newRoutineExercise.name = exercise[0]
                newRoutineExercise.sets = Int16(exercise[1])!
                newRoutineExercise.reps = Int16(exercise[2])!
                newRoutineExercise.parentRoutine = newRoutine
                save()
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    //Delete the Temp Routine
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        
        var routineArray: [Routine]?
        do { routineArray = try context.fetch(Routine.fetchRequest()) } catch { print("\(error)") }
        context.delete((routineArray?.last)!)
        save()
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Add Exercise from PickerView
    @IBAction func addExercisesPressed(_ sender: Any) {
        routineName.resignFirstResponder()
        print("add button pressed")
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250, height: 300)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        
        let alert = UIAlertController(title: "Add Exercise", message: nil, preferredStyle: .alert)
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
            print("add")
            self.currentPickedExerciseList.append(self.currentPickedExercise!)
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            print("cancel")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Save to Database
    func save() {
        do {
            try context.save()
        } catch {
            print("\(error)")
        }
    }
}

// Move Cell
//extension NewRoutineTableViewController {
//    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//
//    }
//
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//}


// PickerView
extension NewRoutineTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    //MARK: Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return exerciseList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //MARK: Update 0
        currentPickedExercise = [exerciseList[row].name, "", ""] as? [String]
        print(currentPickedExercise!)
        return exerciseList[row].name
    }
}

// TextField Delegate
extension NewRoutineTableViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let row = textField.tag / 10
        let queue = textField.tag % 10
        
        currentPickedExerciseList[row][queue + 1] = textField.text!
    }
    
    //MARK: Set Max Length to 2 Digit
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 2 // Bool
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Need Edit TextField Return
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
//        textField.resignFirstResponder()
//        return true
    }
}
