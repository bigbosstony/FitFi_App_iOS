//
//  Data.swift
//  FitfiApp
//
//  Created by Yan Yu on 2018-06-05.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import Foundation

let workout = [
    [
        "name" : "LEG AND GLUTES",
        "dayofWeek" : "TUESDAY",
        "date" : "MAY 22",
        "time" : "07:41 AM",
        "calorie" : "302 kcal",
        "volume" : "2213 lb",
        "duration" : "55m",
        "numberOfExercises" : "5"
    ],
    [
        "name" : "AFTERNOON WORKOUT",
        "dayofWeek" : "MONDAY",
        "date" : "MAY 21",
        "time" : "05:30 PM",
        "calorie" : "200 kcal",
        "volume" : "3422 lb",
        "duration" : "40m",
        "numberOfExercises" : "3"
    ],
    [
        "name" : "BACK",
        "dayofWeek" : "SUNDAY",
        "date" : "MAY 20",
        "time" : "09:00 AM",
        "calorie" : "602 kcal",
        "volume" : "6554 lb",
        "duration" : "75m",
        "numberOfExercises" : "7"
    ],
]

//let workout = [String]()

let sections = ["Favorite", "Discover"]


let items = [
    [
        "Barbell Squat",
        "Single Arm Row"
    ],
    [
        "Around the World",
        "Back Extension"
    ]
]

let Exercises = [
    [
        "name": "Hip Abduction Machine",
        "instructions": "1. Setup in an upright position with your back against the pad and your spine neutral. \n2. Exhale and push the legs apart as you open the pads. \n3. Once your hips are fully externally rotated, slowly return to the starting position. \n4. Repeat for the desired number of repetitions.",
        "image": "1"
    ],
    [
        "name": "Twisting Floor Crunch",
        "instructions": "1. The twisting floor crunch works the abs and obliques. Position a mat on the floor and lie down on the mat flat on your back. \n2. Pull your left leg up until your knee joint is at around 90 degrees. \n3. Now take your right leg and rest your ankle on your left knee. \n4. Start the exercise by touching the side of your head with your fingertips and raising your shoulder blades slightly off the mat. \n5. Crunch up, bringing your left elbow up to your right knee. \n6. Slowly lower back to starting position without letting your shoulder blades touch the floor. \nRepeat set for the opposite side of the body.",
        "image": "2"
    ],
    [
        "name": "Standing Wrist Curl Behind Back",
        "instructions": "1. Begin the exercise by selecting a barbell weight and holding it behind your back using an underhand grip (palms facing out). Your hands should be placed around shoulder width apart. \n2. Stand straight up with your feet shoulder width apart and look straight forward. Bending only at the wrists, let the barbell drop as far as possible. This is the starting position for the exercise. \n3. Slowly raise the barbell up as far as possible squeezing the forearm muscles at the top of the movement. Only your wrists should be moving. \n4. Pause, and then slowly lower the barbell back to the starting position. \n5. Repeat for desired reps.",
        "image": "3"
    ],
    [
        "name": "Straight Arm Lat Pull Down",
        "instructions": "1. Attach a wide grip handle to a cable stack and assume a standing position. \n2. Grasp the handle with a pronated grip (double overhand) at roughly shoulder width and lean forward slightly by hinging at the hips. \n3. Keep the elbow slightly flexed and initiate the movement by depressing the shoulder blades and extending the shoulders. \n4. Pull the bar to your thigh until the lats are fully contracted and then slowly lower under control. \n5. Repeat for the desired number of repetitions.",
        "image": "4"
    ],
    [
        "name": "Leg Extension",
        "instructions": "1. Select the desired resistance on the weight stack and insert the pin. \n2. Adjust the seat so that the knees are directly in line with the axis of the machine. \n3. Sit down and position your shins behind the pad at the base of the machine. \n4. Take a deep breath and extend your legs as you flex your quadriceps. \n5. As you lock out the knees, exhale to complete the repetition. \n6. Slowly lower your feet back to the starting position and repeat for the desired number of repetitions.",
        "image": "5"
    ],
    [
        "name" : "Zottman Curl",
        "instructions" : "1. Select the desired weight from the rack and assume a shoulder width stance. \n2. Using a supinated grip, take a deep breath and curl the dumbbells towards your shoulders. \n3. Once the biceps are fully shortened, rotate the forearms to a pronated position (palms down) and slowly lower the weight back to the starting position. \n4. Repeat for the desired number of repetitions.",
        "image" : "6"
    ],
    [
        "name" : "Incline Hammer Curl",
        "instructions" : "1. Set up for the incline hammer curl by setting the bench at a 30-45 degree incline and sitting a pair of dumbbells at the end. The lower the incline, the more challenging the exercise will be so 30 degrees is preferred. \n2. Sit on the bench, pick up the dumbbells and lay back with your back flat on the padding. \n3. You should be holding the dumbbells with an neutral grip, palms facing in towards your body. \n4. Take up the slack in your arms by slightly bending them, as this will put tension on the biceps. This is the starting position for the exercise. \n5. Keeping your elbows fixed, slowly curl the dumbbells up as far as possible. \n6. Squeeze the biceps at the top of the movement, and then slowly lower the weights back to the starting position. 7. Repeat for desired reps.",
        "image" : "7"
    ],
    [
        "name" : "Dumbbell Side Bends",
        "instructions" : "1. This exercise works the obliques. Grasp a set of dumbbells. Stand straight up with one dumbbell in each hand, palms facing in. \n2. Keep your feet firmly on the floor with a shoulder width stance. \n3. Keeping your back straight and your eyes facing forwards, bend down to the right as far as you can, then back up again. \n4. Without pausing at the top, bend down to the left. \n5. Repeat for desired reps.",
        "image" : "8"
    ]
    ,
    [
        "name" : "Hack Calf Raise",
        "instructions" : "1. Load the weight you want to use on a hack squat machine. \n2. Stand on the foot plate facing the machine with your chest on the back pad and shoulders under the shoulder pads. \n3. If you have a block available, put it on the foot plate an use it to stand on for extra range of motion. \n4. Push up and take the weight off the rack by releasing the safety. \n5. Keeping your legs straight, slowly raise your heels off the floor as far as possible. \n6. Pause, and then slowly lower back to the starting position without letting your heels fully rest on the foot plate. \n7. Repeat for desired reps.",
        "image" : "9"
    ],
    [
        "name" : "Pec Dec",
        "instructions" : "1. The pec dec is a great machine for isolating the chest. Before you start, adjust the seat height so that the bottom of the arm pads are about level with your chest when you're sitting on the machine. \n2. Select the weight you want to use on the stack. \n3. Sit on the machine, grasp the handles and/or place your forearms on the padding. Take the weight off the stack slightly. This is the starting position for the exercise. \n4. Keeping your body fixed, slowly bring the forearm pads or handles together. Don't let them touch. \n5. Squeeze the chest muscles for a count of 1-3, then slowly lower back to the starting position. \n6. Repeat for desired reps.",
        "image" : "10"
    ]
]

let noRoutineText = "You haven't favorited any routines yet. Go ahead and explore our preset routines or create your own. \n\nCustomized routines will be automatically added to your favorite."


