//
//  TherapistTableViewCell.swift
//  iOS Interview
//
//  Created by Shiv Kalola on 11/7/19.
//  Copyright © 2019 Talkspace. All rights reserved.
//

import Foundation
import UIKit

class TherapistTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pHdSinceLabel: UILabel!
    @IBOutlet weak var onDutyLabel: UILabel!
    
    
    static let nib = UINib(nibName: "TherapistTableViewCell", bundle: nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
