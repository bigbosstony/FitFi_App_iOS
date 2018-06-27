//
//  ViewController.swift
//  FitfiApp
//
//  Created by Yan Yu on 2018-06-05.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var recentWorkoutView: UIView!
    @IBOutlet weak var recentWorkoutCollectionView: UICollectionView!
    @IBOutlet weak var routinesCollectionView: UICollectionView!
    @IBOutlet weak var todayCollectionView: UICollectionView!
    
    @IBOutlet weak var noRecentWorkoutView: UIView!
    @IBOutlet weak var showAllRoutinesTableView: UITableView!
    @IBOutlet weak var showAllExercisesTableView: UITableView!
    
    var trackingVC: UIViewController!
    var window: UIWindow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Home View Loaded")
        
        //MARK: window and trackingVC
//        trackingVC = TrackingSViewController.init(nibName: "TrackingSViewController", bundle: nil)
//        trackingVC.view.frame = CGRect(x: 0, y: 497.5, width: 375, height: 120)
//        window = UIApplication.shared.keyWindow!
//        window.addSubview(trackingVC.view!)
//        trackingVC.view.isHidden = true
        
        todayCollectionView.register(UINib.init(nibName: "TodayCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TodayCollectionViewCell")
        if let flowLayout = todayCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1,height: 1)
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == recentWorkoutCollectionView {
            if workout.count == 0 {
                noRecentWorkoutView.isHidden = false
            }
            return workout.count
        } else if collectionView == routinesCollectionView {
            return 5
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == recentWorkoutCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recentWorkoutCell", for: indexPath) as! RecentWorkoutCollectionViewCell
            cell.workoutNameLabel.text = workout[indexPath.row]
            return cell
            
        } else if collectionView == routinesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "routineCollectionCell", for: indexPath) as! RoutineCollectionViewCell
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodayCollectionViewCell", for: indexPath) as! TodayCollectionViewCell
            cell.scheduledLabel.text = "NOTHING SCHEDULED"
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
        if collectionView == recentWorkoutCollectionView {
            performSegue(withIdentifier: "goToRecentWorkoutTableview", sender: self)
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
