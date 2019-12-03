//
//  TherapistTableViewCell.swift
//  iOS Interview
//
//  Created by Shiv Kalola on 11/7/19.
//  Copyright © 2019 Talkspace. All rights reserved.
//

import UIKit

class TherapistTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pHdSinceLabel: UILabel!
    @IBOutlet weak var onDutyLabel: UILabel!
    
    func render(_ item: ListViewModel.DataItem) {
        nameLabel.text = item.name
        pHdSinceLabel.text = item.pHdSince
        onDutyLabel.text = item.onDuty
    }
    
    static var nib: UINib {
        return UINib(nibName: "TherapistTableViewCell", bundle: nil)
    }
}
