//
//  WorkoutHelper.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-11-19.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import Foundation

struct CurrentWorkoutExercise {
    var name: String
    var category: String
    var calorie: Int16
    var setArray: [Int16]
    var setDoneArray: [Bool]
    var weightArray: [Int16]
    var done: Bool
}


struct CurrentWorkoutUpdater {
    var deviceWeight = ""
    var currentExerciseName = ""
    var currentExerciseIndex = 0
    var totalCurrentExercise = 0
    
    var currentSetIndex = 0
    var totalSet4Exercise = 0
    
    var currentCount = 0
    var currentRep4Set: Int16 = 0
    
    var workoutFinished: Bool = false
}

struct CurrentFreeFormUpdater {
    var device = ""
    var exercise = ""
    var count = 0
}
