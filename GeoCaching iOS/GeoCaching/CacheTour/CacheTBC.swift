//
//  CacheTBC.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 01.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import UIKit
import RealmSwift

class CacheTBC: UITabBarController, UITabBarControllerDelegate {
    
    var cache: Cache!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        if let nc = navigationController as? CacheNC {
            cache = nc.cache
        }
        
        let informationView = storyboard?.instantiateViewController(withIdentifier: "CacheInformation")
        informationView?.tabBarItem = UITabBarItem(title: NSLocalizedString("Information", comment: "Information"), image: UIImage(named: "icon_info_inactive"), selectedImage: UIImage(named: "icon_info_active"))
        informationView?.tabBarItem.tag = 0
        
        let descriptionView = storyboard?.instantiateViewController(withIdentifier: "CacheDescription")
        descriptionView?.tabBarItem = UITabBarItem(title: NSLocalizedString("Description", comment: "Description"), image: UIImage(named: "icon_list_inactive"), selectedImage: UIImage(named: "icon_list_active"))
        descriptionView?.tabBarItem.tag = 1
        
        let commentsView = storyboard?.instantiateViewController(withIdentifier: "CacheComments")
        commentsView?.tabBarItem = UITabBarItem(title: NSLocalizedString("Comments", comment: "Comments"), image: UIImage(named: "icon_comment_inactive"), selectedImage: UIImage(named: "icon_comment_active"))
        commentsView?.tabBarItem.tag = 2
        
        let startView = storyboard?.instantiateViewController(withIdentifier: "CacheInformation")
        if cache.isActivated {
            startView?.tabBarItem = UITabBarItem(title: NSLocalizedString("Found!", comment: "Found!"), image: UIImage(named: "icon_check"), selectedImage: UIImage(named: "icon_check"))
            startView?.tabBarItem.tag = 4
        } else {
            startView?.tabBarItem = UITabBarItem(title: NSLocalizedString("Start!", comment: "Start!"), image: UIImage(named: "icon_start"), selectedImage: UIImage(named: "icon_start"))
            startView?.tabBarItem.tag = 3
        }
        
        setViewControllers([informationView!, descriptionView!, commentsView!, startView!], animated: false)
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 3 {
            try! realm.write {
                cache.isActivated = true
            }
            dismiss(animated: true, completion: nil)
            return
        }
        if item.tag == 4 {
            showHint(title: NSLocalizedString("Found that cache?", comment: "Found that cache?"), info: NSLocalizedString("Do you want to mark this cache as \'Found\'?", comment: "Found that cache description") + "\n\n" + NSLocalizedString("It will be displayed in your profile.", comment: "Found that cache description2"))
        }
    }
    
    func showHint(title: String, info: String) {
        NSLog("\(info)")
        let alert = UIAlertController(title: title, message: info, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes!", comment: "Yes!"), style: .default, handler: { (action) in
            try! realm.write {
                self.cache.isActivated = false
                self.cache.isFound = true
                self.cache.foundDate = Date()
            }
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("No.", comment: "No."), style: .cancel, handler: nil))
        alert.modalPresentationStyle = .popover
        self.present(alert, animated: true, completion: nil)
    }
}
