//
//  ChartStringFormatter.swift
//  FitfiApp
//
//  Created by Harsh_Dev on 27/09/18.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import Foundation
import UIKit
import Charts

class ChartStringFormatter: NSObject, IAxisValueFormatter {
    
    var nameValues: [String]!
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(describing: nameValues[Int(value)])
    }
}
