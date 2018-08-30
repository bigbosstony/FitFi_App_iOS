//
//  NewRoutineTableViewCell.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-07-11.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit

class NewRoutineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var setTextField: UITextField!
    @IBOutlet weak var repTextField: UITextField!
    @IBOutlet weak var exerciseName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setTextField.keyboardType = UIKeyboardType.numberPad
        repTextField.keyboardType = UIKeyboardType.numberPad
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    @objc func nextButtonPressed(view: UIView) {
//        print("next button pressed")
//        
//    }
//    
//    @objc func dismissKeyboard() {
//        self.endEditing(true)
//    }


}

