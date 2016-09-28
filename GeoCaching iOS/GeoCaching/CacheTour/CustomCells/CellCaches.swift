//
//  CellCaches.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 01.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import UIKit

class CellCaches: UITableViewCell {

    @IBOutlet weak var labelCache: UILabel!
    @IBOutlet weak var labelFound: UILabel!
    var cache: Cache!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}