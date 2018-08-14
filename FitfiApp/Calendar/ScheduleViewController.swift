//
//  ScheduleViewController.swift
//  FitfiApp
//
//  Created by Harsh_Dev on 14/08/18.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import Foundation
import UIKit
class ScheduleViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var signal = 0
    @IBOutlet weak var scheduleTable: UITableView!
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0)
        {
        return 1
        }
        else{
            return 2
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 && indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectRoutine", for: indexPath) as! selectRoutineCell
            cell.routinePreviewLabel.text = "Routine"
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell
        } else {
            if(indexPath.row == 0)
            {
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectRoutine", for: indexPath) as! selectRoutineCell
            cell.routinePreviewLabel.text = "date"
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "selectRoutine", for: indexPath) as! selectRoutineCell
                cell.routinePreviewLabel.text = "Day"
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0 && indexPath.section == 0){
            signal = 0
        performSegue(withIdentifier: "gotoDetailScheduleVC", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        else if(indexPath.row == 0 && indexPath.section == 1)
        {
             signal = 1
             performSegue(withIdentifier: "gotoDetailScheduleVC", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        }
        else if(indexPath.row == 1 && indexPath.section == 1)
        {
             signal = 2
             performSegue(withIdentifier: "gotoDetailScheduleVC", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoDetailScheduleVC" {
            let destinationVC = segue.destination as! scheduleDetailViewController
            destinationVC.signal = signal
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleTable.dataSource = self
        scheduleTable.delegate = self
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
