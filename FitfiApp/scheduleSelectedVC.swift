//
//  scheduleSelectedVC.swift
//  FitfiApp
//
//  Created by Harsh_Dev on 28/08/18.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import Foundation
import UIKit
class scheduleSelectedVC:UIViewController{
    var scheduleArr:[Schedule]?{
    
        didSet{
            
            print(scheduleArr)
        }
    }
    var date:Date?{
        didSet{
           
            print(date)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
