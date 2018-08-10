//
//  NewRoutineTableViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-07-03.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit
import CoreData

struct SelectedExercise {
    var name: String
    var category: String
    var sets: String?
    var reps: String?
    
    init(name: String, category: String) {
        self.name = name
        self.category = category
    }
}

class NewRoutineTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var routineName: UITextField!
    
    var routineExercises = [SelectedExercise]()
    var textFieldTag: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("new routine TVC loaded")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        exerciseList = (tempRoutine?.routineExercises)!.allObjects as! [Routine_Exercise]
        tableView.reloadData()
        print(routineExercises)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.keyboardDismissMode = .onDrag
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
        return routineExercises.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Current Row: \(indexPath.row)")
    }
//
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! NewRoutineTableViewCell
        
        //Set up Toolbar for Keypad
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 42))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let doneButton = UIBarButtonItem(image: UIImage(named: "Glyphs/Dismiss Keyboard"), style: .plain, target: self, action: #selector(dismissKeyboard))
        let nextButton = UIBarButtonItem(image: UIImage(named: "Glyphs/Next"), style: .plain, target: self, action: #selector(nextButtonPressed))
        toolbar.setItems([flexSpace, doneButton, flexSpace, nextButton], animated: true)
        
        cell.setTextField.delegate = self
        cell.repTextField.delegate = self
        cell.repTextField.inputAccessoryView = toolbar
        cell.setTextField.inputAccessoryView = toolbar
        cell.setTextField.tag = indexPath.row * 2
        cell.repTextField.tag = indexPath.row * 2 + 1
        cell.textLabel?.text = routineExercises[indexPath.row].name
        cell.setTextField.text = routineExercises[indexPath.row].sets
        cell.repTextField.text = routineExercises[indexPath.row].reps
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        // Configure the cell...
        return cell
    }
    
    //Got To Next TextField
    @objc func nextButtonPressed() {
        print("next button pressed")
        if let tag = textFieldTag {
            if let nextTextField = self.view.viewWithTag(tag + 1) {
                nextTextField.becomeFirstResponder()
            } else {
                self.view.viewWithTag(tag)?.resignFirstResponder()
            }
        }

    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func addExerciseButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSelectExerciseForRoutineVC", sender: self)
    }

    // MARK: Save to database When finished
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        self.view.endEditing(true) //Dismiss keyboard and save content by trigger resignFirstResponder
        if routineExercises.count == 0 {
            let alertView = UIAlertController(title: "Create Routine Failed",
                                              message: "Please Add At Least One Exercise",
                                              preferredStyle:. alert)
            let okAction = UIAlertAction(title: "Dismiss", style: .default)
            alertView.addAction(okAction)
            present(alertView, animated: true)
        } else {
            let newRoutine = Routine(context: context)
            //Check routine Name, Sets, Reps later
            newRoutine.name = routineName.text!
            newRoutine.favorite = false
            for exercise in routineExercises {
                let newRoutineExercise = Routine_Exercise(context: context)
                newRoutineExercise.name = exercise.name
                newRoutineExercise.sets = Int16(exercise.sets!)!
                newRoutineExercise.reps = Int16(exercise.reps!)!
                newRoutineExercise.category = exercise.category
                newRoutineExercise.parentRoutine = newRoutine
            }
            save()
            dismiss(animated: true, completion: nil)
        }
    }
    
    //Delete the Temp Routine
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Add Exercise from PickerView
//    @IBAction func addExercisesPressed(_ sender: Any) {
//        routineName.resignFirstResponder()
//        print("add button pressed")
//        let vc = UIViewController()
//        vc.preferredContentSize = CGSize(width: 250, height: 300)
//        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
//        pickerView.delegate = self
//        pickerView.dataSource = self
//        vc.view.addSubview(pickerView)
//
//        let alert = UIAlertController(title: "Add Exercise", message: nil, preferredStyle: .alert)
//        alert.setValue(vc, forKey: "contentViewController")
//        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
//            print("add")
//            self.currentPickedExerciseList.append(self.currentPickedExercise!)
//            self.tableView.reloadData()
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
//            print("cancel")
//        }))
//        self.present(alert, animated: true, completion: nil)
//    }
    
    //MARK: Save to Database
    func save() {
        do {
            try context.save()
        } catch {
            print("\(error)")
        }
    }
}



extension NewRoutineTableViewController: ReceiveRoutineExercises {
    func routineExerciseReceived(from exerciseArray: [Exercise]) {
        if exerciseArray.count > 0 {
            for exercise in exerciseArray {
                let newExercise = SelectedExercise(name: exercise.name!, category: exercise.category!)
                routineExercises.append(newExercise)
            }
        }
//        selectedExerciseArray = exerciseArray
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSelectExerciseForRoutineVC" {
            let destinationVC = segue.destination as! SelectExerciseForRoutineVC
            destinationVC.delegate = self
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
//extension NewRoutineTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
//    //MARK: Picker View
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return exerciseList.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        //MARK: Update 0
//        currentPickedExercise = [exerciseList[row].name, "", ""] as? [String]
//        print(currentPickedExercise!)
//        return exerciseList[row].name
//    }
//}

// TextField Delegate
extension NewRoutineTableViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        let center: CGPoint = textField.center
        let rootViewPoint: CGPoint = textField.superview!.convert(center, to: tableView)
        let indexPath: IndexPath = tableView.indexPathForRow(at: rootViewPoint)! as IndexPath
        let textFieldTag = textField.tag % 2
        
        switch textFieldTag {
        case 0:
            routineExercises[indexPath.row].sets = textField.text
        case 1:
            routineExercises[indexPath.row].reps = textField.text
        default:
            print("error")
        }
        print(indexPath, textField.tag)
    }

    //Store textField Tag
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldTag = textField.tag
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
