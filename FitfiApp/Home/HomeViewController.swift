//
//  ViewController.swift
//  FitfiApp
//
//  Created by Yan Yu on 2018-06-05.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    //Data and Outlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var recentWorkoutView: UIView!
    @IBOutlet weak var recentWorkoutCollectionView: UICollectionView!
    @IBOutlet weak var routinesCollectionView: UICollectionView!
    @IBOutlet weak var todayCollectionView: UICollectionView!
    
    @IBOutlet weak var noRecentWorkoutView: UIView!
    @IBOutlet weak var showAllRoutinesTableView: UITableView!
    @IBOutlet weak var showAllExercisesTableView: UITableView!
    @IBOutlet weak var noRoutineView: UIView!
    @IBOutlet weak var noRoutineLabel: UILabel!
    
    
    var trackingVC: UIViewController!
    var window: UIWindow!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var routineArray = [Routine]()
    var routineHistoryArray = [Routine_History]()
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Home View Loaded")
        print(UserDefaults.standard.value(forKey: "phoneNumber")!)
//// Ignore This Mark   MARK: window and trackingVC
//        trackingVC = TrackingSViewController.init(nibName: "TrackingSViewController", bundle: nil)
//        trackingVC.view.frame = CGRect(x: 0, y: 497.5, width: 375, height: 120)
//        window = UIApplication.shared.keyWindow!
//        window.addSubview(trackingVC.view!)
//        trackingVC.view.isHidden = true
        
        //MARK: Register Customized Cell for Today Collection View
        todayCollectionView.register(UINib.init(nibName: "TodayCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TodayCollectionViewCell")
        if let flowLayout = todayCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 384, height: 64)
        }
        
        recentWorkoutCollectionView.delegate = self
        recentWorkoutCollectionView.dataSource = self
        routinesCollectionView.delegate = self
        routinesCollectionView.dataSource = self
        todayCollectionView.delegate = self
        todayCollectionView.dataSource = self
        
        showAllRoutinesTableView.delegate = self
        showAllRoutinesTableView.dataSource = self
        showAllExercisesTableView.delegate = self
        showAllExercisesTableView.dataSource = self
        
        //Window
//        let window = UIApplication.shared.keyWindow!
//        let v = UIView(frame: CGRect(x: 50, y: 50, width: 100, height: 50))
//        window.addSubview(v)
//        v.backgroundColor = UIColor.black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("Home view Will Appear")

        loadRoutines()
        loadRecentWorkout()
        
        dateFormatter.dateFormat = "EEEE,MMM dd,HH:mm a"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("HomeView Did Appear")
        //MARK: Find Top VC
//        if let topVC = UIApplication.topViewController() {
//            print(topVC)
//        }
        //MARK: Find Child VC
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        if let viewControllers = appDelegate.window?.rootViewController?.childViewControllers
//        {
//            // Array of all viewcontroller after push
//            print(viewControllers)
//        }
    }
}

//MARK: Load Data
extension HomeViewController {
    //Load Routines
    func loadRoutines(with request: NSFetchRequest<Routine> = Routine.fetchRequest()) {
        do {
            routineArray = try context.fetch(request)
        } catch {
            print("\(error)")
        }
        routinesCollectionView.reloadData()
    }
    
    //Load Recent Workout
    func loadRecentWorkout() {
        var rCount = 0
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName:"Routine_History")
//        let sortDescriptor = NSSortDescriptor(key: "start", ascending: false)
//        fr.sortDescriptors = [sortDescriptor]
//        fr.fetchLimit = 5
        do { rCount = try context.count(for: fr) } catch { print(error) }

        if rCount > 5 {
            fr.fetchOffset = rCount - 4
        } else {
            fr.fetchOffset = 0
        }
        do { routineHistoryArray = try context.fetch(fr) as! [Routine_History] } catch { print(error) }
        routineHistoryArray = routineHistoryArray.reversed()
        recentWorkoutCollectionView.reloadData()
    }
}

// MARK: Collection View Data Source
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == recentWorkoutCollectionView {
            if routineHistoryArray.count == 0 {
                noRecentWorkoutView.isHidden = false
            } else {
                noRecentWorkoutView.isHidden = true
            }
            return routineHistoryArray.count
        } else if collectionView == routinesCollectionView {
            if routineArray.count == 0 {
                noRoutineLabel.text = noRoutineText
                noRoutineView.isHidden = false
            } else {
                noRoutineView.isHidden = true
            }
            return routineArray.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //MARK: Recent Workout From Home Page
        if collectionView == recentWorkoutCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recentWorkoutCell", for: indexPath) as! RecentWorkoutCollectionViewCell
            let startTime = routineHistoryArray[indexPath.row].start
//            let endTime = routineHistoryArray[indexPath.row].end
            let duration = routineHistoryArray[indexPath.row].duration
            let dateString = dateFormatter.string(from: startTime!)
            let dateStringArray = dateString.components(separatedBy: ",")
            let dateDictionary = ["DayOfWeek": dateStringArray[0], "Date": dateStringArray[1], "Time": dateStringArray[2]]
            
            let numberOfExercise = routineHistoryArray[indexPath.row].exerciseHistory?.count ?? 0
            
            cell.workoutNameLabel.text = routineHistoryArray[indexPath.row].name?.uppercased()
            cell.dayOfTheWeekLabel.text = dateDictionary["DayOfWeek"]?.uppercased()
            cell.dateLabel.text = dateDictionary["Date"]?.uppercased()
            cell.timeLabel.text = dateDictionary["Time"]
            cell.timeDurationLabel.text = String(duration) + "m"
            cell.volumeLabel.text = String(routineHistoryArray[indexPath.row].totalWeight) + " lb"
            cell.calorieLabel.text = String(routineHistoryArray[indexPath.row].totalCalorie) + " kcal"
            cell.numberOfExercises.text = String(numberOfExercise)
            cell.typeOfTracking.isHidden = routineHistoryArray[indexPath.row].auto ? true : false
            return cell
            
            //MARK: Routine Collection View Data Source on HomePage
        } else if collectionView == routinesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "routineCollectionCell", for: indexPath) as! RoutineCollectionViewCell
            let numberOfExercise = routineArray[indexPath.row].routineExercises?.count ?? 0
            cell.routineNameLabel.text = routineArray[indexPath.row].name?.uppercased()
            cell.routineExerciseCountLabel.text = String(numberOfExercise)
            cell.estimateTimeLabel.text = "~" + String(numberOfExercise * 20) + "m"
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodayCollectionViewCell", for: indexPath) as! TodayCollectionViewCell
            cell.scheduledLabel.text = "NOTHING SCHEDULED"
            cell.instructionLabel.text = "Drag and Drop from routine to quickly schedule one"
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == recentWorkoutCollectionView {
            performSegue(withIdentifier: "goToRecentWorkoutDetailsVC", sender: self)
        } else if collectionView == routinesCollectionView {
            performSegue(withIdentifier: "goToRoutineDetailsTableview", sender: self)
        } else if collectionView == todayCollectionView {
            //MARK: will edit
//            if trackingVC.view.isHidden == true {
//                trackingVC.view.isHidden = false
//            } else {
//                trackingVC.view.isHidden = true
//            }
        }
    }
}

extension HomeViewController {
    //MAKR: Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRoutineDetailsTableview" {
            let destinationVC = segue.destination as! RoutineDetailsTableViewController
            if let indexPath = routinesCollectionView.indexPathsForSelectedItems?.first {
                destinationVC.selectedRoutine = routineArray[indexPath.row]
            }
        } else if segue.identifier == "goToRecentWorkoutDetailsVC" {
            let destinationVC = segue.destination as! RecentWorkoutDetailsTableViewController
            if let indexPath = recentWorkoutCollectionView.indexPathsForSelectedItems?.first {
                destinationVC.selectedRoutineHistory = routineHistoryArray[indexPath.row]
            }
        }
    }
}

//MARK: Table View Data Source
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == showAllRoutinesTableView {
            return 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == showAllRoutinesTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "showAllRoutinesTableViewCell", for: indexPath) as! ShowAllRoutinesTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "showAllExercisesTableViewCell", for: indexPath) as! ShowAllExercisesTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == showAllRoutinesTableView {
            performSegue(withIdentifier: "goToRoutinesTableView", sender: self)
        } else {
            performSegue(withIdentifier: "goToExerciseTableView", sender: self)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
