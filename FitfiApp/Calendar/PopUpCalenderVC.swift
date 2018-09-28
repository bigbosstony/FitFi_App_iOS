//
//  PopUpCalenderVC.swift
//  FitfiApp
//
//  Created by Harsh_Dev on 06/09/18.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit
import JTAppleCalendar
import CoreData
class PopUpCalenderVC: UIViewController {
    
    let boarderColor:CGColor = UIColor(red: 61/255, green: 197/255, blue: 202/255, alpha: 1).cgColor
        //UIColor.init(red: 61, green: 197, blue: 202, alpha: 1)
    let formatter = DateFormatter()
    var scheduleArr:[Schedule] = []
    var dateArr:[String] = []
    var eventFlag:Int = 0
    var todayFlag:Int = 0
    var todayDate:Date = Date()
    var selectedDate:Date = Date()
    weak var delegate:fromPopUpVCDelegate?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var calanderView: JTAppleCalendarView!
    
    @IBAction func calenderDisappearBtnPressed(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
    
    @IBOutlet weak var CalenderTitleOutlet: UINavigationItem!
    
    @IBAction func closeBtn(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
      //  performSegue(withIdentifier: "removePopUpCal", sender: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        calanderView.layer.cornerRadius = 6
        calanderView.layer.shadowOffset = CGSize(width: 2, height: 2)
        calanderView.layer.shadowOpacity = 0.5
        calanderView.layer.shadowRadius = 6
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Schedule")
        todayDate = Date()
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request) as! [Schedule]
            
            scheduleArr = result
            for i in scheduleArr
            {
                formatter.dateFormat = "yyyy/MM/dd"
                dateArr.append(formatter.string(from: i.date!))
            }
        } catch {
            
            print("Failed")
        }

//        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
//        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        setupCalanderView()
        // Do any additional setup after loading the view.
    }
    func setupCalanderView()
    {
        calanderView.visibleDates{(visibleDates) in
            self.setupViewsOfCalender(visibleDates: visibleDates)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.view.removeFromSuperview()
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
extension PopUpCalenderVC:JTAppleCalendarViewDelegate,JTAppleCalendarViewDataSource
{
    
    func setupViewsOfCalender(visibleDates: DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date
        self.formatter.dateFormat = "yyyy"
        print(self.formatter.string(from: date))
        self.CalenderTitleOutlet.title = self.formatter.string(from: date)
        self.formatter.dateFormat = "MMMM"
        self.CalenderTitleOutlet.title  = self.formatter.string(from: date) + " " + self.CalenderTitleOutlet.title!
        
    }
    func handleCellTextColor(view: JTAppleCell?,cellState:CellState)
    {
        guard let validCell = view as? CoustomCell else {return}
        if(cellState.isSelected)
        {
            validCell.dateLabel.textColor = UIColor.black
        }
        else{
            if(cellState.dateBelongsTo == .thisMonth)
            {
                validCell.dateLabel.textColor = UIColor.black
                if(todayFlag == 1)
                {
                    todayFlag = 0
                    validCell.dateLabel.textColor = FitFiColor
                    
                    validCell.dateLabel.underline()
                }
                else if(eventFlag == 1)
                {
                    eventFlag = 0
                    validCell.dateLabel.textColor = UIColor.green
                    validCell.selectedView.isHidden = false
                    validCell.selectedView.backgroundColor = UIColor.clear
                    validCell.layer.borderWidth = 1
                    validCell.layer.borderColor = boarderColor
                    
                }
            }
            else{
                validCell.dateLabel.textColor = UIColor.white
            }
            
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalender(visibleDates: visibleDates)    }
    
    func handleCellSelected(view: JTAppleCell?,cellState:CellState)
    {
        guard let validCell = view as? CoustomCell else {return}
        
        if(cellState.isSelected)
        {
           
            validCell.selectedView.isHidden = false
            
        }
        else{
           
            validCell.selectedView.isHidden = true
        }
       
    }
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard cell is CoustomCell else {return}
        
    }
    
    //func setupViewOfCalender()
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let startDate = Calendar.current.date(byAdding: .month, value: -3, to: Date())
        let endDate = Calendar.current.date(byAdding: .month, value: 11, to: Date())
        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!)
        calendar.scrollToDate(Date())
        return parameters
    }
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CoustomCell", for: indexPath) as! CoustomCell
        cell.dateLabel.text = cellState.text
        var comapreDate:String = " "
        var todayDateStr:String = " "
        self.formatter.dateFormat = "yyyy/MM/dd"
        comapreDate = formatter.string(from: date)
        todayDateStr = formatter.string(from: todayDate)
        
        if(comapreDate == todayDateStr)
        {
            todayFlag = 1
        }
        else if(dateArr.contains(comapreDate))
        {
        eventFlag = 1
        }
        
       handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        return cell
    }
   
    
    
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
       handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelected(view: cell, cellState: cellState)
        selectedDate = date
        beginDate = selectedDate.dateFromDays(-3)
        endDate = selectedDate.dateFromDays(15)
        fromPopUp = 1
        delegate?.dateSelected(self)
       
        self.dismiss(animated: true, completion: nil)
       // performSegue(withIdentifier: "removePopUpCal", sender: self)
        
    }
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
       handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelected(view: cell, cellState: cellState)
    }
}

extension UILabel{
    
    func makeOutLine(oulineColor: UIColor, foregroundColor: UIColor){
        let strokeTextAttributes = [
        NSAttributedString.Key.strokeColor : oulineColor,
        NSAttributedString.Key.foregroundColor : foregroundColor,
        NSAttributedString.Key.strokeWidth : -4.0,
        NSAttributedString.Key.font : self.font
        ] as [NSAttributedString.Key : Any]
        self.attributedText = NSMutableAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
    }

    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString); attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}
