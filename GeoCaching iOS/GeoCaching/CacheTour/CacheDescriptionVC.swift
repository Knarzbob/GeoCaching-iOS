//
//  CacheDescriptionVC.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 01.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import UIKit

class CacheDescriptionVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var cellShortDescription: CellZweiLabel!
    var cellLongDescription: CellLabel!
    var cellHints: CellLabel!
    var cellShowHints: CellLabel!
    var cache: Cache!
    var showHints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let nc = navigationController as? CacheNC {
            cache = nc.cache
        }
        
        createCells()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        populateCells()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topConstraint.constant = (navigationController?.navigationBar.frame.size.height)! - 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cache.encodedHints.isEmpty ? 2 : 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2: return showHints ? 2 : 1
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return NSLocalizedString("Short description", comment: "Short description")
        case 1: return NSLocalizedString("Description", comment: "Description")
        default: return NSLocalizedString("Additional Hints", comment: "Additional Hints")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: return cellShortDescription
        case 1: return cellLongDescription
        case 2: return indexPath.row == 0 ? cellShowHints : cellHints
        default: return cellHints
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 2 {
            showHints = showHints ? false : true
            tableView.reloadSections([indexPath.section], with: .none)
        }
    }
    
    func createCells() {
        cellShortDescription = tableView.dequeueReusableCell(withIdentifier: "CellZweiLabel") as! CellZweiLabel
        cellShortDescription.labelTop.text = "\(cache.containerRaw) | \(cache.name)"
        if !cache.shortDescIsHtml {
            cellShortDescription.labelBottom.text = cache.shortDesc
        }
        
        cellLongDescription = tableView.dequeueReusableCell(withIdentifier: "CellLabel") as! CellLabel
        if !cache.longDescIsHtml {
            cellLongDescription.labelContent.text = cache.longDesc
        }
        
        cellShowHints = tableView.dequeueReusableCell(withIdentifier: "CellLabel") as! CellLabel
        cellShowHints.labelContent.text = NSLocalizedString("Show additional hints…", comment: "Show additional hints…")
        cellShowHints.selectionStyle = .default
        
        cellHints = tableView.dequeueReusableCell(withIdentifier: "CellLabel") as! CellLabel
        cellHints.labelContent.text = cache.encodedHints
    }
    
    func populateCells() {
        if cache.shortDescIsHtml {
            let shortDesc = cache.shortDesc
            DispatchQueue.global(attributes: .qosUserInitiated).async {
                let attributedText = shortDesc.html2AttributedString
                DispatchQueue.main.sync {
                    self.cellShortDescription.labelBottom.attributedText = attributedText
                    self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
                }
            }
        }
        
        if cache.longDescIsHtml {
            let longDesc = cache.longDesc
            DispatchQueue.global(attributes: .qosUserInitiated).async {
                let attributedText = longDesc.html2AttributedString
                DispatchQueue.main.sync {
                    self.cellLongDescription.labelContent.attributedText = attributedText
                    self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
                }
            }
        }
    }
}
