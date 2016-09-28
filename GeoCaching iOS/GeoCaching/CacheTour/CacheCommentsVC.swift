//
//  CacheCommentsVC.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 01.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import UIKit

class CacheCommentsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var cache: Cache!
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        if let nc = navigationController as? CacheNC {
            cache = nc.cache
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topConstraint.constant = (navigationController?.navigationBar.frame.size.height)! - 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("Comments from other Users", comment: "Comments")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cache.logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellLog", for: indexPath) as! CellLogs
        if let date = cache.logs[indexPath.row].date {
            cell.labelFounder.text = "\(cache.logs[indexPath.row].type) · \(cache.logs[indexPath.row].finder) · \(formatter.string(from: date))"
        } else {
            cell.labelFounder.text = "\(cache.logs[indexPath.row].type) · \(cache.logs[indexPath.row].finder))"
        }
        cell.labelLog.text = cache.logs[indexPath.row].text
        return cell
    }
}
