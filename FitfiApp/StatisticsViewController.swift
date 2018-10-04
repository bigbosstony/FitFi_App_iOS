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
import SwiftCharts
import CoreData

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
private extension UIColor {
    static let secondaryLabelColor = UIColor(red: 142 / 255, green: 142 / 255, blue: 147 / 255, alpha: 1)
    
    static let gridColor = UIColor(white: 193 / 255, alpha: 1)
    
    static let glucoseTintColor = UIColor(red: 96 / 255, green: 201 / 255, blue: 248 / 255, alpha: 1)
    
    static let IOBTintColor: UIColor = UIColor(red: 254 / 255, green: 149 / 255, blue: 38 / 255, alpha: 1)
}

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

private var glucosePoints: [ChartPoint] = [("2016-02-28T07:26:38", 95), ("2016-02-28T07:31:38", 93), ("2016-02-28T07:41:39", 92), ("2016-02-28T07:51:42", 92), ("2016-02-28T07:56:38", 94), ("2016-02-28T08:01:39", 94), ("2016-02-28T08:06:38", 95), ("2016-02-28T08:11:37", 95), ("2016-02-28T08:16:40", 100), ("2016-02-28T08:21:39", 99), ("2016-02-28T08:26:39", 99), ("2016-02-28T08:31:38", 97), ("2016-02-28T08:51:43", 101), ("2016-02-28T08:56:39", 105), ("2016-02-28T09:01:43", 101), ("2016-02-28T09:06:37", 102), ("2016-02-28T09:11:37", 107), ("2016-02-28T09:16:38", 109), ("2016-02-28T09:21:37", 113), ("2016-02-28T09:26:41", 114), ("2016-02-28T09:31:37", 112), ("2016-02-28T09:36:39", 111), ("2016-02-28T09:41:40", 111), ("2016-02-28T09:46:43", 112), ("2016-02-28T09:51:38", 113), ("2016-02-28T09:56:43", 112), ("2016-02-28T10:01:38", 111), ("2016-02-28T10:06:42", 112), ("2016-02-28T10:11:37", 115), ("2016-02-28T10:16:42", 119), ("2016-02-28T10:21:42", 121), ("2016-02-28T10:26:38", 127), ("2016-02-28T10:31:36", 129), ("2016-02-28T10:36:37", 132), ("2016-02-28T10:41:38", 135), ("2016-02-28T10:46:37", 138), ("2016-02-28T10:51:36", 137), ("2016-02-28T10:56:38", 141), ("2016-02-28T11:01:37", 146), ("2016-02-28T11:06:40", 151), ("2016-02-28T11:16:37", 163), ("2016-02-28T11:21:36", 169), ("2016-02-28T11:26:37", 177), ("2016-02-28T11:31:37", 183), ("2016-02-28T11:36:37", 187), ("2016-02-28T11:41:36", 190), ("2016-02-28T11:46:36", 192), ("2016-02-28T11:51:36", 194), ("2016-02-28T11:56:36", 194), ("2016-02-28T12:01:37", 192), ("2016-02-28T12:06:41", 192), ("2016-02-28T12:11:36", 183), ("2016-02-28T12:16:38", 176), ("2016-02-28T12:21:39", 165), ("2016-02-28T12:26:38", 156), ("2016-02-28T12:31:37", 144), ("2016-02-28T12:36:36", 138), ("2016-02-28T12:41:37", 131), ("2016-02-28T12:46:37", 125), ("2016-02-28T12:51:36", 118), ("2016-02-28T13:01:43", 104), ("2016-02-28T13:06:45", 97), ("2016-02-28T13:11:39", 92), ("2016-02-28T13:16:37", 88), ("2016-02-28T13:21:36", 88)].map {
    return ChartPoint(
        x: ChartAxisValueDate(date: localDateFormatter.date(from: $0.0)!, formatter: threeMonthformatter),
        y: ChartAxisValueInt($0.1)
    )
}



private var IOBPoints: [ChartPoint] = [("2016-02-28T07:25:00", 0.0), ("2016-02-28T07:30:00", 0.0036944444444472783), ("2016-02-28T07:35:00", -0.041666666666665263), ("2016-02-28T07:40:00", -0.11298963260090503), ("2016-02-28T07:45:00", -0.18364018193611475),  ("2016-02-28T18:05:00", 0.0), ("2016-02-28T18:10:00", 0.0)].map {
    return ChartPoint(
        x: ChartAxisValueDate(date: localDateFormatter.date(from: $0.0)!, formatter: threeMonthformatter),
        y: ChartAxisValueDouble($0.1, formatter: decimalFormatter)
    )
}

private let axisLabelSettings: ChartLabelSettings = ChartLabelSettings()
class StatisticsViewController: UIViewController ,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource{
    var exerciseList:[String] = ["h ","j "]
    var exerciseObject:Exercise? = nil
    public var sectionData:[Seection] = [
        Seection(category: "Arm", exercise: ["man","it shouls in"]), Seection(category: "Leg", exercise: ["man","it shouls in"])]
   
   
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
    var workoutBarChart:BarsChart!
    fileprivate lazy private(set) var axisLineColor = UIColor.clear
    private let axisLabelSettings: ChartLabelSettings = ChartLabelSettings()
    fileprivate var xAxisValues: [ChartAxisValue]? {
        didSet {
            if let xAxisValues = xAxisValues {
                xAxisModel = ChartAxisModel(axisValues: xAxisValues, lineColor: axisLineColor, labelSpaceReservationMode: .fixed(20))
            } else {
                xAxisModel = nil
            }
        }
    }
    
    fileprivate var xAxisModel: ChartAxisModel?
    //
    fileprivate lazy private(set) var chartSettings: ChartSettings = {
        var chartSettings = ChartSettings()
        chartSettings.top = 12
        chartSettings.bottom = 0
        chartSettings.trailing = 0
        chartSettings.axisTitleLabelsToLabelsSpacing = 0
        chartSettings.labelsToAxisSpacingX = 6
        chartSettings.clipInnerFrame = false
        return chartSettings
    }()
    private let guideLinesLayerSettings: ChartGuideLinesLayerSettings = ChartGuideLinesLayerSettings()
    
    static func chartFrame(_ containerBounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 70, width: containerBounds.size.width, height: containerBounds.size.height - 70)
    }
    fileprivate var bottomChart: Chart?
    fileprivate lazy private(set) var chartLongPressGestureRecognizer = UILongPressGestureRecognizer()
    
    @IBOutlet weak var F1: UIImageView!
    //var volumeAreaGraph:IOB
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
    
    
    
    
    
    @IBAction func timeSegments(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("q month")
            workOutLabel.text = "01"
            volumeLabel.text = "01"
            exerciseLabel.text = "05"
            timeSelected(index: 0)
            break
        case 1:
            print("3 months")
            workOutLabel.text = "03"
            volumeLabel.text = "02"
            exerciseLabel.text = "06"
            timeSelected(index: 1)
            break
        case 2:
            print("1 year")
            workOutLabel.text = "04"
            volumeLabel.text = "03"
            exerciseLabel.text = "07"
            timeSelected(index: 2)
            break
        default:
            break
        }
    }
    
    @IBOutlet weak var timeSegmentOutlet: UISegmentedControl!
    
    @IBOutlet weak var workOutGraphView: UIView!
    @IBOutlet weak var volumeGraphView: UIView!
    
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var workOutLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    
    
    
    
    @IBOutlet weak var exerciseTable: UITableView!
    var exHistoryDict:[String] = []
    var exVolume:Int = 0
    var exReps:[Int] = []
    var exSets:[Int] = []
    var exWeight:[Int] = []
    var exWorkOuts:Int = 0
     var metricFlag:Int = 0// to get ton know if weight is low than it will be 0 to print lb instead of tone
    override func viewDidLoad() {
        super.viewDidLoad()
       
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
        
        chartLongPressGestureRecognizer.delegate = self
        exerciseTable.delegate = self
        exerciseTable.dataSource = self
        exerciseTable.estimatedRowHeight = 44.0
        exerciseTable.rowHeight = UITableView.automaticDimension
        chartLongPressGestureRecognizer.minimumPressDuration = 0.01
        volumeGraphView.addGestureRecognizer(chartLongPressGestureRecognizer)
        generateXAxisValues()
        let frame = StatisticsViewController.chartFrame(volumeGraphView.bounds)
        bottomChart = generateIOBChartWithFrame(frame: frame)
        
        for chart in [bottomChart]{
            if let view = chart?.view {
                volumeGraphView.addSubview(view)
            }
        }
        //        UIApplication.shared.keyWindow?.addSubview(containerView)
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    
    fileprivate func generateXAxisValues() {
        let points = glucosePoints
        
        guard points.count > 1 else {
            self.xAxisValues = []
            return
        }
        let timeFormatter = DateFormatter()
        if(points.count == 4){
            timeFormatter.dateFormat = "MM/dd"
        }
        else{
            timeFormatter.dateFormat = "MMM"
        }
        
        
        
        let xAxisValues = ChartAxisValuesStaticGenerator.generateXAxisValuesWithChartPoints(points, minSegmentCount: 3, maxSegmentCount: 4, multiple: TimeInterval(60), axisValueGenerator: { ChartAxisValueDate(date: ChartAxisValueDate.dateFromScalar($0), formatter: timeFormatter, labelSettings: axisLabelSettings)
        }, addPaddingSegmentIfEdge: true)
        xAxisValues.first?.hidden = false
        xAxisValues.last?.hidden = false
        
        self.xAxisValues = xAxisValues
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
extension StatisticsViewController{
    func timeSelected(index: Int)
    {
        let chartConfigg = BarsChartConfig(valsAxisConfig: ChartAxisConfig(from: 0,to: 100,by: 10))
        
        let frame = CGRect(x:0,y:10,width:workOutGraphView.bounds.width,height:workOutGraphView.bounds.height - 10)
        var oneMonthchart = BarsChart(
            frame: frame,
            chartConfig: chartConfigg,
            xTitle: "Week",
            yTitle:"workOut",
            bars:[("Jan",150),
                  ("JUN",110)],
            color: FitFiColor,
            barWidth: 10)
        var threeMonthchart = BarsChart(
            frame: frame,
            chartConfig: chartConfigg,
            xTitle: "Month",
            yTitle:"workOut",
            bars:[("Feb",150),
                  ("July",110)],
            color: FitFiColor,
            barWidth: 10)
        var oneYearChart = BarsChart(
            frame: frame,
            chartConfig: chartConfigg,
            xTitle: "Month",
            yTitle:"workOut",
            bars:[("Dec",150),
                  ("April",110),
                  ("JAb",110)],
            color: FitFiColor,
            barWidth: 10)
        
        exerciseList = []
        sectionData = []
        
        switch index {
        case 0:
            
            var nextCurrentDate = Date()
            var currentDateString = " "
            var previousDateString = " "
            let n:Double = 110
            var currrentDate = Date()
            var previousDate = Date()
            var BarsArray = [("JUN",n),("JUN",n),("JUN",n),("JUN",n)]
            var GraphArray = [("JUN",n),("JUN",n),("JUN",n),("JUN",n)]
            var Graph1Array = [("JUN",n),("JUN",n),("JUN",n),("JUN",n)]
            var maxWorkOut:Double = 0
            var totalExercise:Double = 0
            var totalVolume:Double = 0
            var totalWorkOut:Double = 0
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
                Graph1Array[i] = ("\(previousDate)",tmp[1])
                totalExercise = totalExercise + tmp[0]
                totalVolume = totalVolume + tmp[1]
                totalWorkOut = totalWorkOut + tmp[2]
                if(tmp[2] >  maxWorkOut)
                {
                    maxWorkOut = tmp[2]
                }
                
            }
            
            //print(exHistoryDict.count) number of exercise
            exerciseLabel.text = "\(Int(totalExercise))"
            //print(exVolume) Volume
            if(totalVolume < 1)
            {
                metricFlag = 0
                volumeLabel.text = "\(totalVolume * 2000) lb"
                
            }
            else{
                metricFlag = 1
                volumeLabel.text = "\(totalVolume) t"
                
            }

            //print(exWorkOuts.count) total routines
            workOutLabel.text = "\(Int(totalWorkOut))"
            let chartConfig = BarsChartConfig(valsAxisConfig: ChartAxisConfig(from: 0,to: maxWorkOut + 1,by: 1))
            //            barsArray.append("\(currentDateString)/\(currentDateString),150")
            if(totalExercise > 0){
            oneMonthchart = BarsChart(
                frame: frame,
                chartConfig: chartConfig,
                xTitle: "Week",
                yTitle:"workOut",
                bars:BarsArray,
                color: FitFiColor,
                barWidth: 10)
            for view in workOutGraphView.subviews {
                view.removeFromSuperview()
            }
            workOutGraphView.addSubview(oneMonthchart.view)
            workoutBarChart = oneMonthchart
            print(GraphArray)
            IOBPoints = GraphArray.map {
                return ChartPoint(
                    x: ChartAxisValueDate(date: localDateFormatterr.date(from: $0.0)!, formatter: oneMonth),
                    y: ChartAxisValueDouble($0.1, formatter: decimalFormatter)
                )
            }
            glucosePoints = Graph1Array.map {
                return ChartPoint(
                    x: ChartAxisValueDate(date: localDateFormatterr.date(from: $0.0)!, formatter: dateFormatter),
                    y: ChartAxisValueInt(Int($0.1 * 100))
                )
            }
            print(IOBPoints)
            generateXAxisValues()
            //print(xAxisValues)
            let frame = StatisticsViewController.chartFrame(volumeGraphView.bounds)
            bottomChart = generateIOBChartWithFrame(frame: frame)
            for view in volumeGraphView.subviews {
                view.removeFromSuperview()
            }
            for chart in [bottomChart]{
                if let view = chart?.view {
                    volumeGraphView.addSubview(view)
                }
            }
            }
            else{
                print("No data")
            }
            break
        case 1:
            var nextCurrentDate = Date()
            var currentDateString = " "
            var previousDateString = " "
            let n:Double = 110
            var currrentDate = Date()
            var previousDate = Date()
            var BarsArray = [("JUN",n),("JUN",n),("JUN",n)]
            var GraphArray = [("JUN",n),("JUN",n),("JUN",n)]
            var Graph1Array = [("JUN",n),("JUN",n),("JUN",n)]
            var maxWorkOut:Double = 0
            var totalExercise:Double = 0
            var totalVolume:Double = 0
            var totalWorkOut:Double = 0
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
                BarsArray[i] = ("\(previousDateString)",tmp[0])
                GraphArray[i] = ("\(previousDate)",tmp[1])
                Graph1Array[i] = ("\(previousDate)",tmp[1])
                print(previousDate)
                totalExercise = totalExercise + tmp[0]
                totalVolume = totalVolume + tmp[1]
                totalWorkOut = totalWorkOut + tmp[2]
                if(tmp[0] >  maxWorkOut)
                {
                    maxWorkOut = tmp[0]
                }
                
            }
            //print(exHistoryDict.count) number of exercise
            exerciseLabel.text = "\(Int(totalExercise))"
            //print(exVolume) Volume
            if(totalVolume < 1)
            {
                metricFlag = 0
                volumeLabel.text = "\(totalVolume * 2000) lb"
                
            }
            else{
                metricFlag = 1
                volumeLabel.text = "\(totalVolume) t"
                
            }

            //print(exWorkOuts.count) total routines
            workOutLabel.text = "\(Int(totalWorkOut))"
            if(totalExercise > 0)
            {
            let chartConfig = BarsChartConfig(valsAxisConfig: ChartAxisConfig(from: 0,to: maxWorkOut + 1,by: 1))
            
            //            barsArray.append("\(currentDateString)/\(currentDateString),150")
            threeMonthchart = BarsChart(
                frame: frame,
                chartConfig: chartConfig,
                xTitle: "Week",
                yTitle:"workOut",
                bars:BarsArray,
                color: FitFiColor,
                barWidth: 10)
            //for graph
            for view in workOutGraphView.subviews {
                view.removeFromSuperview()
            }
            workOutGraphView.addSubview(threeMonthchart.view)
            workoutBarChart = threeMonthchart
            
            print(GraphArray)
            IOBPoints = GraphArray.map {
                return ChartPoint(
                    x: ChartAxisValueDate(date: localDateFormatterr.date(from: $0.0)!, formatter: oneMonth),
                    y: ChartAxisValueDouble($0.1, formatter: decimalFormatter)
                )
            }
            glucosePoints = Graph1Array.map {
                return ChartPoint(
                    x: ChartAxisValueDate(date: localDateFormatterr.date(from: $0.0)!, formatter: dateFormatter),
                    y: ChartAxisValueInt(Int($0.1 * 100))
                )
            }
            print(IOBPoints)
            generateXAxisValues()
//            print(xAxisValues)
            let frame = StatisticsViewController.chartFrame(volumeGraphView.bounds)
            bottomChart = generateIOBChartWithFrame(frame: frame)
            for view in volumeGraphView.subviews {
                view.removeFromSuperview()
            }
            for chart in [bottomChart]{
                if let view = chart?.view {
                    volumeGraphView.addSubview(view)
                }
            }
            }
            else{
                print("No Data")
            }
            break
            
        case 2:
            
            var nextCurrentDate = Date()
            var currentDateString = " "
            var previousDateString = " "
            let n:Double = 110
            var currrentDate = Date()
            var previousDate = Date()
            var BarsArray = [("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n)]
            var GraphArray = [("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n)]
            var Graph1Array = [("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n),("JUN",n)]
            var maxWorkOut:Double = 0
            var totalExercise:Double = 0
            var totalVolume:Double = 0
            var totalWorkOut:Double = 0
            for i in 0...11{
               // var tt:TimeInterval = -1764000
                
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
                GraphArray[i] = ("\(previousDate)",tmp[1])
                Graph1Array[i] = ("\(previousDate)",tmp[1])
                totalExercise = totalExercise + tmp[0]
                totalVolume = totalVolume + tmp[1]
                totalWorkOut = totalWorkOut + tmp[2]
                if(tmp[0] >  maxWorkOut)
                {
                    maxWorkOut = tmp[0]
                }
                
            }
            //print(exHistoryDict.count) number of exercise
            exerciseLabel.text = "\(Int(totalExercise))"
            //print(exVolume) Volume
            if(totalVolume < 1)
            {
                metricFlag = 0
                volumeLabel.text = "\(totalVolume * 2000) lb"
                
            }
            else{
                metricFlag = 1
                volumeLabel.text = "\(totalVolume) t"
                
            }

            //print(exWorkOuts.count) total routines
            workOutLabel.text = "\(Int(totalWorkOut))"
            if(totalExercise > 0)
            {
            let chartConfig = BarsChartConfig(valsAxisConfig: ChartAxisConfig(from: 0,to: maxWorkOut + 1,by: 1))
            
            //            barsArray.append("\(currentDateString)/\(currentDateString),150")
            oneYearChart = BarsChart(
                frame: frame,
                chartConfig: chartConfig,
                xTitle: "Week",
                yTitle:"workOut",
                bars:BarsArray,
                color: FitFiColor,
                barWidth: 10)
            //for graph
            for view in workOutGraphView.subviews {
                view.removeFromSuperview()
            }
            workOutGraphView.addSubview(oneYearChart.view)
            workoutBarChart = oneYearChart
            IOBPoints = GraphArray.map {
                return ChartPoint(
                    x: ChartAxisValueDate(date: localDateFormatterr.date(from: $0.0)!, formatter: oneMonth),
                    y: ChartAxisValueDouble($0.1, formatter: decimalFormatter)
                )
            }
            glucosePoints = Graph1Array.map {
                return ChartPoint(
                    x: ChartAxisValueDate(date: localDateFormatterr.date(from: $0.0)!, formatter: dateFormatter),
                    y: ChartAxisValueInt(Int($0.1 * 100))
                )
            }
            print(IOBPoints)
            generateXAxisValues()
          //  print(xAxisValues)
                let frame = StatisticsViewController.chartFrame(volumeGraphView.bounds)

            bottomChart = generateIOBChartWithFrame(frame: frame)
            for view in volumeGraphView.subviews {
                view.removeFromSuperview()
            }
            for chart in [bottomChart]{
                if let view = chart?.view {
                    volumeGraphView.addSubview(view)
                }
            }
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
        if(exVolume < 2000)
        {
            
            volumeLabel.text = "\(exVolume) lb"
            return [Double(exHistoryDict.count) , Double(exVolume/2000), Double(exWorkOuts)]
        }
        else{
            
            volumeLabel.text = "\(exVolume/2000) t"
            return [Double(exHistoryDict.count) , Double(exVolume/2000), Double(exWorkOuts)]
        }
        
        //print(exWorkOuts.count) total routines
     
       
    }
    
    private func generateIOBChartWithFrame(frame: CGRect) -> Chart? {
        guard IOBPoints.count > 1, let xAxisValues = xAxisValues, let xAxisModel = xAxisModel else {
            return nil
        }
        
        var containerPoints = IOBPoints
        
        // Create a container line at 0
        if let first = IOBPoints.first {
            containerPoints.insert(ChartPoint(x: first.x, y: ChartAxisValueInt(0)), at: 0)
        }
        
        if let last = IOBPoints.last {
            containerPoints.append(ChartPoint(x: last.x, y: ChartAxisValueInt(0)))
        }
        
        let yAxisValues = ChartAxisValuesStaticGenerator.generateYAxisValuesWithChartPoints(IOBPoints, minSegmentCount: 2, maxSegmentCount: 3, multiple: 0.5, axisValueGenerator: { ChartAxisValueDouble($0, labelSettings: axisLabelSettings)}, addPaddingSegmentIfEdge: false)
        
        let yAxisModel = ChartAxisModel(axisValues: yAxisValues, lineColor: axisLineColor, labelSpaceReservationMode: .fixed(30))
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: frame, xModel: xAxisModel, yModel: yAxisModel)
        
        let (xAxisLayer, yAxisLayer) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer)
        let (xAxis, yAxis) = (xAxisLayer.axis, yAxisLayer.axis)
        
        // The IOB area
        let lineModel = ChartLineModel(chartPoints: IOBPoints, lineColor: FitFiColor, lineWidth: 2, animDuration: 0, animDelay: 0)
        let IOBLine = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, lineModels: [lineModel], pathGenerator: StraightLinePathGenerator())
        
        let IOBArea = ChartPointsAreaLayer(xAxis: xAxis, yAxis: yAxis, chartPoints: containerPoints, areaColors: [UIColor.IOBTintColor.withAlphaComponent(0.75), UIColor.clear], animDuration: 0, animDelay: 0, addContainerPoints: false, pathGenerator: IOBLine.pathGenerator)
        
        // Grid lines
        let gridLayer = ChartGuideLinesForValuesLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, settings: guideLinesLayerSettings, axisValuesX: xAxisValues, axisValuesY: yAxisValues)
        
        // 0-line
        let dummyZeroChartPoint = ChartPoint(x: ChartAxisValueDouble(0), y: ChartAxisValueDouble(0))
        let zeroGuidelineLayer = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, chartPoints: [dummyZeroChartPoint], viewGenerator: {(chartPointModel, layer, chart) -> UIView? in
            let width: CGFloat = 0.5
            let viewFrame = CGRect(x: chart.contentView.bounds.minX, y: chartPointModel.screenLoc.y - width / 2, width: chart.contentView.bounds.size.width, height: width)
            
            let v = UIView(frame: viewFrame)
            v.backgroundColor = FitFiColor
            return v
        })
        
        let highlightLayer = ChartPointsTouchHighlightLayer(
            xAxisLayer: xAxisLayer,
            yAxisLayer: yAxisLayer,
            chartPoints: IOBPoints,
            tintColor: FitFiColor,
            labelCenterY: chartSettings.top,
            gestureRecognizer: chartLongPressGestureRecognizer,
            onCompleteHighlight: nil
        )
        
        let layers: [ChartLayer?] = [
            gridLayer,
            xAxisLayer,
            yAxisLayer,
            zeroGuidelineLayer,
            highlightLayer,
            IOBArea,
            IOBLine,
            ]
        
        return Chart(frame: frame, innerFrame: coordsSpace.chartInnerFrame, settings: chartSettings, layers: layers.compactMap { $0 })
    }
    
    
    
}
private extension ChartPointsTouchHighlightLayer {
    
    convenience init(
        xAxisLayer: ChartAxisLayer,
        yAxisLayer: ChartAxisLayer,
        chartPoints: [T],
        tintColor: UIColor,
        labelCenterY: CGFloat = 0,
        gestureRecognizer: UILongPressGestureRecognizer? = nil,
        onCompleteHighlight: (()->Void)? = nil
        ) {
        self.init(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, chartPoints: chartPoints, gestureRecognizer: gestureRecognizer, onCompleteHighlight: onCompleteHighlight,
                  modelFilter: { (screenLoc, chartPointModels) -> ChartPointLayerModel<T>? in
                    if let index = chartPointModels.map({ $0.screenLoc.x }).findClosestElementIndexToValue(screenLoc.x) {
                        return chartPointModels[index]
                    } else {
                        return nil
                    }
        },
                  viewGenerator: { (chartPointModel, layer, chart) -> U? in
                    let containerView = U(frame: chart.contentView.bounds)
                    
                    let xAxisOverlayView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 3 + containerView.frame.size.height), size: xAxisLayer.frame.size))
                    xAxisOverlayView.backgroundColor = UIColor.white
                    xAxisOverlayView.isOpaque = true
                    containerView.addSubview(xAxisOverlayView)
                    
                    let point = ChartPointEllipseView(center: chartPointModel.screenLoc, diameter: 16)
                    point.fillColor = tintColor.withAlphaComponent(0.5)
                    containerView.addSubview(point)
                    
                    if let text = chartPointModel.chartPoint.y.labels.first?.text {
                        let label = UILabel()
                        if #available(iOS 9.0, *) {
                            label.font = UIFont.monospacedDigitSystemFont(ofSize: 15, weight: .bold)
                        } else {
                            label.font = UIFont.systemFont(ofSize: 15)
                        }
                        
                        label.text = text
                        label.textColor = tintColor
                        label.textAlignment = .center
                        label.sizeToFit()
                        label.frame.size.height += 4
                        label.frame.size.width += label.frame.size.height / 2
                        label.center.y = containerView.frame.origin.y
                        label.center.x = chartPointModel.screenLoc.x
                        label.frame.origin.x = min(max(label.frame.origin.x, containerView.frame.origin.x), containerView.frame.maxX - label.frame.size.width)
                        label.frame.origin.makeIntegralInPlaceWithDisplayScale(chart.view.traitCollection.displayScale)
                        label.layer.borderColor = tintColor.cgColor
                        label.layer.borderWidth = 1 / chart.view.traitCollection.displayScale
                        label.layer.cornerRadius = label.frame.size.height / 2
                        label.backgroundColor = UIColor.white
                        
                        containerView.addSubview(label)
                    }
                    
                    if let text = chartPointModel.chartPoint.x.labels.first?.text {
                        let label = UILabel()
                        label.font = axisLabelSettings.font
                        label.text = text
                        label.textColor = axisLabelSettings.fontColor
                        label.sizeToFit()
                        label.center = CGPoint(x: chartPointModel.screenLoc.x, y: xAxisOverlayView.center.y)
                        label.frame.origin.makeIntegralInPlaceWithDisplayScale(chart.view.traitCollection.displayScale)
                        
                        containerView.addSubview(label)
                    }
                    
                    return containerView
        }
        )
    }
}


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
//    func oneMonthSelected()
//    {
//        //for calculate seven days
//        let calendar = NSCalendar.current
//
//        let now = NSDate()
//
//        // let sevenDaysAgo = calendar.dateByAddingUnit(.Day, value: -7, toDate: now, options: NSCalendar.Options())!
//        // let startDate = calendar.startOfDayForDate(sevenDaysAgo)
//        let predicate = NSPredicate(format:"(end >= %@) AND (start < %@)", now, now)
//
//        //        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
//        //        fetchRequest.sortDescriptors = [sortDescriptor]
//
//        do {
//            exerciseHistoryArray = try context.fetch(Exercise_History.fetchRequest())
//
//        } catch {
//            print("Loading Exercises Error: \(error)")
//        }
//    }
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


