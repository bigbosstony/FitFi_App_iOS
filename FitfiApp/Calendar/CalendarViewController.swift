//
//  CalendarViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-07-10.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit

extension Date {
    func dateFromDays(_ days: Int) -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: .day, value: days, to: self, options: [])!
    }
}

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellHeight: CGFloat = 78
    let dateFormatterCell = DateFormatter()
    let dateFormatterTitle = DateFormatter()
    let daysToAdd = 5
    
    lazy var days: [Date] = {
        let beginDate = Date().dateFromDays(-3)
        let endDate = Date().dateFromDays(15)
        return self.generateDays(beginDate, endDate: endDate)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        dateFormatterCell.dateFormat = "E dd"
        dateFormatterTitle.dateFormat = "MMMM yyyy"
        self.title = dateFormatterTitle.string(from: days.first!)
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
        return self.days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calendarCell", for: indexPath) as! CalendarTableViewCell
        let dateArray : [String] = dateFormatterCell.string(from: days[(indexPath as NSIndexPath).row]).components(separatedBy: " ")
        let dateFormatter = DateFormatter()
        cell.dayOfWeek.text = dateArray.first?.uppercased()
        cell.dayOfMonth.text = dateArray.last?.uppercased()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let today = Date()
//        if dateFormatter.string(from: today) == dateFormatter.string(from: days[(indexPath as NSIndexPath).row]) {
//            print("++++++++++TODAY++++++++++")
//            cell.dayOfMonth.textColor = UIColor.white
//            cell.dayOfWeek.textColor = UIColor.white
//            cell.todayMarker.isHidden = false
//        }

        // Configure the cell...
        
        return cell
    }
}

extension CalendarViewController: UITableViewDelegate {
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
            self.tableView.reloadData()
            self.tableView.contentOffset.y = CGFloat(self.daysToAdd) * self.cellHeight
            print("Reset Y:", self.tableView.contentOffset.y)
            print("Days: ", days)
        }
    }
    
    //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
