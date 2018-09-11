//
//  CalendarTableViewCell.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-07-10.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

    @IBOutlet weak var dayOfWeek: UILabel!
    @IBOutlet weak var dayOfMonth: UILabel!
    @IBOutlet weak var todayMarker: UIView!
    
    @IBOutlet weak var timeImageView: UIImageView!
    @IBOutlet weak var exerciseImageView: UIView!
    @IBOutlet weak var estimatedTime: UILabel!
    @IBOutlet weak var totalExercise: UILabel!
    @IBOutlet weak var routineName: UILabel!
    @IBOutlet weak var detailView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
