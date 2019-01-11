//
//  FreeFormMaxViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2019-01-11.
//  Copyright © 2019 Fitfi. All rights reserved.
//

import UIKit

class FreeFormMaxViewController: UIViewController {

    @IBOutlet weak var deviceLabel: UILabel!
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var countingLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!

    var timer = Timer()
    var seconds = 0
    
    var freeFormUpdater = CurrentFreeFormUpdater() {
        didSet {
            print("freeForm VC")
            print(freeFormUpdater)
            DispatchQueue.main.async {
                self.updateFreeFormView(with: self.freeFormUpdater)
            }
        }
    }
    
    var devicelWeight = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateFreeFormView(with: freeFormUpdater)
        
        deviceLabel.text = devicelWeight
        
        runTimer()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func hideButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func updateFreeFormView(with data: CurrentFreeFormUpdater) -> Void {
        if countingLabel != nil {
            countingLabel.text = String(data.count)
            exerciseLabel.text = data.exercise
        }
    }
}

extension FreeFormMaxViewController {
    func runTimer() -> Void {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds += 1
        timerLabel.text = timeString(time: TimeInterval(seconds))
    }
}
