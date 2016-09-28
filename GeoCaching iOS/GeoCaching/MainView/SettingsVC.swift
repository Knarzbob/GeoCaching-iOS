//
//  SettingsVC.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 02.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import UIKit
import Mapbox

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, GPXXMLParserDelegate {

    //MARK: - Variablen
    @IBOutlet weak var tableView: UITableView!
    
    let formatter = DateFormatter()
    var cellMakeMapOffline: CellSwitch!
    var cellUpdateMap: CellZweiLabel!
    var cellUpdateGPX: CellActivityIndicator!
    var cellTutorial: CellEinLabel!
    var cellAppInfo: CellAppInfo!
    
    //MARK: - App-Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        title = NSLocalizedString("Settings", comment: "Title For Settings View")
        
        createCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        tableView.reloadData()
    }
    
    //MARK: - TableView-Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return UserDefaults.standard.bool(forKey: "MapOffline") ? 4 : 3
        default: return 1
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return NSLocalizedString("General", comment: "General")
        default: return NSLocalizedString("About this app", comment: "About this app")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let gpxParsedDate = UserDefaults.standard.object(forKey: "MapUpdated") as? Date {
            cellUpdateMap.labelBottom.text = NSLocalizedString("Last update:", comment: "Last update:") + " \(formatter.string(from: gpxParsedDate))"
        } else {
            cellUpdateMap.labelBottom.text = ""
        }
        if let gpxParsedDate = UserDefaults.standard.object(forKey: "GPXParsed") as? Date {
            cellUpdateGPX.labelBottom.text = NSLocalizedString("Last update:", comment: "Last update:") + " \(formatter.string(from: gpxParsedDate))"
        } else {
            cellUpdateGPX.labelBottom.text = ""
        }
        cellMakeMapOffline.switcher.isOn = UserDefaults.standard.bool(forKey: "MapOffline")
        cellMakeMapOffline.switcher.isEnabled = !UserDefaults.standard.bool(forKey: "MapOffline")
        cellUpdateMap.visible = UserDefaults.standard.bool(forKey: "MapOffline")

        switch (indexPath.section, indexPath.row) {
        case (0,0): return cellMakeMapOffline
        case (0,1):
            if cellUpdateMap.visible {
                return cellUpdateMap
            } else {
                return cellUpdateGPX
            }
        case (0,2):
            if cellUpdateMap.visible {
                return cellUpdateGPX
            } else {
                return cellTutorial
            }
        case (0,3):
            return cellTutorial
        default: return cellAppInfo
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        case (0,0): return
        case (0,1):
            if cellUpdateMap.visible {
                toMapUpdate()
            } else {
                updateGPX()
            }
        case (0,2):
            if cellUpdateMap.visible {
                updateGPX()
            } else {
                toGeocacheTutorial()
            }
        case (0,3): toGeocacheTutorial()
        default: openSafari(with: URL(string: "http://www.fhws.de/")!)
        }
    }
    
    func createCells() {
        cellMakeMapOffline = tableView.dequeueReusableCell(withIdentifier: "CellSwitch") as! CellSwitch
        cellMakeMapOffline.label.text = NSLocalizedString("Activate Offline-Maps", comment: "Activate Offline-Maps")
        cellMakeMapOffline.switcher.addTarget(self, action: #selector(toMapUpdate), for: .valueChanged)
        cellMakeMapOffline.selectionStyle = .none
        cellUpdateMap = tableView.dequeueReusableCell(withIdentifier: "CellZweiLabel") as! CellZweiLabel
        cellUpdateMap.labelTop.text = NSLocalizedString("Update map…", comment: "Update map")
        cellUpdateMap.labelBottom.text = ""
        cellUpdateMap.visible = UserDefaults.standard.bool(forKey: "MapOffline")
        cellUpdateGPX = tableView.dequeueReusableCell(withIdentifier: "CellActivityIndicator") as! CellActivityIndicator
        cellUpdateGPX.labelTop.text = NSLocalizedString("Update caches…", comment: "Update caches")
        cellUpdateGPX.activityIndicator.hidesWhenStopped = true
        cellTutorial = tableView.dequeueReusableCell(withIdentifier: "CellEinLabel") as! CellEinLabel
        cellTutorial.label.text = NSLocalizedString("Restart Geocaching-Tutorial", comment: "Restart Tutorial")
        cellAppInfo = tableView.dequeueReusableCell(withIdentifier: "CellAppInfo") as! CellAppInfo
        cellAppInfo.labelAppInfo.text = "Version 1.0\n\n" + NSLocalizedString("This app is a project of students from the university of applied science Würzburg/Schweinfurt.", comment: "About")
    }
    
    func toMapUpdate() {
        let optionenAlert = UIAlertController(title: NSLocalizedString("Update map", comment: "Update map"), message: NSLocalizedString("An Update of the map material requires a lot of your data volume (~ 100MB).", comment: "Update map Desc") + "\n\n" + NSLocalizedString("Please ensure you are connected to a WiFi-Hotspot.", comment: "Update map Desc2"), preferredStyle: .alert)
        optionenAlert.addAction(UIAlertAction(title: NSLocalizedString("Update", comment: "Update"), style: .default, handler: { (action) -> Void in
            self.performSegue(withIdentifier: "toMapUpdate", sender: self)
        }))
        optionenAlert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: { (action) -> Void in
            self.cellMakeMapOffline.switcher.isOn = false
        }))
        optionenAlert.modalPresentationStyle = .popover
        self.present(optionenAlert, animated: true, completion: nil)
    }
    
    func updateGPX() {
        let gpxparser = GPXXMLParser()
        gpxparser.delegate = self
//        gpxparser.downloadAndParseGPX(with: URL(string: "https://www.dropbox.com/s/j552faubt1m029z/18137195_Ochsenfurt500.gpx?dl=1")!)
        gpxparser.parseGPXFile(named: "Ochsenfurt")
        cellUpdateGPX.accessoryType = .none
        cellUpdateGPX.activityIndicator.startAnimating()
        UIApplication.shared().beginIgnoringInteractionEvents()
    }
    
    func toGeocacheTutorial() {
        performSegue(withIdentifier: "toTourVC", sender: self)
    }
    
    func openSafari(with url: URL) {
        UIApplication.shared().openURL(url)
    }
    
    //MARK: - GPX XML Parser Delegate
    func didFinishUpdateDatabase() {
        UserDefaults.standard.set(Date(), forKey: "GPXParsed")
        cellUpdateGPX.accessoryType = .disclosureIndicator
        cellUpdateGPX.activityIndicator.stopAnimating()
        UIApplication.shared().endIgnoringInteractionEvents()
        tableView.reloadData()
    }
    
    func downloadDidFinish() {
        cellUpdateGPX.labelBottom.text = NSLocalizedString("Download finished. Parsing…", comment: "Download abgeschlossen. Datei wird gelesen…")
    }
    
    func downloadDidFail() {
        cellUpdateGPX.labelBottom.text = NSLocalizedString("An error occured. Please try again.", comment: "Fehler beim Download.")
        cellUpdateGPX.accessoryType = .disclosureIndicator
        cellUpdateGPX.activityIndicator.stopAnimating()
        UIApplication.shared().endIgnoringInteractionEvents()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toTourVC" {
            UserDefaults.standard.set(true, forKey: "TourFromSettingsStarted")
        }
        
        //Damit beim MapUpdate als Back-Button nicht 'Einstellungen' sondern 'Abbrechen' steht.
        let backItem = UIBarButtonItem()
        backItem.title = NSLocalizedString("Cancel", comment: "Cancel")
        navigationItem.backBarButtonItem = backItem
    }
}
