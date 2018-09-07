//
//  collectionView-In-CVC-Testing.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-08-13.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit

struct CurrentWorkoutExercise {
    var name: String
    var setArray: [Int16]
    var setDoneArray: [Bool]
    var done: Bool
}


class ManualTrackingVC: UIViewController {

    //MARK: Properties
    
    @IBOutlet weak var exerciseCollectionView: UICollectionView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currentExerciseNameLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var currentExerciseCounterLabel: UILabel!
    @IBOutlet weak var overallTimer: UILabel!
    
    var dateFormatter = DateFormatter()
    var titleTimer = Timer()
    var timer = Timer()
    var routineName = "Name"
    var currentWorkoutExerciseArray = [CurrentWorkoutExercise]()
    var currentWorkoutExerciseIndex: Int = 0
    var currentWorkoutExerciseSetIndex: Int = 0
    
    var scrollOffsetXmin : CGFloat = 0
    var scrollOffsetXmax : CGFloat = 0
    
    var seconds = 0

    var selectedRoutine: Routine? {
        didSet {
            if let routine = selectedRoutine {
                //TODO: Load By Order
                if let exerciseArray = routine.routineExercises?.array {
                    for exercise in exerciseArray as! [Routine_Exercise] {
                        let setArray = [Int16](repeating: exercise.reps, count: Int(exercise.sets))
                        let setDoneArray = [Bool](repeating: false, count: Int(exercise.sets))
                        
                        let newCurrentWorkoutExercise = CurrentWorkoutExercise(name: exercise.name!, setArray: setArray, setDoneArray: setDoneArray, done: false)
                        currentWorkoutExerciseArray.append(newCurrentWorkoutExercise)
                    }
                }
                routineName = selectedRoutine?.name ?? ""
            }
            print(currentWorkoutExerciseArray)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseCollectionView.delegate = self
        exerciseCollectionView.dataSource = self
        //Set the section inset value
        let sectionInsetValue = self.view.frame.width / 2 - 125
        scrollOffsetXmax = self.view.frame.width
        currentExerciseNameLabel.text = currentWorkoutExerciseArray[0].name
        currentExerciseCounterLabel.text = "1/\(currentWorkoutExerciseArray.count)"
        
        //Assign the value to uicollectionview
        let collectionViewLayout = exerciseCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        collectionViewLayout?.sectionInset = UIEdgeInsets(top: 0, left: sectionInsetValue, bottom: 0, right: sectionInsetValue)
        collectionViewLayout?.invalidateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        runTimer()
        
        if currentWorkoutExerciseSetIndex == currentWorkoutExerciseArray[currentWorkoutExerciseIndex].setArray.count - 1 {
            nextButton.setTitle("Next Exercise", for: .normal)
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        titleTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTitleView), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds += 1
        overallTimer.text = timeString(time: TimeInterval(seconds))
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //Next Button Event
    @IBAction func goToNextButtonPressed(_ sender: UIButton) {
        print(currentWorkoutExerciseArray.count, currentWorkoutExerciseIndex, currentWorkoutExerciseSetIndex)
        
        if nextButton.titleLabel?.text == "Finish" {
            //MARK: Save
            self.dismiss(animated: true, completion: nil)
            
        } else if currentWorkoutExerciseIndex < currentWorkoutExerciseArray.count {
            
            if currentWorkoutExerciseSetIndex < currentWorkoutExerciseArray[currentWorkoutExerciseIndex].setArray.count {
                nextButton.setTitle("Next Set", for: .normal)
                currentWorkoutExerciseArray[currentWorkoutExerciseIndex].setDoneArray[currentWorkoutExerciseSetIndex] = true
                currentWorkoutExerciseSetIndex += 1
                
                if currentWorkoutExerciseSetIndex == currentWorkoutExerciseArray[currentWorkoutExerciseIndex].setArray.count {
                    currentWorkoutExerciseArray[currentWorkoutExerciseIndex].done = true
                    print("Flow To Next")
                    
                    currentWorkoutExerciseIndex += 1
                    currentWorkoutExerciseSetIndex = 0
                    
                    self.exerciseCollectionView.scrollToItem(at: IndexPath(item: currentWorkoutExerciseIndex, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
                    currentExerciseCounterLabel.text = "\(currentWorkoutExerciseIndex + 1)/\(currentWorkoutExerciseArray.count)"

                } else if currentWorkoutExerciseSetIndex == currentWorkoutExerciseArray[currentWorkoutExerciseIndex].setArray.count - 1 {
                    if currentWorkoutExerciseIndex == currentWorkoutExerciseArray.count - 1 {
                        nextButton.setTitle("Finish", for: .normal)
                    } else {
                        nextButton.setTitle("Next Exercise", for: .normal)
                    }
                }
            }
        }
        
        print(currentWorkoutExerciseArray)
        exerciseCollectionView.reloadData()
    }
}

extension ManualTrackingVC {
    //TODO: Global Function
    @objc func updateTitleView() {
        dateFormatter.dateFormat = "EEEE MMM dd HH:mm a"
        let date = Date()
        let dateString = dateFormatter.string(from: date).uppercased()
        let attrs1 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: .semibold), NSAttributedStringKey.foregroundColor : UIColor.black]
        let attrs2 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12, weight: .regular), NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.8352941176, green: 0.3725490196, blue: 0.1215686275, alpha: 1)] as [NSAttributedStringKey : Any]
        
        let attributedString1 = NSMutableAttributedString(string: routineName.capitalized + "\n", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string: dateString, attributes:attrs2)
        attributedString1.append(attributedString2)
        
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.attributedText = attributedString1
    }
}

extension ManualTrackingVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentWorkoutExerciseArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("From Manual Tracking VC")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exerciseCVCell", for: indexPath) as! ExerciseCollectionViewCell
        cell.setArray = currentWorkoutExerciseArray[indexPath.row].setArray
        cell.setDoneArray = currentWorkoutExerciseArray[indexPath.row].setDoneArray
        cell.indexPath = indexPath
        cell.setCollectionView.reloadData()
        
        if let index = currentWorkoutExerciseArray[indexPath.row].setDoneArray.index(of: false) {
            cell.mainCounterLabel.text = String(currentWorkoutExerciseArray[indexPath.row].setArray[index])
        } else {
            cell.mainCounterLabel.text = String(currentWorkoutExerciseArray[indexPath.row].setArray.last!)
        }
        
        //Setuo Toolbar for Keypad
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 42))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        
        cell.weightLabel.inputAccessoryView = toolbar
        
        cell.delegate = self
        
        return cell
    }
    
    //
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        scrollOffsetXmin = scrollView.contentOffset.x
        scrollOffsetXmax = scrollView.contentOffset.x + self.view.frame.size.width
        let currentFrame = [scrollOffsetXmin, scrollOffsetXmax]
        print(currentFrame)
        
        let currentVisibleCellArray = self.exerciseCollectionView.visibleCells
        
        for cell in currentVisibleCellArray {
            if cell.frame.minX > scrollOffsetXmin && cell.frame.maxX < scrollOffsetXmax {
                let index = self.exerciseCollectionView.indexPath(for: cell)?.row
                currentExerciseNameLabel.text = currentWorkoutExerciseArray[index!].name
            }
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}


extension ManualTrackingVC: ExerciseCollectionViewCellDelegate {
    func ExerciseCollectionViewCellDidTapPlus(_ sender: ExerciseCollectionViewCell) {
        if let index = sender.setDoneArray.index(of: false) {
            let numberPlusOne = sender.setArray[index] + 1
            sender.setArray[index] = numberPlusOne
            sender.mainCounterLabel.text = String(numberPlusOne)
            sender.setCollectionView.reloadData()
            currentWorkoutExerciseArray[sender.indexPath.row].setArray[index] = numberPlusOne
        }
    }
    
    func ExerciseCollectionViewCellDidTapMinus(_ sender: ExerciseCollectionViewCell) {
        if let index = sender.setDoneArray.index(of: false) {
            var numberMinusOne = sender.setArray[index] - 1
            if numberMinusOne < 1 {
                numberMinusOne = 1
            }
            sender.setArray[index] = numberMinusOne
            sender.mainCounterLabel.text = String(numberMinusOne)
            sender.setCollectionView.reloadData()
            currentWorkoutExerciseArray[sender.indexPath.row].setArray[index] = numberMinusOne
        }
    }
    
    
}




