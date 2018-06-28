//
//  RealmData.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-06-27.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import Foundation
import RealmSwift

class RealmData: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
    
}
