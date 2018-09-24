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
    var currentRoutineExerciseArray = [Routine_Exercise]()
    var exerciseToDelete = [Routine_Exercise]()
    
    var textFieldTag: Int?
    
    var signal: String?
    
    var selectedRoutine: Routine? {
        didSet {
            print("Did Set")
            //MARK: Save to local var
            if let routine = selectedRoutine {
                print("Routine: ", routine)
                if let exercises = routine.routineExercises?.array {
                    currentRoutineExerciseArray = exercises as! [Routine_Exercise]
                    currentRoutineExerciseArray = currentRoutineExerciseArray.sorted(by: { $0.ranking < $1.ranking })
                }
            }
            //MARK: Prepare data for Tableview
            //load()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("new routine TVC loaded")
        routineName.delegate = self
        tableView.isEditing = true
        print("Singal from Previous VC: \(signal ?? "")")
        
        if selectedRoutine == nil {
            deleteButtonView.isHidden = true
        } else {
            routineName.text = selectedRoutine?.name
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        exerciseList = (tempRoutine?.routineExercises)!.allObjects as! [Routine_Exercise]
        tableView.reloadData()
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
        return currentRoutineExerciseArray.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Current Row: \(indexPath.row)")
    }
//
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! NewRoutineTableViewCell
        
        //MARK: Set up Toolbar for Keypad
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 42))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonPressed))

        toolbar.setItems([doneButton, flexSpace, nextButton], animated: true)
        
        cell.setTextField.delegate = self
        cell.repTextField.delegate = self
        cell.repTextField.inputAccessoryView = toolbar
        cell.setTextField.inputAccessoryView = toolbar
        cell.setTextField.tag = indexPath.row * 2
        cell.repTextField.tag = indexPath.row * 2 + 1
//        cell.exerciseName.adjustsFontSizeToFitWidth = true
        cell.exerciseName.text = currentRoutineExerciseArray[indexPath.row].name
        
        if currentRoutineExerciseArray[indexPath.row].sets == 0 {
            cell.setTextField.text = ""
        } else {
            cell.setTextField.text = String(currentRoutineExerciseArray[indexPath.row].sets)
        }
        
        if currentRoutineExerciseArray[indexPath.row].reps == 0 {
            cell.repTextField.text = ""
        } else {
            cell.repTextField.text = String(currentRoutineExerciseArray[indexPath.row].reps)
        }
        
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
        context.delete(selectedRoutine!)
        save()
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: Save to database When finished
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        print(currentRoutineExerciseArray)
        self.view.endEditing(true) //Dismiss keyboard and save content by trigger resignFirstResponder
        var validSetRep = false
        var checkSetRep = [Int16]()
        var validRoutineName = false
        
        for exercise in currentRoutineExerciseArray {
            checkSetRep.append(exercise.sets)
            checkSetRep.append(exercise.reps)
        }
        
        if checkSetRep.contains(0) {
            validSetRep = false
        } else {
            validSetRep = true
        }
        
        if routineName.text == "" {
            validRoutineName = false
        } else {
            validRoutineName = true
        }
        
        if currentRoutineExerciseArray.count == 0 {
            let alertView = UIAlertController(title: "Create Routine Failed",
                                              message: "Please Add At Least One Exercise",
                                              preferredStyle:. alert)
            let okAction = UIAlertAction(title: "Dismiss", style: .default)
            alertView.addAction(okAction)
            present(alertView, animated: true)
        }
        else if validSetRep && validRoutineName {
            if selectedRoutine == nil {
                let newRoutine = Routine(context: context)
                newRoutine.name = routineName.text!
                newRoutine.favorite = false
                
                //TODO: Fix Delete, Routine Name
                for (index, exercise) in currentRoutineExerciseArray.enumerated() {
                    exercise.ranking = Int16(index)
                    exercise.parentRoutine = newRoutine
                }
                save()
            } else {    //Edit Routine
                selectedRoutine?.name = routineName.text
                for (index, exercise) in currentRoutineExerciseArray.enumerated() {
                    exercise.ranking = Int16(index)
                    if exercise.parentRoutine == nil {
                        exercise.parentRoutine = selectedRoutine!
                    }
                    print("To Save: ", exercise)
                    save()
                }
                for exercise in exerciseToDelete {
                    context.delete(exercise)
                    save()
                }
            }
            dismiss(animated: true, completion: nil)
        } else if validSetRep == false && validRoutineName == true {
            let alert = UIAlertController(title: "Oops", message: "Please Enter Set and Rep number For Each Exercise", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { (_) in
                print("fail set or rep")
            }))
            self.present(alert, animated: true, completion: nil)
        } else if validSetRep == true && validRoutineName == false {
            let alert = UIAlertController(title: "Oops", message: "Please Enter a Routine Name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { (_) in
                print("fail routine name")
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Oops", message: "Please Enter Set and Rep number For Each Exercise and a Routine Name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { (_) in
                print("fail two!")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //Delete the Temp Routine
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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


extension NewRoutineTableViewController {
    //MARK: Slide to remove exercise
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            routineExercises.remove(at: indexPath.row)
            exerciseToDelete.append(currentRoutineExerciseArray[indexPath.row])
            currentRoutineExerciseArray.remove(at: indexPath.row)
            //TODO: Delete from context
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
        let exerciseToMove = currentRoutineExerciseArray[sourceIndexPath.row]
        currentRoutineExerciseArray.remove(at: sourceIndexPath.row)
        currentRoutineExerciseArray.insert(exerciseToMove, at: destinationIndexPath.row)
        tableView.reloadData()
        print(currentRoutineExerciseArray)
    }
}


//MARK: Receive Selected Exercise Array
extension NewRoutineTableViewController: ReceiveRoutineExercises {
    func routineExerciseReceived(from exerciseArray: [Exercise]) {
        if exerciseArray.count > 0 {
            for exercise in exerciseArray {
                let newRoutineExercise = Routine_Exercise(context: context)
                newRoutineExercise.name = exercise.name
                newRoutineExercise.category = exercise.category
                currentRoutineExerciseArray.append(newRoutineExercise)
//                let newExercise = SelecteharshdExercise(name: exercise.name!, category: exercise.category!)
//                routineExercises.append(newExercise)
                print("Current: " ,currentRoutineExerciseArray)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSelectExerciseForRoutineVC" {
            let destinationVC = segue.destination as! SelectExerciseForRoutineVC
            destinationVC.delegate = self
        }
    }
}

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
//                routineExercises[indexPath.row].sets = textField.text
                currentRoutineExerciseArray[indexPath.row].sets = Int16(textField.text!) ?? 0
            case 1:
//                routineExercises[indexPath.row].reps = textField.text
                currentRoutineExerciseArray[indexPath.row].reps = Int16(textField.text!) ?? 0
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
