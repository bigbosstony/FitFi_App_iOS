//
//  NewRoutineTableViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-07-03.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit
import CoreData

protocol DataToReceive {
    func dataReceive(data: Int)
}

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
    var delegate: DataToReceive?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var routineName: UITextField!
    @IBOutlet weak var deleteButtonView: UIView!
    
    var routineExercises = [SelectedExercise]()
    var textFieldTag: Int?
    
    var signal: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("new routine TVC loaded")
        routineName.delegate = self
        tableView.isEditing = true
        print("Singal from Previous VC: \(signal ?? "")")
        
        if signal != "edit" {
            deleteButtonView.isHidden = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        exerciseList = (tempRoutine?.routineExercises)!.allObjects as! [Routine_Exercise]
        tableView.reloadData()
        print(routineExercises)
    }
    
    //Dismiss Keyboard when draging
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
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonPressed))
//        let doneButton = UIBarButtonItem(image: UIImage(named: "Glyphs/Dismiss Keyboard"), style: .plain, target: self, action: #selector(dismissKeyboard))
//        let nextButton = UIBarButtonItem(image: UIImage(named: "Glyphs/Next"), style: .plain, target: self, action: #selector(nextButtonPressed))
        toolbar.setItems([doneButton, flexSpace, nextButton], animated: true)
        
        cell.setTextField.delegate = self
        cell.repTextField.delegate = self
        cell.repTextField.inputAccessoryView = toolbar
        cell.setTextField.inputAccessoryView = toolbar
        cell.setTextField.tag = indexPath.row * 2
        cell.repTextField.tag = indexPath.row * 2 + 1
//        cell.exerciseName.adjustsFontSizeToFitWidth = true
        cell.exerciseName.text = routineExercises[indexPath.row].name
        cell.setTextField.text = routineExercises[indexPath.row].sets
        cell.repTextField.text = routineExercises[indexPath.row].reps
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        // Configure the cell...
        return cell
    }

    
    //Got To Next TextField
    @objc func nextButtonPressed() {
        print("next button pressed")
        print("tag: ", textFieldTag ?? 100)
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
    
    //MARK: Call Delegate Function
    @IBAction func deleteRoutineButtonPressed(_ sender: UIButton) {
        print("delete")
        delegate?.dataReceive(data: 0)
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: Save to database When finished
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        print(routineExercises)
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
            for (index, exercise) in routineExercises.enumerated() {
                let newRoutineExercise = Routine_Exercise(context: context)
                newRoutineExercise.name = exercise.name
                newRoutineExercise.ranking = Int16(index)
                newRoutineExercise.sets = Int16(exercise.sets!)!
                newRoutineExercise.reps = Int16(exercise.reps!)!
                newRoutineExercise.category = exercise.category
                newRoutineExercise.parentRoutine = newRoutine
                save()
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    //TODO: Safty Check Set, Rep, Name
    
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


extension NewRoutineTableViewController {
    
    //MARK: Slide to remove exercise
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            routineExercises.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return .none
//    }
//
//    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }

    //MARK: Drag and Drop TableView Cells
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let exerciseToMove = routineExercises[sourceIndexPath.row]
        routineExercises.remove(at: sourceIndexPath.row)
        routineExercises.insert(exerciseToMove, at: destinationIndexPath.row)
        tableView.reloadData()
        print(routineExercises)
    }
}


//MARK: Receive Selected Exercise
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

        if textField != routineName {
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
    }

    //Store textField Tag
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldTag = textField.tag
    }
    
    //MARK: Set Max Length to 2 Digit
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField != routineName {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 2 // Bool
        } else {
            return true // Return true for routine name textfield
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Need Edit TextField Return
        // Try to find next responder
        
//        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
//            nextField.becomeFirstResponder()
//        } else {
//            // Not found, so remove keyboard.
//            textField.resignFirstResponder()
//        }
        if textField == routineName {
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return true
//        textField.resignFirstResponder()
//        return true
    }
    
    
}
