//
//  ScheduleViewController.swift
//  FitfiApp
//
//  Created by Harsh_Dev on 14/08/18.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CoreData
class ScheduleViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var signal = 0
    var scheduleArray:[String]!
    var monday:Bool = false
    var tuesday:Bool = false
    var wednesday:Bool = false
    var thursday:Bool = false
    var friday:Bool = false
    var saturday:Bool = false
    var sunday:Bool = false
    var routineArr:[Routine] = []
    var validationFlag:Int = 0
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var scheduleTable: UITableView!
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtn(_ sender: UIBarButtonItem) {
        //SAMPLE DATA
        //        some(2018-08-25 21:49:22 +0000)
        //        some(["Routine", "HH"])
        //        some(["Days", "MONDAY", "SUNDAY"])
        if(routineInSchedule == nil){
            validationFlag = 1
            
        }
        else if(date == nil)
        {
            validationFlag = 1
        }
        else
        {
            if(routineInSchedule.count < 2)
            {
                validationFlag = 1
            }
            else{
                validationFlag = 0
            }
            
        }
        if(validationFlag == 0)
        {
        
        
 
       saveDataToSchedule()
        
        self.dismiss(animated: true, completion: nil)
        
    }
    }
    // var fileURL = Bundle.main.url(forResource: "Bicep copy", withExtension: "csv")

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
            cell.titleLabel.text = "Routine"
            cell.routinePreviewLabel.text = "Routine"
            if(routineInSchedule != nil)
            {
            if(routineInSchedule.count > 1)
            {
                print(routineInSchedule)
                cell.routinePreviewLabel.text = routineInSchedule[1]
            }
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell
        } else {
            if(indexPath.row == 0)
            {
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectRoutine", for: indexPath) as! selectRoutineCell
            cell.titleLabel.text = "Date"
            cell.routinePreviewLabel.text = "date"
            
            if(date != nil)
            {
                cell.routinePreviewLabel.text = "\(date!)"
            }
            else{
                cell.routinePreviewLabel.text = "\(Date())"
                }
    
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
            }
            else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "selectRoutine", for: indexPath) as! selectRoutineCell
                cell.titleLabel.text = "Day"
                cell.routinePreviewLabel.text = "Day"
                if(day != nil)
                {
                if(day.count > 1)
                {
                    cell.routinePreviewLabel.text = day[1]
                }
                }
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
    override func viewDidAppear(_ animated: Bool) {
        print(scheduleArray)
        scheduleTable.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scheduleTable.dataSource = self
        scheduleTable.delegate = self
        
//        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//
//            fileURL = dir.appendingPathComponent("Bicep.csv")
//        }
//        print(fileURL)
//        Alamofire.upload(
//            multipartFormData: { multipartFormData in
//                multipartFormData.append(self.fileURL!, withName: "uploaded_file")
//
//        },
//            to: "http://192.168.2.25/work/upload.php",
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.responseJSON { response in
//                        debugPrint(response)
//                    }
//                case .failure(let encodingError):
//                    print(encodingError)
//                }
//        }
//        )
    }
    func saveDataToSchedule()
    {
        if(day == nil)
        {
            //nothing
            //not to repeat
        }
        else{
        if(day.contains("MONDAY"))
        {
            monday = true
        }
        else{
            monday = false
        }
        if(day.contains("SUNDAY"))
        {
            sunday = true
        }
        else{
            sunday = false
        }
        if(day.contains("SATURDAY"))
        {
            saturday = true
        }
        else{
            saturday = false
        }
        if(day.contains("FRIDAY"))
        {
            friday = true
        }
        else{
            friday = false
        }
        if(day.contains("THURSDAY"))
        {
            thursday = true
        }
        else{
            thursday = false
        }
        if(day.contains("WEDNESDAY"))
        {
            wednesday = true
        }
        else{
            wednesday = false
        }
        if(day.contains("TUESDAY"))
        {
            tuesday = true
        }
        else{
            tuesday = false
        }
        }
        for i in 1...routineInSchedule.count - 1
        {
            let requestt = NSFetchRequest<NSFetchRequestResult>(entityName: "Routine")
            requestt.predicate = NSPredicate(format: "name = %@", routineInSchedule[i])
            requestt.returnsObjectsAsFaults = false
            do {
                let resultt = try context.fetch(requestt)  as! [Routine]
                routineArr.append(contentsOf: resultt)
                
                
            } catch {
                
                print("Failed")
            }
        }
        var newSet:NSSet? = nil
        // newSet = newSet?.addingObjects(from: routineArr[0]) as? NSSet
        var schedule = Schedule(context: context)
        for i in routineArr{
            schedule.addToSchdule(i)
        }
        schedule.date = date
        schedule.monday = monday
        schedule.tuesday = tuesday
        schedule.wednesday = wednesday
        schedule.thursday = thursday
        schedule.friday = friday
        schedule.saturday = saturday
        schedule.sunday = sunday
        //        let entity = NSEntityDescription.entity(forEntityName: "Schedule", in: context)
        //        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        //        newUser.setValue(date, forKey: "date")
        //        newUser.setValue(monday, forKey: "monday")
        //        newUser.setValue(tuesday, forKey: "tuesday")
        //        newUser.setValue(wednesday, forKey: "wednesday")
        //        newUser.setValue(thursday, forKey: "thursday")
        //        newUser.setValue(friday, forKey: "friday")
        //        newUser.setValue(saturday, forKey: "saturday")
        //        newUser.setValue(sunday, forKey: "sunday")
        //        newUser.setValue(routineArr, forKey: "schdule")
        //
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        
        
        day = []
        routineInSchedule = []
        date = Date()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
