//
//  CellActivityIndicator.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 16.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import UIKit

class CellActivityIndicator: UITableViewCell {
    
    @IBOutlet weak var labelTop: UILabel!
    @IBOutlet weak var labelBottom: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
