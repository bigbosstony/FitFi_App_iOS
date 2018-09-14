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
    @IBOutlet weak var detailCollectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension CalendarTableViewCell
{
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDelegate & UICollectionViewDataSource>
        (_ dataSourceDelegate : D ,forRow row:Int)
    
    {
        detailCollectionView.dataSource = dataSourceDelegate
        detailCollectionView.delegate = dataSourceDelegate
        detailCollectionView.reloadData()
    }
}
