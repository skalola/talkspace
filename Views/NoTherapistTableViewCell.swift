//
//  NoTherapistTableViewCell.swift
//  iOS Interview
//
//  Created by Shiv Kalola on 11/26/19.
//  Copyright © 2019 Talkspace. All rights reserved.
//

import Foundation
import UIKit

class NoTherapistTableViewCell: UITableViewCell {

    @IBOutlet weak var noTherapistLabel: UILabel!
    
    static let nib = UINib(nibName: "NoTherapistTableViewCell", bundle: nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
