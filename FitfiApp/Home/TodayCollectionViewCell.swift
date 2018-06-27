//
//  TodayCollectionViewCell.swift
//  FitfiApp
//
//  Created by Yan Yu on 2018-06-08.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit

class TodayCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var scheduledLabel: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthConstraint.constant = screenWidth - (2 * 15)
        
    }
}
