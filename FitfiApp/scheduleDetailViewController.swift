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
class scheduleDetailViewController:UIViewController{
    var signal:Int?
    var array:[String] = []
    var routineArr:[Routine] = []
   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        print(signal!)
        if(signal! == 0)
        {
            fetchRoutine()
        }
    }
    func fetchRoutine(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Routine")
        do {
           routineArr = try context.fetch(fetchRequest) as! [Routine]
            
        } catch {
            print("Loading Exercises Error: \(error)")
        }
        for i in routineArr{
            array.append(i.name!)
        }
    }
    

}
