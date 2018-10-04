//
//  scheduleDetailViewController.swift
//  FitfiApp
//
//  Created by Harsh_Dev on 14/08/18.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import Foundation
import UIKit
import CoreData
var day:[String]!
var routineInSchedule:[String]!
var date:Date!
var lastUpdated:Int!
class scheduleDetailViewController:UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var table: UITableView!
    var tempDate:Date = Date()
    @IBOutlet weak var titlee: UINavigationItem!
   
    @IBAction func Done(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        if(lastUpdated == 0){
           routineInSchedule = arrayForSchduleVC
            if(editFlag == 1)
            {
                fromEdit = 1
            }
        }
        else if(lastUpdated == 1)
        {
            date = tempDate
            if(editFlag == 1)
            {
                fromEdit = 2
            }
        }
        else if(lastUpdated == 2)
        {
                day = arrayForSchduleVC
            if(editFlag == 1)
            {
                fromEdit = 3
            }
        }
    }
    @IBAction func Cancel(_ sender: UIBarButtonItem) {
         self.dismiss(animated: true, completion: nil)
    }
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        tempDate = sender.date
        
    }
    @IBOutlet weak var datePicker: UIDatePicker!
    var signal:Int?
    var array:[String] = []
    var routineArr:[Routine] = []
    var arrayForSchduleVC:[String] = []
    var checked:[Int] = []
   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(signal! == 0)
        {
            fetchRoutine()
            arrayForSchduleVC.append("Routine")
            titlee.title = "Select Routine"
            lastUpdated = 0
        }
        else if(signal! == 2)
        {
            setWeekDays()
            arrayForSchduleVC.append("Days")
            titlee.title = "Pick Days"
            lastUpdated = 2
        }
        else if(signal! == 1)
        {
            table.isHidden = true
            datePicker.isHidden = false
            arrayForSchduleVC.append("Date")
            titlee.title = "Select Date"
            arrayForSchduleVC.append("\(Date())")
            lastUpdated = 1
        }
        table.dataSource = self
        table.delegate = self
        table.tableFooterView = UIView()
    
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleTableCell", for: indexPath)
        cell.textLabel?.text = array[indexPath.row]
        
        if(checked[indexPath.row] == 0)
        {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        else
        {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(checked[indexPath.row] == 0){
            checked[indexPath.row] = 1
            arrayForSchduleVC.append(array[indexPath.row])
        }
        else{
            checked[indexPath.row] = 0
            if(arrayForSchduleVC.contains(array[indexPath.row]))
            {
                arrayForSchduleVC.remove(at: arrayForSchduleVC.index(of: array[indexPath.row])!)
            }
        }
        table.reloadData()
        
    }
    func fetchRoutine(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Routine")
        do {
           routineArr = try context.fetch(fetchRequest) as! [Routine]
            
//            print(routineArr.first?.name)

            
        } catch {
            print("Loading Exercises Error: \(error)")
        }
        for i in routineArr{
            array.append(i.name!)
            checked.append(0)
        }
        
    }
    
    override func didMove(toParent parent: UIViewController?) {
        if parent == nil {
            
           performSegue(withIdentifier: "backToTheSchedule", sender: self)
            
        }
    }
    
    func setWeekDays(){
        array = ["SUNDAY","MONDAY","TUESDAY","WEDNESDAY","THURSDAY","FRIDAY","SATURDAY"]
        for i in array
        {
            checked.append(0)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "backToTheSchedule")
        {
            let scheduleVC = segue.destination as! ScheduleViewController
            scheduleVC.scheduleArray = arrayForSchduleVC
            
        }
    }
    

}
