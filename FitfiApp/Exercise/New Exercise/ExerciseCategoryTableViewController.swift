//
//  ExerciseCategoryTableViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-08-01.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit
import CoreData

protocol ReceiveCategory {
    func categoryReceived(category name: String)
}

struct categoryData {
    var check: Bool
    var category: String
}

class ExerciseCategoryTableViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var delegate: ReceiveCategory?
    var categoryArray = [categoryData]()
    var categoryName: String?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Category"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        request.resultType = NSFetchRequestResultType.dictionaryResultType
        request.propertiesToFetch = ["category"]
        request.returnsDistinctResults = true
        
        do {
            var counter = 0
            let results = try context.fetch(request)
            for item in results as! [[String: String]] {
                if item["category"] == categoryName {
                    index = counter
                    let data = categoryData.init(check: true, category: item["category"]!)
                    categoryArray.append(data)
                } else {
                    let data = categoryData.init(check: false, category: item["category"]!)
                    categoryArray.append(data)
                }
                counter += 1
            }
        } catch {
            print("\(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCategoryTableViewCell", for: indexPath) as! ExerciseCategoryTableViewCell
        cell.textLabel?.text = categoryArray[indexPath.row].category
        cell.accessoryType = categoryArray[indexPath.row].check ? .checkmark : .none
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if index == nil {
            index = indexPath.row
            categoryArray[indexPath.row].check = true
            delegate?.categoryReceived(category: categoryArray[indexPath.row].category)
            
        } else if index == indexPath.row {
            categoryArray[indexPath.row].check = false
            delegate?.categoryReceived(category: "Select")
            index = nil
        } else {
            categoryArray[index!].check = false
            categoryArray[indexPath.row].check = true
            delegate?.categoryReceived(category: categoryArray[indexPath.row].category)
            index = indexPath.row
        }
        print(index)
        
//        let array = categoryArray.map { $0.check == true }
//        if array.contains(true) {
//            let index = array.index(of: true)
//            categoryArray[index!].check = false
//        }
        
        tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
