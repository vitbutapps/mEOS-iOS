//
//  VBNetowrksTableViewCell.swift
//  MEOS
//
//  Created by Виталий on 02/01/2019.
//  Copyright © 2019 Vitaliy. All rights reserved.
//

import UIKit

class VBNetowrksTableViewCell: UITableViewCell {

    @IBOutlet weak var netName: UILabel!
    @IBOutlet weak var netURL: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
