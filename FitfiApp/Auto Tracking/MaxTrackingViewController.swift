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
    
    var timerCount = 5
    var timer = Timer()
    var restingTimer = Timer()
    
    var heartRate:Int = 75
    var calorieBurned:Int = 2
    var timerStr:String = ""
    var hearRateFlag:Int = 0
    //var workOutTimer:Date = Date()
    var startDate:Date = Date()
    var exTimer = Timer()
    
    //Hide status bar
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    lazy var currentUser = { () -> [String: Any] in
        var pic = ""
        if UserDefaults.standard.value(forKey: "user") as! Int == 1 {
            pic = "Users/harsh"
        } else {
            pic = "Users/devika"
        }
        
        let user = ["userID" : UserDefaults.standard.value(forKey: "user"), "userPicture": pic]
        return user as [String : Any]
    }()
    
    var otherUser: [String: Any]?
    
    var whoIsOnTop = 0 {
        didSet {
            self.currentExerciseTotalExerciseCollectionView.reloadData()
//            if whoIsOnTop == 1 {
//
//                applyButtonEffect(buttonOutlet: singleUserViewButton, imageName: otherUser?["userPicture"] as! String, flag: 1)
//
//                topView.backgroundColor = #colorLiteral(red: 0.2745098039, green: 0.08235294118, blue: 0.2745098039, alpha: 1)
//                deviceView.backgroundColor = #colorLiteral(red: 0.2745098039, green: 0.08235294118, blue: 0.2745098039, alpha: 1)
//                getOtherUsersExercise()
//                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getOtherUsersExercise), userInfo: nil, repeats: true)
//            }
//            else
            if whoIsOnTop == 0 {
                timer.invalidate()
                singleUserViewButton.isHidden = true
                otherUserViewButton.isHidden = true
                applyButtonEffect(buttonOutlet: singleUserViewButton, imageName: currentUser["userPicture"] as! String, flag: 1)
                topView.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.1529411765, blue: 0.168627451, alpha: 1)
                deviceView.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.1529411765, blue: 0.168627451, alpha: 1)
                self.updateMaxiView(of: userFromSingleLabelGroup, with: self.currentWorkoutUpdater)
                
            } else {
                singleUserViewButton.isHidden = false
                otherUserViewButton.isHidden = false

                applyButtonEffect(buttonOutlet: singleUserViewButton, imageName: currentUser["userPicture"] as! String, flag: 1)
                self.updateMaxiView(of: userFromDualLabelGroup, with: self.currentWorkoutUpdater)
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getOtherUsersExercise), userInfo: nil, repeats: true)
                dualUserView.isHidden = false
            }
        }
    }
    
    lazy var screenWidth = {
        return self.view.frame.size.width
    }()
    
    @IBOutlet weak var singleUserView: UIView!
    @IBOutlet weak var dualUserView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var deviceView: UIView!
    
    
    @IBOutlet weak var currentExerciseTotalExerciseCollectionView: UICollectionView!
    
    
    @IBOutlet var userFromSingleLabelGroup: [UILabel]!
    
    
    
    @IBOutlet weak var singleUserViewButton: UIButton!
    @IBOutlet weak var otherUserViewButton: UIButton!
    @IBOutlet weak var dualUserButton: UIButton!
    
    
    @IBOutlet var userFromDualLabelGroup: [UILabel]!
    
    @IBOutlet var otherFromDualLabelGroup: [UILabel]!
    
    @IBOutlet weak var leftUserView: UIView!
    @IBOutlet weak var rightUserView: UIView!
    
    
    @IBOutlet weak var reactionUIImageView: UIImageView!
    @IBOutlet weak var deviceWeightLabel: UILabel!
    @IBOutlet weak var deviceWeightLabelDS: UILabel!
    @IBOutlet weak var deviceWeightLabelDSO: UILabel!
    
    @IBOutlet weak var restView: UIView!
    @IBOutlet weak var restTimerLabel: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    
    var isResting: Bool = false {
        didSet {
            if restView != nil {
                if isResting {
                    restingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(resting), userInfo: nil, repeats: true)
                    restView.isHidden = false
                } else {
                    restView.isHidden = true
                }
            }
        }
    }
    
    var currentWorkoutUpdater = CurrentWorkoutUpdater() {
        didSet {
            calorieBurned += 1
            print("MAX updater: ", currentWorkoutUpdater)
            if userFromSingleLabelGroup != nil {
                DispatchQueue.main.async {
                    self.currentExerciseTotalExerciseCollectionView.reloadData()
                    //Update UI
                    if self.whoIsOnTop == 0 {
                        self.updateMaxiView(of: self.userFromSingleLabelGroup, with: self.currentWorkoutUpdater)
                    } else if self.whoIsOnTop == 2 {
                        self.updateMaxiView(of: self.userFromDualLabelGroup, with: self.currentWorkoutUpdater)
                    } else {
                        print("")
                    }
                }
            }
        }
    }
    
    var otherUserExerciseIndex = 0
    var otherUserExerciseFinished = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Maxi Tracking VC Loaded")
        
        print(currentUser)
        
//        userFromDualLabelGroup[0].text = "testing"
        
        
        startDate = Date()
        exTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateExTimer), userInfo: nil, repeats: true)
        
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(checkMyReaction), userInfo: nil, repeats: true)

        if currentUser["userID"] as! Int == 1 {
            otherUser = ["userID" : 2, "userPicture": "Users/devika"]
        } else {
            otherUser = ["userID" : 1, "userPicture": "Users/harsh"]
        }
        
        currentExerciseTotalExerciseCollectionView.delegate = self
        currentExerciseTotalExerciseCollectionView.dataSource = self
        currentExerciseTotalExerciseCollectionView.register(UINib.init(nibName: "MaxTVCCurrentExerciseCollectionVCell", bundle: nil), forCellWithReuseIdentifier: "MaxTVCCurrentExerciseCollectionVCell")
        
        
        let exerciseCount = CGFloat(currentWorkoutUpdater.totalCurrentExercise)
        let actualScreenWidth = screenWidth - (exerciseCount - 1) * 10
        let cellWidth = actualScreenWidth / exerciseCount
        
        if let flowLayout = currentExerciseTotalExerciseCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.minimumInteritemSpacing = 3.0
            flowLayout.estimatedItemSize = CGSize(width: cellWidth, height: 5)
            currentExerciseTotalExerciseCollectionView.collectionViewLayout = flowLayout
        }

        updateMaxiView(of: userFromSingleLabelGroup, with: currentWorkoutUpdater)
        
        print("User: ", UserDefaults.standard.value(forKey: "user")!)
        
        //apply button
        applyButtonEffect(buttonOutlet: singleUserViewButton, imageName: currentUser["userPicture"] as! String, flag: 1)
        applyButtonEffect(buttonOutlet: otherUserViewButton, imageName: otherUser?["userPicture"] as! String, flag: 1)
        singleUserViewButton.isHidden = true
        otherUserViewButton.isHidden = true
        
        getOtherUsersExercise()
        
        leftUserView.addRightBorder(color: #colorLiteral(red: 0.1450980392, green: 0.1529411765, blue: 0.168627451, alpha: 1), width: 1)
        rightUserView.addLeftBorder(color: #colorLiteral(red: 0.3488702476, green: 0.1221515611, blue: 0.2224545777, alpha: 1), width: 1)
        
        restTimerLabel.text = String(timerCount)

        applyButtonEffect(buttonOutlet: dualUserButton, imageName: "Glyphs/dual", flag: 0)
    }
    
    func updateMaxiView(of labelGroup: [UILabel]!, with workoutData: CurrentWorkoutUpdater) -> Void {
        labelGroup[0].text = workoutData.currentExerciseName
        labelGroup[1].text = String(workoutData.currentSetIndex + 1) + "/" + String(workoutData.totalSet4Exercise)
        labelGroup[2].text! = String(workoutData.currentCount)
        labelGroup[3].text = "/" + String(workoutData.currentRep4Set)
        deviceWeightLabel.text = workoutData.deviceWeight
        deviceWeightLabelDS.text = workoutData.deviceWeight
    }
    
    //MARK: Testing Function
    @objc func updateRandomInt() {
//        print("MAX: ", delegate.message)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishButtonPressed(_ sender: UIButton) {
        smallTrackingVC.autoTracking = false
    }
    
    @IBAction func switchSingleUserViewButtonPressed(_ sender: UIButton) {
//        if whoIsOnTop == 0 {
//            UIView.transition(from: singleUserView, to: singleUserView, duration: 1, options: [.transitionCurlUp, .showHideTransitionViews], completion: nil)
//            whoIsOnTop = 1
//        } else if whoIsOnTop == 1 {
//            UIView.transition(from: singleUserView, to: singleUserView, duration: 1, options: [.transitionCurlDown, .showHideTransitionViews], completion: nil)
//            whoIsOnTop = 0
//        } else {
//            UIView.transition(from: dualUserView, to: singleUserView, duration: 1, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
//            whoIsOnTop = 0
//        }
//        print("\(whoIsOnTop) is on top")
    }
    
    @IBAction func compareUserButtonPressed(_ sender: UIButton) {
        switch whoIsOnTop {
        case 2:
            UIView.transition(from: dualUserView, to: singleUserView, duration: 1, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
            whoIsOnTop = 0
        case 0:
            UIView.transition(from: singleUserView, to: dualUserView, duration: 1, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
            whoIsOnTop = 2
//        case 1:
//            UIView.transition(from: singleUserView, to: dualUserView, duration: 1, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
//            whoIsOnTop = 2
        default:
            print("error")
        }
        print("\(whoIsOnTop) is on top")
    }
    
    @IBAction func react2OtherUser(_ sender: UIButton) {
        print("2 Other User")
        let strURL =  "http://52.14.192.63:3000/reaction/\(otherUser?["userID"] as! Int)"
        let requestURL = URL(string: strURL)
        
        var updateCounterURLRequest = URLRequest(url: requestURL!)
        updateCounterURLRequest.httpMethod = "PUT"
        
        let updateReaction: [String : Any] = [ "action": 1 ]
        
        do {
            let dataInJSON : Data = try JSONSerialization.data(withJSONObject: updateReaction, options: [])
            updateCounterURLRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            updateCounterURLRequest.httpBody = dataInJSON
        } catch {
            print("Error: Can Not Create JSON Data")
        }
        
        let defaultSessionConfiguration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: defaultSessionConfiguration)
        
        let task = session.dataTask(with: updateCounterURLRequest) { (data, urlResponse, error) in }
        task.resume()
    }
    
    @objc func resting() {
        
        if ( timerCount > 0 )
        {
            timerCount -= 1
            restTimerLabel.text = String(timerCount)
//            print("Resting: ", timerCount)
        } else {
            restingTimer.invalidate()
            isResting = false
            timerCount = 5
            restTimerLabel.text = String(timerCount)
        }
    }
}


extension MaxTrackingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentWorkoutUpdater.totalCurrentExercise
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MaxTVCCurrentExerciseCollectionVCell", for: indexPath) as! MaxTVCCurrentExerciseCollectionVCell
        
        if whoIsOnTop == 0 {
            if !currentWorkoutUpdater.workoutFinished {
                if indexPath.row == currentWorkoutUpdater.currentExerciseIndex {
                    cell.backgroundColor = UIColor.white
                } else if indexPath.row > currentWorkoutUpdater.currentExerciseIndex {
                    cell.backgroundColor = #colorLiteral(red: 0.5843137255, green: 0.6117647059, blue: 0.6588235294, alpha: 1)
                } else {
                    cell.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.6980392157, blue: 0.09411764706, alpha: 1)
                }
            } else {
                cell.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.6980392157, blue: 0.09411764706, alpha: 1)
            }
        }
//        else if whoIsOnTop == 1 {
//            if !otherUserExerciseFinished {
//                if indexPath.row == otherUserExerciseIndex {
//                    cell.backgroundColor = UIColor.white
//                } else if indexPath.row > otherUserExerciseIndex {
//                    cell.backgroundColor = #colorLiteral(red: 0.5843137255, green: 0.6117647059, blue: 0.6588235294, alpha: 1)
//                } else {
//                    cell.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.6980392157, blue: 0.09411764706, alpha: 1)
//                }
//            } else {
//                cell.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.6980392157, blue: 0.09411764706, alpha: 1)
//            }
//        }

        return cell
    }
}


extension MaxTrackingViewController {
    
    func applyButtonEffect(buttonOutlet:UIButton,imageName:String,flag:Int){
        let gradient:CAGradientLayer = CAGradientLayer()
        let colorTop = UIColor(red: 250.0/255.0, green: 208.0/255.0, blue: 97.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 246.0/255.0, green: 99.0/255.0, blue: 16.0/255.0, alpha: 1.0).cgColor
        
        gradient.colors = [colorTop, colorBottom]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: buttonOutlet.bounds.width , height: buttonOutlet.bounds.height))
        
        gradient.cornerRadius = buttonOutlet.bounds.width / 2
        
        buttonOutlet.layer.addSublayer(gradient)
        if(flag == 0)
        {
            let imageView:UIImageView = UIImageView(frame: CGRect(origin: CGPoint(x: buttonOutlet.bounds.minX + 15, y: buttonOutlet.bounds.minY + 15), size: CGSize(width: buttonOutlet.bounds.width - 30, height: buttonOutlet.bounds.height - 30)))
            
            imageView.contentMode = .scaleAspectFit
            
            imageView.image = UIImage(named: imageName)
            buttonOutlet.addSubview(imageView)
        }
        else if flag == 1
        {
            
            let imageView:UIImageView = UIImageView(frame: CGRect(origin: CGPoint(x: buttonOutlet.bounds.minX + 7, y: buttonOutlet.bounds.minY + 7), size: CGSize(width: buttonOutlet.bounds.width - 15, height: buttonOutlet.bounds.height - 15)))
            imageView.layer.borderWidth = 1
            imageView.layer.masksToBounds = false
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.cornerRadius = imageView.frame.height/2
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFit
            
            imageView.image = UIImage(named: imageName)
            buttonOutlet.addSubview(imageView)
            
        }
    }
}

//MARK: Update other users data
extension MaxTrackingViewController {
    @objc func getOtherUsersExercise() {
        
        print("finished?: ", otherUserExerciseFinished)
        var todoEndpoint: String!

        todoEndpoint = "http://52.14.192.63:3000/user\(otherUser!["userID"] as! Int)"
        // Set up the URL request
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let jsonData = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                
                print("Other User: " + jsonData.description)
                
                DispatchQueue.main.async {
//                    self.userFromSingleLabelGroup[0].text = jsonData["currentExerciseName"] as? String
//                    self.userFromSingleLabelGroup[1].text = String((jsonData["currentSetIndex"] as? Int)! + 1) + "/" + String(jsonData["totalSet4Exercise"] as! Int)
//                    self.userFromSingleLabelGroup[2].text! = String(jsonData["currentCount"] as! Int)
//                    self.userFromSingleLabelGroup[3].text = "/" + String(jsonData["currentRep4Set"] as! Int)
                    
                    self.otherFromDualLabelGroup[0].text = jsonData["currentExerciseName"] as? String
                    self.otherFromDualLabelGroup[1].text = String((jsonData["currentSetIndex"] as? Int)! + 1) + "/" + String(jsonData["totalSet4Exercise"] as! Int)
                    self.otherFromDualLabelGroup[2].text! = String(jsonData["currentCount"] as! Int)
                    self.otherFromDualLabelGroup[3].text = "/" + String(jsonData["currentRep4Set"] as! Int)
                    self.deviceWeightLabelDSO.text = jsonData["deviceWeight"] as? String
                    
                    self.otherUserExerciseIndex = jsonData["currentExerciseIndex"] as! Int
                    self.otherUserExerciseFinished = jsonData["exerciseFinished"] as! Bool
                    self.currentExerciseTotalExerciseCollectionView.reloadData()
                }
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
}

//
extension MaxTrackingViewController {
    @objc func checkMyReaction() {
        var todoEndpoint: String!
        
        todoEndpoint = "http://52.14.192.63:3000/reaction/\(currentUser["userID"] as! Int)"
        // Set up the URL request
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let jsonData = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                
                print("Other User: " + jsonData.description)
                
                DispatchQueue.main.async {
                    //
                    if jsonData["action"] as! Int == 1 {
                        print("got reaction")
                        UIView.animate(withDuration: 1, animations: {
                            self.reactionUIImageView.isHidden = false
                            self.reactionUIImageView.center.y -= 50
                        }, completion: {
                            (vale: Bool) in
                            self.reactionUIImageView.isHidden = true
                            self.reactionUIImageView.center.y += 50
                        })
                        
                        self.resetReaction(of: self.currentUser["userID"] as! Int)
                    }
                }
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }

    //
    func resetReaction(of userID: Int){
        let strURL =  "http://52.14.192.63:3000/reaction/\(userID)"
        let requestURL = URL(string: strURL)
        
        var updateCounterURLRequest = URLRequest(url: requestURL!)
        updateCounterURLRequest.httpMethod = "PUT"
        
        let updateExerciseData:[String : Any] =
            [
                "action": 0
        ]
        
        do {
            let dataInJSON : Data = try JSONSerialization.data(withJSONObject: updateExerciseData, options: [])
            updateCounterURLRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            updateCounterURLRequest.httpBody = dataInJSON
            
        } catch {
            print("Error: Can Not Create JSON Data")
        }
        
        let defaultSessionConfiguration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: defaultSessionConfiguration)
        
        let task = session.dataTask(with: updateCounterURLRequest) { (data, urlResponse, error) in
            
        }
        task.resume()
    }
}

extension MaxTrackingViewController {
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        
        let ti = NSInteger(interval)
        
        // let ms = Int((interval.truncatingRemainder(dividingBy: 1)) * 1000)
        
        let seconds = (ti % 60) * -1
        let minutes = ((ti / 60) % 60) * -1
        
        return String(format: "%0.2d:%0.2d",minutes,seconds)
    }
    
    
    @objc func updateExTimer() {
        // workOutTimer += 1
        
        if whoIsOnTop == 0
        {
            
            if(heartRate == 147)
            {
                hearRateFlag = 1
            }
            if(heartRate == 75)
            {
                hearRateFlag = 0
            }
            if(hearRateFlag == 1)
            {
                heartRate -= 1
            }
            if(hearRateFlag == 0)
            {
                if(heartRate % 2 != 0)
                {
                    heartRate += 1
                }
                else{
                    heartRate += 3
                }
            }
            
            timerStr = stringFromTimeInterval(interval: startDate.timeIntervalSinceNow)
            timerLabel.text = timerStr
            calorieLabel.text = String(calorieBurned)
            heartRateLabel.text = String(heartRate)
        }
    }
}
