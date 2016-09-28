//
//  CacheInformationVC.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 01.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import Foundation

import UIKit
import Mapbox

class CacheInformationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    let formatter = DateFormatter()
    var cache: Cache!
    var cellDifficulty: CellInfoImage!
    var cellTerrain: CellInfoImage!
    var cellSize: CellInfoImage!
    var cellPlaced: CellInfo!
    var cellPlacedBy: CellInfo!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let nc = navigationController as? CacheNC {
            cache = nc.cache
        }
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        createCells()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topConstraint.constant = (navigationController?.navigationBar.frame.size.height)! - 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "N \(getNumbersFormatted(cache.latitude)) | E \(getNumbersFormatted(cache.longitude))"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath as NSIndexPath).row {
        case 0: return cellDifficulty
        case 1: return cellTerrain
        case 2: return cellSize
        case 3: return cellPlaced
        default: return cellPlacedBy
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func getNumbersFormatted(_ number: CLLocationDegrees) -> String {
        let stringArray = "\(number)".characters.split(separator: ".").map(String.init)
        var ersteZwei = ""
        if stringArray[1].characters.count >= 2 {
            let ersteZweiRange = stringArray[1].startIndex..<stringArray[1].index(stringArray[1].startIndex, offsetBy: 2)
            ersteZwei = stringArray[1][ersteZweiRange]
        }
        
        
        if stringArray[1].characters.count >= 5 {
            let letzteRange = stringArray[1].index(stringArray[1].startIndex, offsetBy: 2)..<stringArray[1].index(stringArray[1].startIndex, offsetBy: 5)
            let rest = stringArray[1][letzteRange]
            return "\(stringArray[0])° \(ersteZwei).\(rest)"
        } else if stringArray[1].characters.count == 4 {
            let letzteRange = stringArray[1].index(stringArray[1].startIndex, offsetBy: 2)..<stringArray[1].index(stringArray[1].startIndex, offsetBy: 4)
            let rest = stringArray[1][letzteRange]
            return "\(stringArray[0])° \(ersteZwei).\(rest)"
        } else if stringArray[1].characters.count == 3 {
            let letzteRange = stringArray[1].index(stringArray[1].startIndex, offsetBy: 2)
            let rest = stringArray[1][letzteRange]
            return "\(stringArray[0])° \(ersteZwei).\(rest)"
        } else if stringArray[1].characters.count < 3 {
            return "\(stringArray[0])° \(ersteZwei)"
        }
        return "\(stringArray[0])"
    }
    
    func createCells() {
        cellDifficulty = tableView.dequeueReusableCell(withIdentifier: "CellInfoImage") as! CellInfoImage
        cellDifficulty.labelAttribute.text = NSLocalizedString("Difficulty", comment: "Difficulty")
        cellDifficulty.imgView.image = chooseStarImage(cache.difficulty)
        if let img = cellDifficulty.imgView.image {
            cellDifficulty.imgView.image = img.withRenderingMode(.alwaysTemplate)
        }
        cellDifficulty.imgView.tintColor = Farbe.cacheBlau
        cellTerrain = tableView.dequeueReusableCell(withIdentifier: "CellInfoImage") as! CellInfoImage
        cellTerrain.labelAttribute.text = NSLocalizedString("Terrain", comment: "Terrain")
        cellTerrain.imgView.image = chooseStarImage(cache.terrain)
        if let img = cellTerrain.imgView.image {
            cellTerrain.imgView.image = img.withRenderingMode(.alwaysTemplate)
        }
        cellTerrain.imgView.tintColor = Farbe.cacheBlau
        cellSize = tableView.dequeueReusableCell(withIdentifier: "CellInfoImage") as! CellInfoImage
        cellSize.labelAttribute.text = NSLocalizedString("Container-Size", comment: "Container-Size")
        cellSize.imgView.image = chooseSizeImage(cache.container)
        if let img = cellSize.imgView.image {
            cellSize.imgView.image = img.withRenderingMode(.alwaysTemplate)
        }
        
        cellSize.imgView.tintColor = Farbe.cacheBlau
        cellPlaced = tableView.dequeueReusableCell(withIdentifier: "CellInfo") as! CellInfo
        cellPlaced.labelAttribute.text = NSLocalizedString("Hidden on", comment: "Hidden on")
        if let time = cache.time {
            cellPlaced.labelValue.text = formatter.string(from: time)
        } else {
            cellPlaced.labelValue.text = NSLocalizedString("No information", comment: "No information")
        }
        cellPlacedBy = tableView.dequeueReusableCell(withIdentifier: "CellInfo") as! CellInfo
        cellPlacedBy.labelAttribute.text = NSLocalizedString("Hidden by", comment: "Hidden by")
        cellPlacedBy.labelValue.text = "\(cache.placedBy)"
    }
    
    func chooseStarImage(_ rating: Double) -> UIImage? {
        if rating <= 5.0 && rating > 0.0 {
            let imageName = "stars\(rating)"
            return UIImage(named: imageName)!
        } else {
            return nil
        }
        
    }
    
    func chooseSizeImage(_ container: Container) -> UIImage? {
        switch container {
        case .Large: return UIImage(named: "container_large")
        case .Regular: return UIImage(named: "container_regular")
        case .Small: return UIImage(named: "container_small")
        case .Micro: return UIImage(named: "container_micro")
        case .Other: return UIImage(named: "container_other")
        case .NotChosen: return UIImage(named: "container_notchosen")
        }
    }
}
