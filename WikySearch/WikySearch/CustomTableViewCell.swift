//
//  CustomTableViewCell.swift
//  WikySearch
//
//  Created by Digital-06 on 9/21/19.
//  Copyright © 2019 Supun Srilal-COBSCComp171p-005. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var desView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
