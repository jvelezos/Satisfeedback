//
//  DeviceTableViewCell.swift
//  Inexfeedback
//
//  Created by SMS Simple Mobile Solutions on 20/07/17.
//  Copyright © 2017 Bankity. All rights reserved.
//

import UIKit


class DeviceTableViewCell: UITableViewCell {

    @IBOutlet var `switch`: UISwitch!
    @IBOutlet var nameLbl: UILabel!
    var parent: DevicesViewController!
    var index: Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchPressed(_ sender: Any) {
        if(self.switch.isOn){
            parent.pressedSwitch(index: index, value: 1)
        }else{
            parent.pressedSwitch(index: index, value: 0)
        }
    }

    
}
