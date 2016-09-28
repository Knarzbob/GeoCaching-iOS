//
//  AppDelegate.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 01.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import UIKit
import RealmSwift

var realm: Realm!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        realm = try! Realm()
        
        window = UIWindow(frame: UIScreen.main().bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var viewController: UIViewController
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
            viewController = storyboard.instantiateViewController(withIdentifier: "Main")
        }
        else {
            print("First launch, setting NSUserDefault.")
            let gpxparser = GPXXMLParser()
//            gpxparser.downloadAndParseGPX(with: URL(string: "https://www.dropbox.com/s/j552faubt1m029z/18137195_Ochsenfurt500.gpx?dl=1")!)
            gpxparser.parseGPXFile(named: "Ochsenfurt")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            viewController = storyboard.instantiateViewController(withIdentifier: "Welcome")
        }
        window?.rootViewController = viewController;
        window?.makeKeyAndVisible()
        
        customStyles()
        return true
    }
    
    func customStyles() {
        UIApplication.shared().statusBarStyle = .lightContent
        
        UIButton.appearance().titleLabel?.font = Font().avenir(.Regular, size: 15)
        UIButton.appearance().titleLabel?.textColor = Farbe.cacheBlau
        
        UIPageControl.appearance().pageIndicatorTintColor = Farbe.schwachesGrau
        UIPageControl.appearance().currentPageIndicatorTintColor = Farbe.cacheBlau
        UIPageControl.appearance().backgroundColor = Farbe.weiß
        
        UITabBar.appearance().tintColor = Farbe.cacheBlau
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: Farbe.cacheBlau], for: .selected)
        
        UINavigationBar.appearance().barTintColor = Farbe.cacheBlau
        UINavigationBar.appearance().titleTextAttributes = [ NSFontAttributeName: Font().avenir(.DemiBold, size: 18),  NSForegroundColorAttributeName: Farbe.weiß ]
        UIBarButtonItem.appearance().setTitleTextAttributes([ NSFontAttributeName: Font().avenir(.Regular, size: 14),  NSForegroundColorAttributeName: Farbe.weiß ], for: .normal)
    }
}
