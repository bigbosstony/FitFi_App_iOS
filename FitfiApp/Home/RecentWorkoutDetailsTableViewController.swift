//
//  RecentWorkoutTableViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-06-07.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit
import CoreData

class RecentWorkoutDetailsTableViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var currentExerciseHistory = [Exercise_History]()
    var titleLabel = UILabel()
    var dateFormatter = DateFormatter()
    
    @IBOutlet weak var totalCalorieLabel: UILabel!
    @IBOutlet weak var totalWeightLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    var totalCalorie: String!
    var totalWeight: String!
    var workoutName: String!
    var duration: String!
    var date: Date!
    var name: String!
    
    var selectedRoutineHistory: Routine_History? {
        didSet {
            print("Did Set")
            //MARK: Save to local var
            if let workout = selectedRoutineHistory {
                print("Workout: ", workout)
                saveWorkoutDate(from: workout)
                if let exercises = workout.exerciseHistory?.array {
                    currentExerciseHistory = exercises as! [Exercise_History]
//                    print("Workout Exercises : ", currentExerciseHistory)
//                    for exercise in currentExerciseHistory {
//                        print(exercise.name!)
//                    }
                }
            }
            
            //MARK: Prepare data for Tableview
            //load()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View Did Load")
        updateView(date: date, name: name, duration: duration, totalWeight: totalWeight, totalCalorie: totalCalorie)
        
        print(currentExerciseHistory.count)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currentExerciseHistory.count
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = currentExerciseHistory[indexPath.row].name
        
        return cell
     }
 
}

extension RecentWorkoutDetailsTableViewController {
    
    func saveWorkoutDate(from selectedRoutine: Routine_History) {
        //TODO: Save Workout Attribute
        totalWeight = String(selectedRoutine.totalWeight) + " lb"
        totalCalorie = String(selectedRoutine.totalCalorie) + " kcal"
        date = selectedRoutine.start
        name = selectedRoutine.name
        duration = String(selectedRoutine.duration) + " m"
        //TODO: Save Exercise Attribute
    }
    
    func updateView(date: Date, name: String, duration: String, totalWeight: String, totalCalorie: String) {
        dateFormatter.dateFormat = "EEEE MMM dd HH:mm a"
        let dateString = dateFormatter.string(from: date).uppercased()
        //MARK: Build multiple lines with different color and text size for nav bar title
        let attrs1 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: .semibold), NSAttributedStringKey.foregroundColor : UIColor.black]
        let attrs2 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12, weight: .regular), NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.8352941176, green: 0.3725490196, blue: 0.1215686275, alpha: 1)] as [NSAttributedStringKey : Any]
        //Routine Name
        let attributedString1 = NSMutableAttributedString(string: name.capitalized + "\n", attributes:attrs1)
        //Routine Start Time
        let attributedString2 = NSMutableAttributedString(string: dateString, attributes:attrs2)
        attributedString1.append(attributedString2)
        
        titleLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 44)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.attributedText = attributedString1
        
        self.navigationItem.titleView = titleLabel
        durationLabel.text = duration
        totalWeightLabel.text = totalWeight
        totalCalorieLabel.text = totalCalorie
    }
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


