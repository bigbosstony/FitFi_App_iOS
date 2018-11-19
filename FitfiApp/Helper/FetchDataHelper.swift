//
//  FetchDataHelper.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-11-15.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class FetchDataHelper: NSObject {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func loadDemoRoutine(with name: String) -> [Routine] {
        var routine = [Routine]()
        
        let alphaRoutineRequest: NSFetchRequest<Routine> = Routine.fetchRequest()
        alphaRoutineRequest.predicate = NSPredicate(format: "name = %@", "\(name)")
        
        do {
            routine = try context.fetch(alphaRoutineRequest)
            return routine
        } catch {
            print(error)
        }
        return routine
    }
}


