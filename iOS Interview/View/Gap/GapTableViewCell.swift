//
//  GapTableViewCell.swift
//  iOS Interview
//
//  Created by Alvin Tu on 10/21/19.
//  Copyright © 2019 Talkspace. All rights reserved.
//

import UIKit

class GapTableViewCell: UITableViewCell {
    @IBOutlet weak var gapLabel: UILabel!
    var gapViewModel: GapViewModel! {
        didSet {
            gapLabel?.text = gapViewModel.gapLabelString
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
