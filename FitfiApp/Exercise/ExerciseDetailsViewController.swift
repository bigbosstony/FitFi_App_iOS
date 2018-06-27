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
    @IBOutlet weak var favButton: UIBarButtonItem!
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet var aboutTableView: UITableView!
    
    var views: [UIView]!
    
    @IBOutlet var aboutView: UIView!
    @IBOutlet var historyView: UIView!
    @IBOutlet var progressView: UIView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var selectedExercise: Exercise? {
        didSet {
            print("⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎⬇︎")
            print(selectedExercise!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aboutTableView.delegate = self
        aboutTableView.dataSource = self
        
        aboutTableView.register(UINib(nibName: "AboutInstructionTableViewCell", bundle: nil), forCellReuseIdentifier: "aboutInstructionCell")

        views = [UIView]()
        
        views.append(aboutView)
        views.append(historyView)
        views.append(progressView)

        for view in views {
            viewContainer.addSubview(view)
        }
        viewContainer.bringSubview(toFront: views[0])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = selectedExercise?.name
        favButton.image = (selectedExercise?.favorite)! ? UIImage(named: "Glyphs/Favorited") : UIImage(named: "Glyphs/Favorite")
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.setValue(false, forKey: "hidesShadow")

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
        self.viewContainer.bringSubview(toFront: views[sender.selectedSegmentIndex])

    }
}

//TableView
extension ExerciseDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == aboutTableView {
            return instructions.count + 1
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
                
                cell.instructionLabel.text = instructions[indexPath.row - 1]
                return cell
            }
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "aboutInstructionCell", for: indexPath) as! AboutInstructionTableViewCell
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == aboutTableView {
            if indexPath.row == 0 {
                return 230.0
            } else {
                return UITableViewAutomaticDimension
            }
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
}
