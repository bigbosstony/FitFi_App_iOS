//
//  ExerciseDetailsViewController.swift
//  FitfiApp
//
//  Created by Yan Yu on 2018-06-15.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit
import CoreData

class ExerciseDetailsViewController: UIViewController {
    
    // Data
    let FitFiColor = UIColor(red: 213, green: 95, blue: 31)
    @IBOutlet weak var favButton: UIBarButtonItem!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet var aboutTableView: UITableView!
    var views: [UIView]!
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet var aboutView: UIView!
    @IBOutlet var historyView: UIView!
    @IBOutlet var progressView: UIView!
    
  
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var navFlag = 0
    var instructionIsProvided = false
    var instructionArray = [String]()
    var fromStats:Int?{
        didSet{
           navFlag = 1
            print("from Stats")
        }
    }
    // Get Data from Exercise Tableview VC
    var selectedExercise: Exercise? {
        didSet {
        //   self.titleBar.title = selectedExercise!.name
            loadInfo()
            print(selectedExercise!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = FitFiColor
        aboutTableView.delegate = self
        aboutTableView.dataSource = self
        // Register Customized cell for aboutTableView
        aboutTableView.register(UINib(nibName: "AboutInstructionTableViewCell", bundle: nil), forCellReuseIdentifier: "aboutInstructionCell")

        // Add three views to viewContainer
        views = [UIView]()
        
        views.append(aboutView)
        views.append(historyView)
        views.append(progressView)

        for view in views {
            viewContainer.addSubview(view)
        }
        // Bring the first one to front as default
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = selectedExercise?.name
        if(navFlag == 1){
             viewContainer.bringSubviewToFront(views[2])
             segment.selectedSegmentIndex = 2
            
            
        }
        else{
             viewContainer.bringSubviewToFront(views[0])
        }
        
        favButton.image = (selectedExercise?.favorite)! ? UIImage(named: "Glyphs/Favorited") : UIImage(named: "Glyphs/Favorite")
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.setValue(false, forKey: "hidesShadow")

    }

    func loadInfo() {
        if selectedExercise?.instructions != nil {
            instructionIsProvided = true
            instructionArray = (selectedExercise?.instructions?.components(separatedBy: "\\n"))!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func favButtonPressed(_ sender: UIBarButtonItem) {
        selectedExercise?.favorite = !(selectedExercise?.favorite)!
        favButton.image = (selectedExercise?.favorite)! ? UIImage(named: "Glyphs/Favorited") : UIImage(named: "Glyphs/Favorite")
        saveExercise()
    }
    
    func saveExercise() {
        do {
            try context.save()
        } catch {
            print("\(error)")
        }
    }
    
    // Segmented Control, change views
    @IBAction func switchViewAction(_ sender: UISegmentedControl) {
        self.viewContainer.bringSubviewToFront(views[sender.selectedSegmentIndex])

    }
}

//MARK: - TableView DataSource
extension ExerciseDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == aboutTableView {
            if instructionIsProvided == true {
                return instructionArray.count + 1
            } else {
                return 2
            }
        }
        else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == aboutTableView {
            if indexPath.row == 0 {
                let cell = Bundle.main.loadNibNamed("AboutImageTableViewCell", owner: self, options: nil)?.first as! AboutImageTableViewCell
                if let image = selectedExercise?.image {
                    cell.imageView1.image = UIImage(imageLiteralResourceName: image)
                }
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "aboutInstructionCell", for: indexPath) as! AboutInstructionTableViewCell
                if instructionIsProvided == true {
                    cell.instructionLabel.text = instructionArray[indexPath.row - 1]
                } else {
                    cell.instructionLabel.text = "No Instructons"
                }
                return cell
            }
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "aboutInstructionCell", for: indexPath) as! AboutInstructionTableViewCell
            //Remove the style
            cell.selectionStyle = UITableViewCell.SelectionStyle.none

            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == aboutTableView {
            if indexPath.row == 0 {
                return 230.0
            } else {
                return UITableView.automaticDimension
            }
        }
        else {
            return UITableView.automaticDimension
        }
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
        
    }
}
