//
//  scheduleSelectedVC.swift
//  FitfiApp
//
//  Created by Harsh_Dev on 28/08/18.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import Foundation
import UIKit

class scheduleSelectedVC:UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func editBtnPressed(_ sender: UIBarButtonItem) {
        
    }
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    var scheduleArr:[Schedule]?{
       didSet{
            
            print(scheduleArr)
        }
    }
    var day:String?{
        didSet{
            print(day)
        }
    }
    var date:Date?{
        didSet{
           
            print(date)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        if(indexPath.section == 0)
        {
        if((scheduleArr?.count)! > 0)
        {
        let s = scheduleArr![indexPath.row].schdule
        var singleRoutineName = "\(String(describing: s!.value(forKey: "name") ?? ""))"
        
        singleRoutineName =  singleRoutineName.components(separatedBy: .whitespacesAndNewlines).joined()
        singleRoutineName = singleRoutineName.replacingOccurrences(of: "{(", with: "")
        singleRoutineName = singleRoutineName.replacingOccurrences(of: ")}", with: "")
        singleRoutineName = singleRoutineName.components(separatedBy: ",").first!
        
        cell.textLabel?.text = singleRoutineName
        cell.detailTextLabel?.text = "Exercises"
        }
        }
            
        else{
            if((scheduleArr?.count)! > 0)
            {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E, d MMM yyyy"
            cell.textLabel?.text = day! + " " + dateFormatter.string(from: scheduleArr![indexPath.row].date!)
                cell.detailTextLabel?.text = getRepeatString(schedule: scheduleArr![indexPath.row])
            }
        }
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0)
        {
            return (scheduleArr?.count)!
        }
        else{
            return 1
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    func getRepeatString(schedule: Schedule) ->String{
        var string = ""
        if(schedule.sunday == true)
        {
           string = string + " Sunday"
        }
        if(schedule.monday == true)
        {
            string = string + " Monday"
        }
        if(schedule.tuesday == true)
        {
            string = string + " Tuesday"
        }
        if(schedule.wednesday == true)
        {
            string = string + " Wednesday"
        }
        if(schedule.thursday == true)
        {
            string = string + " Thursday"
        }
        if(schedule.friday == true)
        {
            string = string + " Friday"
        }
        if(schedule.saturday == true)
        {
            string = string + " Saturday"
        }
        
    
        
        if(string == "")
        {
            string = "No Repeat"
        }
        else{
            string = "Repeat Every" + string
        }
        
        return string
    }
}
