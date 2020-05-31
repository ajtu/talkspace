//
//  TherapistTableViewCell.swift
//  iOS Interview
//
//  Created by Alvin Tu on 10/19/19.
//  Copyright © 2019 Talkspace. All rights reserved.
//

import UIKit

class TherapistTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var primaryLicenseLabel: UILabel!
    @IBOutlet weak var onDutyLabel: UILabel!
    @IBOutlet weak var shiftTimeLabel: UILabel!
    @IBOutlet weak var timeUntilShiftEndsOrStartsLabel: UILabel!
    
    var therapistViewModel: TherapistViewModel! {
        didSet {
            nameLabel?.text = therapistViewModel.nameLabelString
            primaryLicenseLabel?.text = therapistViewModel.primaryLicenseLabelString
            shiftTimeLabel?.text = therapistViewModel.shiftTimeLabelString
            timeUntilShiftEndsOrStartsLabel?.text = therapistViewModel.timeUntilShiftEndsOrStartsLabelString
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
