//
//  TestViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-07-17.
//  Copyright © 2018 Fitfi. All rights reserved.
//
//Harsh Made changes
//Harsh agian did something
import UIKit

import CoreData
import Charts

//MARK: for collapse table view
struct Seection {
    var category: String
    var exercise: [String]
    var collapsed: Bool
    
    init(category: String, exercise: [String], collapsed: Bool = false) {
        self.category = category
        self.exercise = exercise
        self.collapsed = collapsed
    }
}

let FitFiColor = UIColor(red: 213, green: 95, blue: 31)


private let dateFormatter: DateFormatter = {
    let timeFormatter = DateFormatter()
    timeFormatter.dateStyle = .none
    timeFormatter.timeStyle = .short
    
    return timeFormatter
}()

private let oneMonth:DateFormatter = {
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "MM/dd"
    return timeFormatter
}()

private let threeMonthformatter:DateFormatter = {
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "MMM"
    return timeFormatter
}()
private let localDateFormatterr: DateFormatter = {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    dateFormatter.locale = Locale(identifier: "en_US")
    
    return dateFormatter
}()

private let localDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    return dateFormatter
}()

private let decimalFormatter: NumberFormatter = {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.minimumFractionDigits = 2
    numberFormatter.maximumFractionDigits = 2
    
    return numberFormatter
}()







class StatisticsViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource ,ChartViewDelegate{
    var exerciseList:[String] = ["h ","j "]
    var exerciseObject:Exercise? = nil
    public var sectionData:[Seection] = [
        Seection(category: "Arm", exercise: ["man","it shouls in"]), Seection(category: "Leg", exercise: ["man","it shouls in"])]
   
   var totalVolume:Double = 0
    var totalVolumeLb:Double = 0
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var exerciseHistoryArray = [Exercise_History]()
    var routineHistoryArray = [Routine_History]()

     func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionData[section].collapsed ? 0 : sectionData[section].exercise.count
    }
    // Cell
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CollapsibleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CollapsibleTableViewCell ??
            CollapsibleTableViewCell(style: .default, reuseIdentifier: "cell")
        
        let item: String = sectionData[indexPath.section].exercise[indexPath.row]
        
        cell.nameLabel.text = item
        
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // Header
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = sectionData[section].category
        header.arrowLabel.text = ">"
        header.setCollapsed(sectionData[section].collapsed)
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getExerciseObject(e_name: sectionData[indexPath.section].exercise[indexPath.row])
        performSegue(withIdentifier: "showExerciseDetailVC", sender: self)
        
        exerciseTable.deselectRow(at: indexPath, animated: true)
    }
    //MARK: for workOut bar chart
   
    fileprivate lazy private(set) var axisLineColor = UIColor.clear
 
    //MARK: ImageViews for Muscle Engagement
    @IBOutlet weak var F1: UIImageView!
    
    @IBOutlet weak var F2: UIImageView!
    
    @IBOutlet weak var F3: UIImageView!
    
    @IBOutlet weak var F4: UIImageView!
    
    @IBOutlet weak var F5: UIImageView!
    
    @IBOutlet weak var F6: UIImageView!
    @IBOutlet weak var F7: UIImageView!
    
    @IBOutlet weak var F8: UIImageView!
    
    
    @IBOutlet weak var F9: UIImageView!
    
    @IBOutlet weak var F10: UIImageView!
    
    @IBOutlet weak var F11: UIImageView!
    
    @IBOutlet weak var F12: UIImageView!
    @IBOutlet weak var F13: UIImageView!
    @IBOutlet weak var F14: UIImageView!
    @IBOutlet weak var F15: UIImageView!
    
    
    @IBOutlet weak var R1: UIImageView!
    
    @IBOutlet weak var R2: UIImageView!
    
    @IBOutlet weak var R3: UIImageView!
    
    @IBOutlet weak var R4: UIImageView!
    
    @IBOutlet weak var R5: UIImageView!
    @IBOutlet weak var R6: UIImageView!
    @IBOutlet weak var R7: UIImageView!
    
    @IBOutlet weak var R8: UIImageView!
    @IBOutlet weak var R9: UIImageView!
    @IBOutlet weak var R10: UIImageView!
    
    @IBOutlet weak var R11: UIImageView!
    
    
    @IBOutlet weak var R12: UIImageView!
    
  
    
    //MARK: 1 month / 3 month / 1 year selected segment
    
    @IBAction func timeSegments(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("q month")
            workOutLabel.text = "01"
            volumeLabel.text = "01"
            exerciseLabel.text = "05"
            timeSelected(index: 0) // function that will be called to calculate and display graphs
            break
        case 1:
            print("3 months")
            workOutLabel.text = "03"
            volumeLabel.text = "02"
            exerciseLabel.text = "06"
            timeSelected(index: 1) // function that will be called to calculate and display graphs
            break
        case 2:
            print("1 year")
            workOutLabel.text = "04"
            volumeLabel.text = "03"
            exerciseLabel.text = "07"
            timeSelected(index: 2) // function that will be called to calculate and display graphs
            break
        default:
            break
        }
    }
    
    @IBOutlet weak var timeSegmentOutlet: UISegmentedControl!
    
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var volumeGraphView: LineChartView!
    
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var workOutLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    
    
    
    
    @IBOutlet weak var exerciseTable: UITableView!
    var exHistoryDict:[String] = []
    var exVolume:Int = 0
    var exVolumeLb:Int = 0
    var exReps:[Int] = []
    var exSets:[Int] = []
    var exWeight:[Int] = []
    var exWorkOuts:Int = 0
     var metricFlag:Int = 0// to get ton know if weight is low than it will be 0 to print lb instead of tone
    override func viewDidLoad() {
        super.viewDidLoad()
        barChartView.delegate = self
        barChartView.noDataText = "No data Available"
        volumeGraphView.delegate = self
        volumeGraphView.noDataText = "No data Available"
       //Just for testing purpose
       F1.image = (F1.image?.withRenderingMode(.alwaysTemplate))!
        F1.tintColor = FitFiColor
        F2.image = (F2.image?.withRenderingMode(.alwaysTemplate))!
        F2.tintColor = FitFiColor
        F12.image = (F12.image?.withRenderingMode(.alwaysTemplate))!
        F12.tintColor = FitFiColor
        R1.image = (R1.image?.withRenderingMode(.alwaysTemplate))!
        R1.tintColor = FitFiColor
        
        R12.image = (R12.image?.withRenderingMode(.alwaysTemplate))!
        R12.tintColor = FitFiColor
        //oneMonthSelected()
        //        for i in exerciseHistoryArray{
        //            if(exHistoryDict.contains(i.name!)){
        //                //do nothing
        //            }
        //            else{
        //                exHistoryDict.append(i.name!)
        //            }
        //            //print(i.parentRoutineHistory!.name!)
        //
        //            if(exWorkOuts.contains(context.object(with: (i.parentRoutineHistory!.objectID))))
        //                {
        //                    //do nothing
        //            }
        //                else{
        //                exWorkOuts.append(context.object(with: (i.parentRoutineHistory!.objectID)))
        //
        //            }
        //            exVolume = exVolume + Int(i.reps * i.sets * i.weight)
        //
        //
        //        }
        
        
        //print(exHistoryDict.count) number of exercise
        //print(exVolume) Volume
        //print(exWorkOuts.count) total routines
        timeSelected(index: 0)
        
       
        exerciseTable.delegate = self
        exerciseTable.dataSource = self
        exerciseTable.estimatedRowHeight = 44.0
        exerciseTable.rowHeight = UITableView.automaticDimension

      
//        volumeGraphView.addGestureRecognizer(chartLongPressGestureRecognizer)
       
       

        
        
      
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: part of volume graph
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension StatisticsViewController{
    
    func timeSelected(index: Int)
    {
       
        exerciseList = []
        sectionData = []
        
        switch index {
        case 0:
            totalVolumeLb = 0
            totalVolume = 0
            var nextCurrentDate = Date()
            var currentDateString = " "
            var previousDateString = " "
            let n:Double = 110
            var currrentDate = Date()
            var previousDate = Date()
            let stringFormatter = ChartStringFormatter()
            var barChartDataEntries: [BarChartDataEntry] = []
            var lineChartDataEntries: [ChartDataEntry] = []
            var BarsArray = [("JUN",n),("JUN",n),("JUN",n),("JUN",n)]
            var GraphArray = [("JUN",n),("JUN",n),("JUN",n),("JUN",n)]
            var Graph1Array = [("JUN",n),("JUN",n),("JUN",n),("JUN",n)]
            var maxWorkOut:Double = 0
            var totalExercise:Double = 0
            var totalWorkOut:Double = 0
            var barValues: [Double] = [n,n,n,n]
            var barLabels: [String] = ["JUN","JUN","JUN","JUN"]
            var lineValues: [Double] = [n,n,n,n]
            var lineValuesLb: [Double] = [n,n,n,n]
            var lineLabels: [String] = ["JUN","JUN","JUN","JUN"]
            for i in 0...3{
                let tt:TimeInterval = -630000
                let oneDay:TimeInterval = -90000
                
                currrentDate = Date()
                if(i != 4){
                    currrentDate = nextCurrentDate
                }
                previousDate = currrentDate.addingTimeInterval(tt)
                let oneMonthformatter = DateFormatter()
                oneMonthformatter.dateFormat = "MM/dd"
                let tmp = fetchDataFromDB(startDate: currrentDate, endDate: previousDate, currrentStartDate: currrentDate, currentEndDate: previousDate)
                currentDateString = oneMonthformatter.string(from: currrentDate)
                previousDateString = oneMonthformatter.string(from: previousDate)
                nextCurrentDate = previousDate.addingTimeInterval(oneDay)
               // BarsArray[i] = ("\(previousDateString)-\(currentDateString)",tmp[0])
                
                BarsArray[i] = ("Week \(4 - (i))",tmp[2])
                GraphArray[i] = ("\(previousDate)",tmp[1])
                barValues[i] = tmp[2]
                barLabels[i] = "Week \(4 - (i))"
                Graph1Array[i] = ("\(previousDate)",tmp[1])
                lineValues[i] = tmp[1]
                lineValuesLb[i] = tmp[3]
                lineLabels[i] = "Week \(4 - (i))"
                totalExercise = totalExercise + tmp[0]
                totalVolume = totalVolume + tmp[1]
                totalVolumeLb = totalVolumeLb + tmp[3]
                totalWorkOut = totalWorkOut + tmp[2]
                if(tmp[2] >  maxWorkOut)
                {
                    maxWorkOut = tmp[2]
                }
                
            }
            
            //exHistoryDict.count number of exercise
            exerciseLabel.text = "\(Int(totalExercise))"
         
            if(metricFlag == 0)
            {
                
                volumeLabel.text = "\(totalVolumeLb) lb"
                
            }
            else if(metricFlag == 1){
                
                volumeLabel.text = "\(totalVolume) t"
                
            }

            
            workOutLabel.text = "\(Int(totalWorkOut))"
             if(totalExercise > 0){
                barChartView.translatesAutoresizingMaskIntoConstraints = false
                barChartView.centerYAnchor.constraint(
                    equalTo: barChartView.centerYAnchor).isActive = true
                barChartView.leftAnchor.constraint(
                    equalTo: barChartView.leftAnchor, constant: 10).isActive = true
                barChartView.rightAnchor.constraint(
                    equalTo: barChartView.rightAnchor, constant: -10).isActive = true
                barChartView.heightAnchor.constraint(
                    equalToConstant: 300.0).isActive = true
                // formatting the bar chart
                stringFormatter.nameValues = barLabels
                barChartView.xAxis.valueFormatter = stringFormatter
                barChartView.xAxis.setLabelCount(stringFormatter.nameValues.count, force: false)
                
                barChartView.xAxis.drawGridLinesEnabled = false
                barChartView.xAxis.drawAxisLineEnabled = false
                barChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
                
                barChartView.rightAxis.enabled = false
                barChartView.leftAxis.enabled = true
                
                barChartView.animate(xAxisDuration: 0.0, yAxisDuration: 0.6)
                barChartView.legend.enabled = false
                barChartView.chartDescription?.enabled = false
                barChartView.drawValueAboveBarEnabled = false
                
                
                // create the datapoints
                for (index, dataPoint) in barValues.enumerated() {
                    let dataEntry = BarChartDataEntry(x: Double(index),
                                                      y: dataPoint)
                    barChartDataEntries.append(dataEntry)
                }
                
                // create the chartDataSet
                let chartDataSet = BarChartDataSet(values: barChartDataEntries,
                                                   label: "")
                chartDataSet.colors = [FitFiColor]
                chartDataSet.valueTextColor = UIColor.white
                let chartData = BarChartData(dataSet: chartDataSet)
                self.barChartView.data = chartData
                
                
               
                print(GraphArray)
                volumeGraphView.translatesAutoresizingMaskIntoConstraints = false
                volumeGraphView.centerYAnchor.constraint(
                    equalTo: volumeGraphView.centerYAnchor).isActive = true
                volumeGraphView.leftAnchor.constraint(
                    equalTo: volumeGraphView.leftAnchor, constant: 10).isActive = true
                volumeGraphView.rightAnchor.constraint(
                    equalTo: volumeGraphView.rightAnchor, constant: 0).isActive = true
                volumeGraphView.heightAnchor.constraint(
                    equalToConstant: 300.0).isActive = true
                // formatting the bar chart
                stringFormatter.nameValues = lineLabels
                volumeGraphView.xAxis.valueFormatter = stringFormatter
                volumeGraphView.xAxis.setLabelCount(stringFormatter.nameValues.count, force: false)
                volumeGraphView.xAxis.axisMinimum = 0.0
                
                volumeGraphView.xAxis.drawGridLinesEnabled = false
                volumeGraphView.xAxis.drawAxisLineEnabled = false
                volumeGraphView.xAxis.labelPosition = XAxis.LabelPosition.bottom
                volumeGraphView.rightAxis.axisMinimum = 0.0
                volumeGraphView.leftAxis.axisMinimum = 0.0
                volumeGraphView.rightAxis.enabled = false
                volumeGraphView.leftAxis.enabled = true
                
                volumeGraphView.animate(xAxisDuration: 0.0, yAxisDuration: 0.6)
                volumeGraphView.legend.enabled = false
                volumeGraphView.chartDescription?.enabled = false
                
                // create the datapoints
                if(metricFlag == 0)
                {
                    for (index, dataPoint) in lineValuesLb.enumerated() {
                        let dataEntry = ChartDataEntry(x: Double(index),
                                                       y: dataPoint)
                        lineChartDataEntries.append(dataEntry)
                    }
                }
                else{
                for (index, dataPoint) in lineValues.enumerated() {
                    let dataEntry = ChartDataEntry(x: Double(index),
                                                      y: dataPoint)
                    lineChartDataEntries.append(dataEntry)
                }
                }
                // create the chartDataSet
                let lineDataSet = LineChartDataSet(values: lineChartDataEntries,
                                                   label: "")
                lineDataSet.colors = [FitFiColor]
                // Setting fill gradient color
                let coloTop = UIColor(red: 213/255, green: 95/255, blue: 31/255, alpha: 0.8).cgColor
                let colorBottom = UIColor(red: 230/255, green: 155/255, blue: 210/255, alpha: 0.1).cgColor
                // Colors of the gradient
                let gradientColors = [coloTop, colorBottom] as CFArray
                // Positioning of the gradient
                let colorLocations: [CGFloat] = [0.7, 0.0]
                // Gradient Object
                let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)!
                lineDataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
                lineDataSet.drawFilledEnabled = true
                lineDataSet.valueTextColor = UIColor.white
                let lineData = LineChartData(dataSet: lineDataSet)
                self.volumeGraphView.data = lineData
                
                
                

                exerciseTable.reloadData()
            }
            else{
                print("No data")
            }
            break
        case 1:
            totalVolumeLb = 0
            totalVolume = 0
            var nextCurrentDate = Date()
            var currentDateString = " "
            var previousDateString = " "
            let n:Double = 110
            var currrentDate = Date()
            var previousDate = Date()
            let stringFormatter = ChartStringFormatter()
            var barChartDataEntries: [BarChartDataEntry] = []
            var lineChartDataEntries: [ChartDataEntry] = []
            var BarsArray = [("JUN",n),("JUN",n),("JUN",n)]
            var GraphArray = [("JUN",n),("JUN",n),("JUN",n)]
            var Graph1Array = [("JUN",n),("JUN",n),("JUN",n)]
            var maxWorkOut:Double = 0
            var totalExercise:Double = 0
            var totalWorkOut:Double = 0
            var barValues: [Double] = [n,n,n]
            var barLabels: [String] = ["JUN","JUN","JUN"]
            var lineValues: [Double] = [n,n,n]
            var lineValuesLb: [Double] = [n,n,n]
            var lineLabels: [String] = ["JUN","JUN","JUN"]
            for i in 0...2{
                //let tt:TimeInterval = -252000
                let oneDay:TimeInterval = -90000
                
                
                currrentDate = nextCurrentDate
                
                previousDate = Calendar.current.date(byAdding: .month, value: (i+1) * -1 , to: Date())!
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM"
                let tmp = fetchDataFromDB(startDate: currrentDate, endDate: previousDate, currrentStartDate: currrentDate, currentEndDate: previousDate)
                currentDateString = formatter.string(from: currrentDate)
                previousDateString = formatter.string(from: previousDate)
                nextCurrentDate = previousDate.addingTimeInterval(oneDay)
                BarsArray[i] = ("\(previousDateString)",tmp[2])
                barValues[i] = tmp[2]
                barLabels[i] = "\(formatter.string(from:previousDate))"
                GraphArray[i] = ("\(previousDate)",tmp[1])
                Graph1Array[i] = ("\(previousDate)",tmp[1])
                lineValues[i] = tmp[1]
                lineValuesLb[i] = tmp[3]
                lineLabels[i] = "\(formatter.string(from:previousDate))"
                totalExercise = totalExercise + tmp[0]
                totalVolume = totalVolume + tmp[1]
                totalVolumeLb = totalVolumeLb + tmp[3]
                totalWorkOut = totalWorkOut + tmp[2]
                if(tmp[2] >  maxWorkOut)
                {
                    maxWorkOut = tmp[2]
                }
                
            }
            //print(exHistoryDict.count) number of exercise
            exerciseLabel.text = "\(Int(totalExercise))"
            //print(exVolume) Volume
            if(metricFlag == 0)
            {
                
                volumeLabel.text = "\(totalVolumeLb) lb"
                
            }
            else if(metricFlag == 1){
                
                volumeLabel.text = "\(totalVolume) t"
                
            }
            
            //print(exWorkOuts.count) total routines
            workOutLabel.text = "\(Int(totalWorkOut))"
            if(totalExercise > 0)
            {
                barChartView.translatesAutoresizingMaskIntoConstraints = false
                barChartView.centerYAnchor.constraint(
                    equalTo: barChartView.centerYAnchor).isActive = true
                barChartView.leftAnchor.constraint(
                    equalTo: barChartView.leftAnchor, constant: 10).isActive = true
                barChartView.rightAnchor.constraint(
                    equalTo: barChartView.rightAnchor, constant: -10).isActive = true
                barChartView.heightAnchor.constraint(
                    equalToConstant: 300.0).isActive = true
                // formatting the bar chart
                stringFormatter.nameValues = barLabels
                barChartView.xAxis.valueFormatter = stringFormatter
                barChartView.xAxis.setLabelCount(stringFormatter.nameValues.count, force: false)
                
                barChartView.xAxis.drawGridLinesEnabled = false
                barChartView.xAxis.drawAxisLineEnabled = false
                barChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
                
                barChartView.rightAxis.enabled = false
                barChartView.leftAxis.enabled = true
                
                barChartView.animate(xAxisDuration: 0.0, yAxisDuration: 0.6)
                barChartView.legend.enabled = false
                barChartView.chartDescription?.enabled = false
                barChartView.drawValueAboveBarEnabled = false
                
                
                // create the datapoints
                for (index, dataPoint) in barValues.enumerated() {
                    let dataEntry = BarChartDataEntry(x: Double(index),
                                                      y: dataPoint)
                    barChartDataEntries.append(dataEntry)
                 }
            
            // create the chartDataSet
            let chartDataSet = BarChartDataSet(values: barChartDataEntries,
                                               label: "")
            chartDataSet.colors = [FitFiColor]
            chartDataSet.valueTextColor = UIColor.white
            let chartData = BarChartData(dataSet: chartDataSet)
            self.barChartView.data = chartData
            
            
            
            print(GraphArray)
            volumeGraphView.translatesAutoresizingMaskIntoConstraints = false
            volumeGraphView.centerYAnchor.constraint(
                equalTo: volumeGraphView.centerYAnchor).isActive = true
            volumeGraphView.leftAnchor.constraint(
                equalTo: volumeGraphView.leftAnchor, constant: 10).isActive = true
            volumeGraphView.rightAnchor.constraint(
                equalTo: volumeGraphView.rightAnchor, constant: 0).isActive = true
            volumeGraphView.heightAnchor.constraint(
                equalToConstant: 300.0).isActive = true
            // formatting the bar chart
            stringFormatter.nameValues = lineLabels
            volumeGraphView.xAxis.valueFormatter = stringFormatter
            volumeGraphView.xAxis.setLabelCount(stringFormatter.nameValues.count, force: false)
            volumeGraphView.xAxis.axisMinimum = 0.0
            
            volumeGraphView.xAxis.drawGridLinesEnabled = false
            volumeGraphView.xAxis.drawAxisLineEnabled = false
            volumeGraphView.xAxis.labelPosition = XAxis.LabelPosition.bottom
            volumeGraphView.rightAxis.axisMinimum = 0.0
            volumeGraphView.leftAxis.axisMinimum = 0.0
            volumeGraphView.rightAxis.enabled = false
            volumeGraphView.leftAxis.enabled = true
            
            volumeGraphView.animate(xAxisDuration: 0.0, yAxisDuration: 0.6)
            volumeGraphView.legend.enabled = false
            volumeGraphView.chartDescription?.enabled = false
            
            // create the datapoints
            if(metricFlag == 0)
            {
                for (index, dataPoint) in lineValuesLb.enumerated() {
                    let dataEntry = ChartDataEntry(x: Double(index),
                                                   y: dataPoint)
                    lineChartDataEntries.append(dataEntry)
                }
            }
            else{
                for (index, dataPoint) in lineValues.enumerated() {
                    let dataEntry = ChartDataEntry(x: Double(index),
                                                   y: dataPoint)
                    lineChartDataEntries.append(dataEntry)
                }
            }
            // create the chartDataSet
            let lineDataSet = LineChartDataSet(values: lineChartDataEntries,
                                               label: "")
            lineDataSet.colors = [FitFiColor]
            // Setting fill gradient color
            let coloTop = UIColor(red: 213/255, green: 95/255, blue: 31/255, alpha: 0.8).cgColor
            let colorBottom = UIColor(red: 230/255, green: 155/255, blue: 210/255, alpha: 0.1).cgColor
            // Colors of the gradient
            let gradientColors = [coloTop, colorBottom] as CFArray
            // Positioning of the gradient
            let colorLocations: [CGFloat] = [0.7, 0.0]
            // Gradient Object
            let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)!
            lineDataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
            lineDataSet.drawFilledEnabled = true
            lineDataSet.valueTextColor = UIColor.white
            let lineData = LineChartData(dataSet: lineDataSet)
            self.volumeGraphView.data = lineData
            
            
            exerciseTable.reloadData()
        }
        else{
            print("No Data")
        }
        break
        case 2:
            totalVolumeLb = 0
            totalVolume = 0
            var nextCurrentDate = Date()
            var currentDateString = " "
            var previousDateString = " "
            let n:Double = 110
            var currrentDate = Date()
            var previousDate = Date()
            let stringFormatter = ChartStringFormatter()
            var dataEntries: [BarChartDataEntry] = []
            var lineChartDataEntries: [ChartDataEntry] = []
            var BarsArray = [("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n)]
            var barValues: [Double] = [n,n,n,n,n,n,n,n,n,n,n,n]
            var barLabels: [String] = ["JUN","JUN","JUN","JUN","JUN","JUN","JUN","JUN","JUN","JUN","JUN","JUN"]
            var GraphArray = [("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n)]
            var Graph1Array = [("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n)]
            var lineValues: [Double] = [n,n,n,n,n,n,n,n,n,n,n,n]
            var lineValuesLb: [Double] = [n,n,n,n,n,n,n,n,n,n,n,n]
            var lineLabels: [String] = ["JUN","JUN","JUN","JUN","JUN","JUN","JUN","JUN","JUN","JUN","JUN","JUN"]
            var maxWorkOut:Double = 0
            var totalExercise:Double = 0
            var totalWorkOut:Double = 0
            for i in 0...11{
               
                
                let oneDay:TimeInterval = -90000
                
                
                currrentDate = nextCurrentDate
                
                previousDate = Calendar.current.date(byAdding: .month, value: (i+1) * -1 , to: Date())!
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM"
                let tmp = fetchDataFromDB(startDate: currrentDate, endDate: previousDate, currrentStartDate: currrentDate, currentEndDate: previousDate)
                currentDateString = formatter.string(from: currrentDate)
                previousDateString = formatter.string(from: previousDate)
                nextCurrentDate = previousDate.addingTimeInterval(oneDay)
                BarsArray[i] = ("\(currentDateString)",tmp[0])
                barValues[i] = tmp[2]
                barLabels[i] = "\(formatter.string(from:previousDate))"
                GraphArray[i] = ("\(previousDate)",tmp[1])
                Graph1Array[i] = ("\(previousDate)",tmp[1])
                lineValues[i] = tmp[1]
                lineValuesLb[i] = tmp[3]
                lineLabels[i] = "\(formatter.string(from:previousDate))"
                totalExercise = totalExercise + tmp[0]
                totalVolume = totalVolume + tmp[1]
                totalVolumeLb = totalVolumeLb + tmp[3]
                totalWorkOut = totalWorkOut + tmp[2]
                if(tmp[0] >  maxWorkOut)
                {
                    maxWorkOut = tmp[0]
                }
                
            }
            //print(exHistoryDict.count) number of exercise
            exerciseLabel.text = "\(Int(totalExercise))"
            //print(exVolume) Volume
            if(metricFlag == 0)
            {
                
                volumeLabel.text = "\(totalVolumeLb) lb"
                
            }
            else if(metricFlag == 1){
               
                volumeLabel.text = "\(totalVolume) t"
                
            }

            //print(exWorkOuts.count) total routines
            workOutLabel.text = "\(Int(totalWorkOut))"
            if(totalExercise > 0)
            {
                barChartView.translatesAutoresizingMaskIntoConstraints = false
                barChartView.centerYAnchor.constraint(
                    equalTo: barChartView.centerYAnchor).isActive = true
                barChartView.leftAnchor.constraint(
                    equalTo: barChartView.leftAnchor, constant: 10).isActive = true
                barChartView.rightAnchor.constraint(
                    equalTo: barChartView.rightAnchor, constant: -10).isActive = true
                barChartView.heightAnchor.constraint(
                    equalToConstant: 300.0).isActive = true
                // formatting the bar chart
                stringFormatter.nameValues = barLabels
                barChartView.xAxis.valueFormatter = stringFormatter
                barChartView.xAxis.setLabelCount(stringFormatter.nameValues.count, force: false)
                
                barChartView.xAxis.drawGridLinesEnabled = false
                barChartView.xAxis.drawAxisLineEnabled = false
                barChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
                
                barChartView.rightAxis.enabled = false
                barChartView.leftAxis.enabled = true
                
                barChartView.animate(xAxisDuration: 0.0, yAxisDuration: 0.6)
                barChartView.legend.enabled = false
                barChartView.chartDescription?.enabled = false
                barChartView.drawValueAboveBarEnabled = false
                
                
                // create the datapoints
                for (index, dataPoint) in barValues.enumerated() {
                    let dataEntry = BarChartDataEntry(x: Double(index),
                                                      y: dataPoint)
                    dataEntries.append(dataEntry)
                }
                
                // create the chartDataSet
                let chartDataSet = BarChartDataSet(values: dataEntries,
                                                   label: "")
                chartDataSet.colors = [FitFiColor]
                chartDataSet.valueTextColor = UIColor.white
                let chartData = BarChartData(dataSet: chartDataSet)
                self.barChartView.data = chartData
                volumeGraphView.translatesAutoresizingMaskIntoConstraints = false
                volumeGraphView.centerYAnchor.constraint(
                    equalTo: volumeGraphView.centerYAnchor).isActive = true
                volumeGraphView.leftAnchor.constraint(
                    equalTo: volumeGraphView.leftAnchor, constant: 10).isActive = true
                volumeGraphView.rightAnchor.constraint(
                    equalTo: volumeGraphView.rightAnchor, constant: -10).isActive = true
                volumeGraphView.heightAnchor.constraint(
                    equalToConstant: 300.0).isActive = true
                // formatting the bar chart
                stringFormatter.nameValues = lineLabels
                volumeGraphView.xAxis.valueFormatter = stringFormatter
                volumeGraphView.xAxis.setLabelCount(stringFormatter.nameValues.count, force: false)
                
                volumeGraphView.xAxis.drawGridLinesEnabled = false
                volumeGraphView.xAxis.drawAxisLineEnabled = false
                volumeGraphView.xAxis.labelPosition = XAxis.LabelPosition.bottom
                volumeGraphView.rightAxis.axisMinimum = 0.0
                volumeGraphView.leftAxis.axisMinimum = 0.0
                volumeGraphView.rightAxis.enabled = false
                volumeGraphView.leftAxis.enabled = true
                
                volumeGraphView.animate(xAxisDuration: 0.0, yAxisDuration: 0.6)
                volumeGraphView.legend.enabled = false
                volumeGraphView.chartDescription?.enabled = false
                
                // create the datapoints
                if(metricFlag == 0)
                {
                    for (index, dataPoint) in lineValuesLb.enumerated() {
                        let dataEntry = ChartDataEntry(x: Double(index),
                                                       y: dataPoint)
                        lineChartDataEntries.append(dataEntry)
                    }
                }
                else{
                    for (index, dataPoint) in lineValues.enumerated() {
                        let dataEntry = ChartDataEntry(x: Double(index),
                                                       y: dataPoint)
                        lineChartDataEntries.append(dataEntry)
                    }
                }
                
                // create the chartDataSet
                let lineDataSet = LineChartDataSet(values: lineChartDataEntries,
                                                   label: "")
                lineDataSet.colors = [FitFiColor]
                // Setting fill gradient color
                let coloTop = UIColor(red: 213/255, green: 95/255, blue: 31/255, alpha: 0.8).cgColor
                let colorBottom = UIColor(red: 230/255, green: 155/255, blue: 210/255, alpha: 0.1).cgColor
                // Colors of the gradient
                let gradientColors = [coloTop, colorBottom] as CFArray
                // Positioning of the gradient
                let colorLocations: [CGFloat] = [0.7, 0.0]
                // Gradient Object
                let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)!
                lineDataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
                lineDataSet.drawFilledEnabled = true
                lineDataSet.valueTextColor = UIColor.white
                let lineData = LineChartData(dataSet: lineDataSet)
                self.volumeGraphView.data = lineData
                
                exerciseTable.reloadData()
            }
            else{
                print("No Data")
            }
            break
            
            
        default:
            break
        } //workOutGraphView.willRemoveSubview(threeMonthchart.view)
        
        
    }
    func fetchDataFromDB(startDate : Date, endDate : Date, currrentStartDate : Date, currentEndDate : Date) -> [Double]{
        exHistoryDict = []
        exVolume = 0
        exReps = []
        exSets = []
        exWeight = []
        exWorkOuts = 0
        exVolumeLb = 0
        //for calculate seven days
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Routine_History")
       // let calendar = NSCalendar.current
        
        //let now = NSDate()
        
        // let sevenDaysAgo = calendar.dateByAddingUnit(.Day, value: -7, toDate: now, options: NSCalendar.Options())!
        // let startDate = calendar.startOfDayForDate(sevenDaysAgo)
        let predicate = NSPredicate(format:"(end >= %@) AND (start < %@)", currentEndDate as CVarArg ,currrentStartDate as CVarArg)
        fetchRequest.predicate = predicate
        //        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        //        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            routineHistoryArray = try context.fetch(fetchRequest) as! [Routine_History]
            
        } catch {
            print("Loading Exercises Error: \(error)")
        }
        if(routineHistoryArray.count > 0)
        {
        exWorkOuts = routineHistoryArray.count
        print(routineHistoryArray)
        for i in routineHistoryArray{
            exVolume = exVolume + Int(i.totalWeight)
        }
        }
        //for graph
        //        for view in workOutGraphView.subviews {
        //            view.removeFromSuperview()
        //        }
        //
        exerciseHistoryArray = []   
        for i in routineHistoryArray 
        {
            for j in i.exerciseHistory!
            {
                exerciseHistoryArray.append(j as! Exercise_History)
            }
        }
        for i in exerciseHistoryArray{
            if(exHistoryDict.contains(i.name!)){
                //do nothing
            }
            else{
                exHistoryDict.append(i.name!)
                
            }
            if(exerciseList.contains(i.name!)){
                //do nothing
            }
            else{
                print(i.category!)
                if(sectionData.count == 0)
                {
                    sectionData.append(Seection(category: i.category!, exercise: [i.name!]))
                    
                }
                else{
                for ii in 0..<sectionData.count
                {
                    if(sectionData[ii].category == i.category!)
                    {
                        if(sectionData[ii].exercise.contains(i.name!)){
                            //do nothing
                        }
                        else{
                        sectionData[ii].exercise.append(i.name!)
                        }
                    }
                    else{
                        var containsFlag = 0
                        if(sectionData.count > 0)
                        {
                        for iii in 0..<sectionData.count
                        {
                            if(sectionData[iii].category == i.category!)
                            {
                                containsFlag = 1
                            }
                        }
                        if(containsFlag == 0)
                        {
                        sectionData.append(Seection(category: i.category!, exercise: [i.name!]))
                        }
                    }
                    }
                }
                }
                
                exerciseList.append(i.name!)
                
            }
            
            //print(i.parentRoutineHistory!.name!)
            
           
           // exVolume = exVolume + Int(i.reps * i.sets * i.weight)
            
            
        }
        
        
        
        //print(exHistoryDict.count) number of exercise
        exerciseLabel.text = "\(exHistoryDict.count)"
        workOutLabel.text = "\(Int(exWorkOuts))"
        //print(exVolume) Volume
        if(totalVolume < 2000)
        {
            metricFlag = 0
            volumeLabel.text = "\(exVolume) lb"
            return [Double(exHistoryDict.count) , Double(exVolume/2000), Double(exWorkOuts),Double(exVolume)]
        }
        else{
            metricFlag = 1
            volumeLabel.text = "\(exVolume/2000) t"
            return [Double(exHistoryDict.count) , Double(exVolume/2000), Double(exWorkOuts),Double(exVolume)]
        }
        
        //print(exWorkOuts.count) total routines
     
       
    }
    
    
    
}
//for genrating volume graph

private extension CGPoint {
    /**
     Rounds the coordinates to whole-pixel values
     
     - parameter scale: The display scale to use. Defaults to the main screen scale.
     */
    mutating func makeIntegralInPlaceWithDisplayScale(_ scale: CGFloat = 0) {
        var scale = scale
        
        // It's possible for scale values retrieved from traitCollection objects to be 0.
        if scale == 0 {
            scale = UIScreen.main.scale
        }
        x = round(x * scale) / scale
        y = round(y * scale) / scale
    }
}


private extension BidirectionalCollection where Index: Strideable, Iterator.Element: Comparable, Index.Stride == Int {
    
    /**
     Returns the insertion index of a new value in a sorted collection
     
     Based on some helpful responses found at [StackOverflow](http://stackoverflow.com/a/33674192)
     
     - parameter value: The value to insert
     
     - returns: The appropriate insertion index, between `startIndex` and `endIndex`
     */
    func findInsertionIndexForValue(_ value: Iterator.Element) -> Index {
        var low = startIndex
        var high = endIndex
        
        while low != high {
            let mid = low.advanced(by: low.distance(to: high) / 2)
            
            if self[mid] < value {
                low = mid.advanced(by: 1)
            } else {
                high = mid
            }
        }
        
        return low
    }
}


private extension BidirectionalCollection where Index: Strideable, Iterator.Element: Strideable, Index.Stride == Int {
    /**
     Returns the index of the closest element to a specified value in a sorted collection
     
     - parameter value: The value to match
     
     - returns: The index of the closest element, or nil if the collection is empty
     */
    func findClosestElementIndexToValue(_ value: Iterator.Element) -> Index? {
        let upperBound = findInsertionIndexForValue(value)
        
        if upperBound == startIndex {
            if upperBound == endIndex {
                return nil
            }
            return upperBound
        }
        
        let lowerBound = upperBound.advanced(by: -1)
        
        if upperBound == endIndex {
            return lowerBound
        }
        
        if value.distance(to: self[upperBound]) < self[lowerBound].distance(to: value) {
            return upperBound
        }
        
        return lowerBound
    }
}

extension StatisticsViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showExerciseDetailVC" {
            let destinationVC = segue.destination as! ExerciseDetailsViewController
            if exerciseTable.indexPathForSelectedRow != nil {
              destinationVC.selectedExercise = exerciseObject!
                destinationVC.fromStats = 1
            }
        }
    }
}


extension StatisticsViewController:CollapsibleTableViewHeaderDelegate {
    func getExerciseObject(e_name: String)
    {
        let allExercisesRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        let oneExercisePredicate = NSPredicate(format: "name = %@",e_name)
        allExercisesRequest.predicate = oneExercisePredicate
        
        do {
             let exerciseList = try context.fetch(allExercisesRequest) as! [Exercise]
            exerciseObject = exerciseList[0]
            
        } catch {
            print("\(error)")
        }
        
    }
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !sectionData[section].collapsed
        
        // Toggle collapse
        sectionData[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        
        exerciseTable.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
}
extension StatisticsViewController{
    func chartValueSelected(_ chartView: ChartViewBase, ﻿entry: ChartDataEntry, highlight: Highlight) {
        //chartView.xAxis
    }
}


