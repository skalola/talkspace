//
//  NoTherapistTableViewCell.swift
//  iOS Interview
//
//  Created by Shiv Kalola on 11/26/19.
//  Copyright © 2019 Talkspace. All rights reserved.
//

import UIKit

class NoTherapistTableViewCell: UITableViewCell {

    @IBOutlet weak var noTherapistLabel: UILabel!
    
    func render(_ item: ListViewModel.EmptyItem) {
        noTherapistLabel.text = item.title
    }
    
    static var nib: UINib {
        return UINib(nibName: "NoTherapistTableViewCell", bundle: nil)
    }
}
