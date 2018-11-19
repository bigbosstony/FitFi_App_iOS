//
//  MaxTrackingViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-07-16.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit
import CoreData


class MaxTrackingViewController: UIViewController {

    var message: Int?
    
    var timer = Timer()
    
    //Hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var whoIsOnTop = 0
    
    @IBOutlet weak var singleUserView: UIView!
    @IBOutlet weak var dualUserView: UIView!
    
    
    @IBOutlet weak var currentCountLabel: UILabel!
    
    
    var currentWorkoutUpdater = CurrentWorkoutUpdater() {
        didSet {
            print("MAX updater: ", currentWorkoutUpdater)
           
//            currentCountLabel.text! = "T"
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Maxi Tracking VC Loaded")
        
        
        currentCountLabel.text = "9"
        //MARK: Testing Timer
//        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateRandomInt), userInfo: nil, repeats: true)
//        delegate.update(with: 2)
        
    }
    
//    @IBAction func changeUserView(_ sender: UIButton) {
//        if !flipStatus {
//            UIView.transition(from: singleUserView, to: singleUserView, duration: 1, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
//            flipStatus = true
//            number += 1
//            testingLabel.text = String(number)
//        } else {
//            UIView.transition(from: singleUserView, to: singleUserView, duration: 1, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
//            flipStatus = false
//            number += 1
//            testingLabel.text = String(number)
//        }
//
//    }
    
    func updateMaxiView(with workoutData: CurrentWorkoutUpdater) -> Void {
        currentCountLabel.text = String(workoutData.currentCount)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func closeButtonTapped(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
    
    //MARK: Testing Function
    @objc func updateRandomInt() {
//        print("MAX: ", delegate.message)
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishButtonPressed(_ sender: UIButton) {
        
    }
    
    
    
    @IBAction func switchSingleUserViewButtonPressed(_ sender: UIButton) {
        if whoIsOnTop == 0 {
            UIView.transition(from: singleUserView, to: singleUserView, duration: 1, options: [.transitionCurlUp, .showHideTransitionViews], completion: nil)
            whoIsOnTop = 1
        } else if whoIsOnTop == 1 {
            UIView.transition(from: singleUserView, to: singleUserView, duration: 1, options: [.transitionCurlDown, .showHideTransitionViews], completion: nil)
            whoIsOnTop = 0
        } else {
            UIView.transition(from: dualUserView, to: singleUserView, duration: 1, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
            whoIsOnTop = 0
        }
        print("\(whoIsOnTop) is on top")
    }
    
    
    @IBAction func compareUserButtonPressed(_ sender: UIButton) {
        switch whoIsOnTop {
        case 2:
            UIView.transition(from: dualUserView, to: singleUserView, duration: 1, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
            whoIsOnTop = 0
        case 0:
            UIView.transition(from: singleUserView, to: dualUserView, duration: 1, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
            whoIsOnTop = 2
        case 1:
            UIView.transition(from: singleUserView, to: dualUserView, duration: 1, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
            whoIsOnTop = 2
        default:
            print("error")
        }
        print("\(whoIsOnTop) is on top")
    }
    

}


