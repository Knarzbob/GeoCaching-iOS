//
//  ProfileVC.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 01.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import UIKit
import RealmSwift

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var caches: Results<Cache>!
    var chosenCache: Cache!
    var chosenCacheIndexPath: IndexPath!
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Profile", comment: "Title For Profile View")
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        loadCaches()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadCaches()
        tableView.reloadData()
    }
    
    func loadCaches() {
        caches = realm.allObjects(ofType: Cache.self).filter(using: Predicate(format: "isFound = true")).sorted(onProperty: "foundDate", ascending: false)
        print("Caches.count = \(caches.count)")
    }
    
    //MARK: TableView-Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if caches.count != 0 {
            return caches.count
        } else { return 1 }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("Your found caches", comment: "Your found caches") + " (\(caches.count))"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellCaches", for: indexPath) as! CellCaches
        if caches.count != 0 {
            cell.labelCache.text = "\(caches[indexPath.row].urlname)"
            if let date = caches[indexPath.row].foundDate {
                cell.labelFound.text = NSLocalizedString("Found on", comment: "Found on") + " \(formatter.string(from: date))"
            } else {
                cell.labelFound.text = ""
            }
            cell.cache = caches[indexPath.row]
            cell.selectionStyle = .none
            cell.isUserInteractionEnabled = true
        } else {
            cell.labelCache.text = NSLocalizedString("You haven't found any caches yet…", comment: "No caches found")
            cell.labelFound.text = ""
            cell.selectionStyle = .none
            cell.isUserInteractionEnabled = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if caches.count != 0 {
            let delete = UITableViewRowAction(style: .default, title: NSLocalizedString("Delete", comment: "Delete")) { (action, index) -> Void in
                let cell = tableView.cellForRow(at: indexPath) as! CellCaches
                self.chosenCache = cell.cache
                self.chosenCacheIndexPath = indexPath
                self.showHint(title: NSLocalizedString("Delete cache", comment: "Delete cache"), info: NSLocalizedString("Are you sure you want to delete the cache from your List?", comment: "Delete cache warning") + "\n\n" + NSLocalizedString("It will be placed back on the map to be found later.", comment: "Delete cache warning2"))
            }
            return [delete]
        } else { return nil }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showHint(title: String, info: String) {
        NSLog("\(info)")
        let alert = UIAlertController(title: title, message: info, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes!", comment: "Yes!"), style: .default, handler: { (action) in
            try! realm.write {
                self.chosenCache.isActivated = false
                self.chosenCache.isFound = false
                self.chosenCache.foundDate = nil
            }
            self.loadCaches()
            self.tableView.reloadData()
            
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("No.", comment: "No."), style: .cancel, handler: nil))
        alert.modalPresentationStyle = .popover
        self.present(alert, animated: true, completion: nil)
    }
}
