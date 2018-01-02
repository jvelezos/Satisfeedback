//
//  QuestionTableViewCell.swift
//  Inexfeedback
//
//  Created by SMS Simple Mobile Solutions on 11/07/17.
//  Copyright © 2017 Bankity. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

    @IBOutlet var textLbl: UILabel!
    var parent: QuestionViewController!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
