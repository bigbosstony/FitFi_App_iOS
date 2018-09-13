//
//  CalendarViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-07-10.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit
import CoreData

extension Date {
    func dateFromDays(_ days: Int) -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: .day, value: days, to: self, options: [])!
    }
}

class CalendarViewController: UIViewController {
    var popUpFlag:Int = 0
    let boarderColor:CGColor = UIColor(red: 61/255, green: 197/255, blue: 202/255, alpha: 1).cgColor
    let lightRedColor = UIColor(displayP3Red: 253/255, green: 246/255, blue: 242/255, alpha: 1.0)
    @IBOutlet weak var calenderBtnOutlet: UIBarButtonItem!
    @IBAction func calenderBtnPressed(_ sender: UIBarButtonItem) {
        
//        if(popUpFlag == 0)
//        {
//            let popVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "calenderPopUpID") as! PopUpCalenderVC
//            
//            popVC.view.frame = self.view.frame
//            popVC.view.tag = 100
//        self.addChildViewController(popVC)
//        self.view.addSubview(popVC.view)
//        popVC.didMove(toParentViewController: self)
//        popUpFlag = 1
//        }
//        else{
//            popUpFlag = 0
//            if let viewWithTag = self.view.viewWithTag(100) {
//                viewWithTag.removeFromSuperview()
//            }else{
//                print("No!")
//            }
//        }
        
    }
    @IBAction func addScheduleBtn(_ sender: Any) {
        print("+ tapped")
    }
    @IBOutlet weak var tableView: UITableView!
    var selectedDay:String?
    var mondayRoutine:[String] = []
    var tuesdayRoutine:[String] = []
    var wednesdayRoutine:[String] = []
    var thursdayRoutine:[String] = []
     var fridayRoutine:[String] = []
    var saturdayRoutine:[String] = []
    var sundayRoutine:[String] = []
    var routineArr:[Routine] = []
    let cellHeight: CGFloat = 78
    let dateFormatterCell = DateFormatter()
    let dateFormatterTitle = DateFormatter()
    let dayFormatter = DateFormatter()
    let daysToAdd = 5
    var scheduleArr:[Schedule] = []
    var wholetableScheduleArr:[[Schedule]] = []
    var tableCellScheduleArr:[Schedule] = []
    var routineHistoryArr:[Routine_History] = []
    var tt:[Int] = []
    var selectedDate:Date?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    lazy var days: [Date] = {
        let beginDate = Date().dateFromDays(-3)
        let endDate = Date().dateFromDays(15)
        return self.generateDays(beginDate, endDate: endDate)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let requestSchedule = NSFetchRequest<NSFetchRequestResult>(entityName: "Schedule")
        
        requestSchedule.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(requestSchedule) as! [Schedule]
            
            scheduleArr = result
            
        } catch {
            
            print("Failed")
        }
        let requestRoutineHistory = NSFetchRequest<NSFetchRequestResult>(entityName: "Routine_History")
        requestRoutineHistory.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(requestRoutineHistory) as! [Routine_History]
            
            routineHistoryArr = result
        }
        catch {
            
            print("Failed")
        }
    
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Routine")
        do {
                routineArr = try context.fetch(fetchRequest) as! [Routine]
            
        } catch {
            print("Loading Exercises Error: \(error)")
        }
        
//        for i in routineArr{
//            if(i.scheduledRoutine?.monday == true)
//            {
//                mondayRoutine.append(i.name!)
//            }
//            if(i.scheduledRoutine?.tuesday == true)
//            {
//                tuesdayRoutine.append(i.name!)
//            }
//            if(i.scheduledRoutine?.wednesday == true)
//            {
//                wednesdayRoutine.append(i.name!)
//            }
//            if(i.scheduledRoutine?.thursday == true)
//            {
//                thursdayRoutine.append(i.name!)
//            }
//            if(i.scheduledRoutine?.friday == true)
//            {
//                fridayRoutine.append(i.name!)
//            }
//            if(i.scheduledRoutine?.saturday == true)
//            {
//                saturdayRoutine.append(i.name!)
//            }
//            if(i.scheduledRoutine?.sunday == true)
//            {
//                sundayRoutine.append(i.name!)
//            }
//        }
        print("File Path of SQLite and .plist: " ,FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        dateFormatterCell.dateFormat = "E dd"
        dateFormatterTitle.dateFormat = "MMMM yyyy"
        self.title = dateFormatterTitle.string(from: days.first!)
       
        
       // let newSchedule = Schedule(context: context)
        
   //     newSchedule.dayOfWeek = "WEDNESDAY"
//        save()
//        newSchedule.dayOfWeek = "THURSDAY"
//        save()
//    newSchedule.dayOfWeek = "FRIDAY"
//        save()
//        newSchedule.dayOfWeek = "SATURDAY"
    //    save()
    
        //   >>>>>>>>>>>to map<<<<<<<<<<<<<<
//        var routineArr:[Routine] = []
//        var dayArr:[Schedule] = []
//       let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Schedule")
//       let dayPredicate = NSPredicate(format: "dayOfWeek == 'MONDAY'")
//        fetchRequest.predicate = dayPredicate
//        do {
//             dayArr = try context.fetch(fetchRequest) as! [Schedule]
//
//        } catch {
//            print("Loading Exercises Error: \(error)")
//        }
//        let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: "Routine")
//        let routinePredicate = NSPredicate(format: "name == 'HA'")
//        fetchRequest1.predicate = routinePredicate
//        do {
//             routineArr = try context.fetch(fetchRequest1) as! [Routine]
//
//        } catch {
//            print("Loading Exercises Error: \(error)")
//        }
//        routineArr.first?.schduledRoutine = dayArr[0]
//        save()
       
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Schedule")
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request) as! [Schedule]
            
            scheduleArr = result
            
        } catch {
            
            print("Failed")
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Routine")
        do {
            routineArr = try context.fetch(fetchRequest) as! [Routine]
            
        } catch {
            print("Loading Exercises Error: \(error)")
        }
        
    }
    
    func generateDays(_ beginDate: Date, endDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = beginDate
        
        while date.compare(endDate) != .orderedDescending {
            dates.append(date)
            date = date.dateFromDays(1)
        }
        return dates
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CalendarViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(self.days.count)
        return self.days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calendarCell", for: indexPath) as! CalendarTableViewCell
        let dateArray : [String] = dateFormatterCell.string(from: days[(indexPath as NSIndexPath).row]).components(separatedBy: " ")
        let dateFormatter = DateFormatter()
        cell.dayOfWeek.text = dateArray.first?.uppercased()
        cell.dayOfMonth.text = dateArray.last?.uppercased()
        switch dateArray[0] {
            case "Mon":
                if(mondayRoutine.count != 0)
                {
                cell.routineName.text = mondayRoutine[0]
                }
            break
            case "Tue":
                if(tuesdayRoutine.count != 0){
                cell.routineName.text = tuesdayRoutine[0]
                }
            break
            case "Wed":
                if(wednesdayRoutine.count != 0)
                {
                cell.routineName.text = wednesdayRoutine[0]
                }
            break
            case "Thu":
                if(thursdayRoutine.count != 0)
                {
                cell.routineName.text = thursdayRoutine[0]
                }
            break
            case "Fri":
                if(fridayRoutine.count != 0)
                {
                cell.routineName.text = fridayRoutine[0]
                }
            break
            case "Sat":
                if(saturdayRoutine.count != 0)
                {
                cell.routineName.text = saturdayRoutine[0]
                }
            break
            case "Sun":
                if(sundayRoutine.count != 0)
                {
                cell.routineName.text = sundayRoutine[0]
                }
            break
        default:
            print("err")
            
        }
        if( dateArray.last == "thu")
        {
            print("Thursday come")
        }
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let today = Date()
        
        if dateFormatter.string(from: today) == dateFormatter.string(from: days[(indexPath as NSIndexPath).row]) {
            
            cell.dayOfMonth.textColor = UIColor.white
            cell.dayOfWeek.textColor = UIColor.white
            cell.todayMarker.isHidden = false
            
            cell.routineName.text = " "
            cell.timeImageView.isHidden = true
            cell.exerciseImageView.isHidden = true
        }
        else{
            cell.dayOfMonth.textColor = UIColor.black
            cell.dayOfWeek.textColor = UIColor.black
            cell.todayMarker.isHidden = true
            cell.routineName.text = " "
            cell.timeImageView.isHidden = true
            cell.exerciseImageView.isHidden = true
        }
        var scheduleHistoryFlag:Int = 0
        
        for i in routineHistoryArr{
            if (dateFormatter.string(from: days[indexPath.row]) == dateFormatter.string(from: i.start!))
            {
            print(i.end!)
                print((i.exerciseHistory![0] as! Exercise_History).name!)
            print(i.totalCalorie)
                print(i.totalWeight)
               cell.detailView.backgroundColor = lightRedColor
                cell.exerciseImageView.isHidden = true
                cell.timeImageView.isHidden = true
                cell.detailView.isHidden = false
                cell.dumbellImage.isHidden = true
                cell.routineName.text = i.name!
                cell.estimatedTime.text = String(i.totalCalorie) + " kcal"
                cell.totalExercise.text = String(i.totalWeight) + " lb"
                let formatter =  DateFormatter()
                formatter.dateFormat = "h:mm a"
                
                cell.startedTime.text = formatter.string(from: i.end!)
                scheduleHistoryFlag = 1
                return cell
            }
        }
        if(scheduleHistoryFlag == 0)
        {
        for i in scheduleArr
        {
//            if let s = i.schdule {
//                print(s.value(forKey: "name"))
//            }
            if (days[indexPath.row] > i.date! || dateFormatter.string(from: days[indexPath.row]) == dateFormatter.string(from: i.date!))
            {
                
                if(cell.dayOfWeek.text == "MON" && i.monday == true)
                {
                    tableCellScheduleArr.append(i)
                    //cell.routineName.text = i.schedule
                }
                else if(cell.dayOfWeek.text == "TUE" && i.tuesday == true)
                {
                    tableCellScheduleArr.append(i)
                }
                else if(cell.dayOfWeek.text == "WED" && i.wednesday == true)
                {
                    tableCellScheduleArr.append(i)
                }
                else if(cell.dayOfWeek.text == "FRI" && i.friday == true)
                {
                    tableCellScheduleArr.append(i)
                }
                else if(cell.dayOfWeek.text == "THU" && i.thursday == true)
                {
                    tableCellScheduleArr.append(i)
                }
                else if(cell.dayOfWeek.text == "SAT" && i.saturday == true)
                {
                    tableCellScheduleArr.append(i)
                }
                else if(cell.dayOfWeek.text == "SUN" && i.sunday == true)
                {
                    tableCellScheduleArr.append(i)
                }
                
                wholetableScheduleArr.append(tableCellScheduleArr)
                if(tableCellScheduleArr == [])
                {
                    
                }
                else{
                    let s = tableCellScheduleArr[0].schdule
                    var singleRoutineName = "\(String(describing: s!.value(forKey: "name") ?? ""))"

                    singleRoutineName =  singleRoutineName.components(separatedBy: .whitespacesAndNewlines).joined()
                    singleRoutineName = singleRoutineName.replacingOccurrences(of: "{(", with: "")
                    singleRoutineName = singleRoutineName.replacingOccurrences(of: ")}", with: "")
                    singleRoutineName = singleRoutineName.components(separatedBy: ",").first!
                    cell.routineName.text = singleRoutineName
                    cell.timeImageView.isHidden = false
                    cell.exerciseImageView.isHidden = false
                    cell.totalExercise.text = "\(getNumberOfExercise(scheduleName:tableCellScheduleArr))"
                    cell.detailView.layer.borderWidth = 1.5
                    cell.detailView.layer.cornerRadius = 6
                    cell.dumbellImage.isHidden = false
                    cell.detailView.layer.borderColor = boarderColor
                    cell.detailView.backgroundColor = UIColor.clear
                    cell.startedTime.text = ""
                    
                }
                tableCellScheduleArr = []
                
            }
            else{
                wholetableScheduleArr.append(tableCellScheduleArr)
            }
        }
        
        
        // Configure the cell...
        
        return cell
        }
    }
    
}

extension CalendarViewController: UITableViewDelegate {
    func getNumberOfExercise(scheduleName:[Schedule]) -> Int{
        var totalExercise:Int = 0
        var exerciseList:[String] = []
        for i in scheduleName{
            let s = i.schdule
            let e = s!.value(forKey: "routineExercises")
            var singleExerciseName = "\(String(describing: (e as AnyObject).value(forKey: "name") ?? ""))"
            singleExerciseName = singleExerciseName.components(separatedBy: .whitespacesAndNewlines).joined()
            singleExerciseName = singleExerciseName.replacingOccurrences(of: "{(", with: "")
            singleExerciseName = singleExerciseName.replacingOccurrences(of: ")}", with: "")
            singleExerciseName = singleExerciseName.components(separatedBy: ",").first!
            for i in singleExerciseName.components(separatedBy: ","){
                
                exerciseList.append(i)
            }
            
        }
        totalExercise = exerciseList.count
        return totalExercise
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeight;
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // TODO: Add infinite scrolling functionality
        let top: CGFloat = 0
        let bottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        let scrollPosition = scrollView.contentOffset.y
        
        print("Content Size: ", scrollView.contentSize.height, "Frame Size: ", scrollView.frame.size.height)
        print("Scroll Position, Y: ", scrollPosition)
        print("Bottom: ", bottom)
        // Set Title on Nav Bar
        let topVisibleIndexPath:IndexPath = self.tableView.indexPathsForVisibleRows![0]
        print("Top Cell: ", topVisibleIndexPath)
        self.title = dateFormatterTitle.string(from: days[topVisibleIndexPath.row])
        //
        
        // Reached the bottom of the list
        if scrollPosition > bottom {    //- buffer {
            print("scrollPosition > bottom")
            // Add more dates to the bottom
            let lastDate = self.days.last!
            let additionalDays = self.generateDays(
                lastDate.dateFromDays(1),
                endDate: lastDate.dateFromDays(self.daysToAdd)
            )
            self.days.append(contentsOf: additionalDays)
            
            // Update the tableView
            tableCellScheduleArr = []
            wholetableScheduleArr = []
            self.tableView.reloadData()
            //            self.tableView.contentOffset.y -= CGFloat(self.daysToAdd) * self.cellHeight
            print("Days: ", days)
        }
            
        else if scrollPosition < top { // + buffer {
            // Add more dates to the top
            let firstDate = self.days.first!
            let additionalDates = self.generateDays(
                firstDate.dateFromDays(-self.daysToAdd),
                endDate: firstDate.dateFromDays(-1)
            )
            self.days.insert(contentsOf: additionalDates, at: 0)
            
            // Update the tableView and contentOffset
            tableCellScheduleArr = []
            wholetableScheduleArr = []
            self.tableView.reloadData()
            self.tableView.contentOffset.y = CGFloat(self.daysToAdd) * self.cellHeight
            print("Reset Y:", self.tableView.contentOffset.y)
            print("Days: ", days)
        }
    }
    
    //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  tableView.deselectRow(at: indexPath, animated: true)
        var flag:Int = 0
        for i in scheduleArr
        {
            //            if let s = i.schdule {
            //                print(s.value(forKey: "name"))
            //            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let dateArray : [String] = dateFormatterCell.string(from: days[(indexPath as NSIndexPath).row]).components(separatedBy: " ")
            let day = dateArray.first?.uppercased()
            if (days[indexPath.row] > i.date! || dateFormatter.string(from: days[indexPath.row]) == dateFormatter.string(from: i.date!))
            {
                
                if(day == "MON" && i.monday == true)
                {
                    tableCellScheduleArr.append(i)
                    flag = 1
                    //cell.routineName.text = i.schedule
                }
                else if(day == "TUE" && i.tuesday == true)
                {
                    tableCellScheduleArr.append(i)
                    flag = 1
                }
                else if(day == "WED" && i.wednesday == true)
                {
                    tableCellScheduleArr.append(i)
                    flag = 1
                }
                else if(day == "FRI" && i.friday == true)
                {
                    tableCellScheduleArr.append(i)
                    flag = 1
                }
                else if(day == "THU" && i.thursday == true)
                {
                    tableCellScheduleArr.append(i)
                    flag = 1
                }
                else if(day == "SAT" && i.saturday == true)
                {
                    tableCellScheduleArr.append(i)
                    flag = 1
                }
                else if(day == "SUN" && i.sunday == true)
                {
                    tableCellScheduleArr.append(i)
                    flag = 1
                }
                
                //selectedRowScheduleArr.append(tableCellScheduleArr)
                if(tableCellScheduleArr == [])
                {
                 //inside here
                    
                    
                }
                    
                else{
//                    let s = tableCellScheduleArr[0].schdule
//                    var singleRoutineName = "\(String(describing: s!.value(forKey: "name") ?? ""))"
//
//                    singleRoutineName =  singleRoutineName.components(separatedBy: .whitespacesAndNewlines).joined()
//                    singleRoutineName = singleRoutineName.replacingOccurrences(of: "{(", with: "")
//                    singleRoutineName = singleRoutineName.replacingOccurrences(of: ")}", with: "")
//                    singleRoutineName = singleRoutineName.components(separatedBy: ",").first!
//                    cell.routineName.text = singleRoutineName
                   flag = 1
                    
                }
               // tableCellScheduleArr = []
                
            }
            else{
              //  wholetableScheduleArr.append(tableCellScheduleArr)
            }
        }
        if(flag == 1)
        {
        print(tableCellScheduleArr)
          selectedDate = days[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateArray : [String] = dateFormatterCell.string(from: days[(indexPath as NSIndexPath).row]).components(separatedBy: " ")
        selectedDay = dateArray.first?.uppercased()
        performSegue(withIdentifier: "goToScheduleDetail", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableCellScheduleArr = []
        
        print(indexPath.row)
       
      //  print(wholetableScheduleArr[indexPath.row])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToScheduleDetail")
        {
            let scheduleVC = segue.destination as! scheduleSelectedVC
            
            scheduleVC.day = selectedDay
            scheduleVC.scheduleArr = tableCellScheduleArr
            scheduleVC.date = selectedDate
            
        }
        if(segue.identifier == "popUpCalender")
        {
            //assign date
            
        }
        
    }
}
extension CalendarViewController{
func save() {
    do {
        try context.save()
    } catch {
        print("\(error)")
    }
}
}
