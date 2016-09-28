//
//  CellZweiLabel.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 02.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import UIKit

class CellZweiLabel: UITableViewCell {

    @IBOutlet weak var labelTop: UILabel!
    @IBOutlet weak var labelBottom: UILabel!
    
    var visible = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
