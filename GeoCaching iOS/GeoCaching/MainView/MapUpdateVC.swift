//
//  MapUpdateVC.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 03.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import UIKit

class MapUpdateVC: UIViewController, MapDownloaderDelegate {

    var progressView: UIProgressView!
    let mapDownloader = MapDownloader()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        mapDownloader.delegate = self
        
        // Setup the progress bar.
        if progressView == nil {
            progressView = UIProgressView(progressViewStyle: .default)
            let frame = view.bounds.size
            progressView.frame = CGRect(x: frame.width / 4, y: frame.height * 0.75, width: frame.width / 2, height: 10)
            view.addSubview(progressView)
            
            // Setup offline pack notification handlers.
            NotificationCenter.default.addObserver(mapDownloader, selector: #selector(mapDownloader.offlinePackProgressDidChange), name: NSNotification.Name.MGLOfflinePackProgressChanged, object: nil)
            NotificationCenter.default.addObserver(mapDownloader, selector: #selector(mapDownloader.offlinePackDidReceiveError), name: NSNotification.Name.MGLOfflinePackError, object: nil)
            NotificationCenter.default.addObserver(mapDownloader, selector: #selector(mapDownloader.offlinePackDidReceiveMaximumAllowedMapboxTiles), name: NSNotification.Name.MGLOfflinePackMaximumMapboxTilesReached, object: nil)
        }
    }
    
    deinit {
        // Remove offline pack observers.
        NotificationCenter.default.removeObserver(mapDownloader)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mapDownloader.startOfflinePackDownload()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mapDownloader.suspendDownloadTemporarily()
    }
    
    func mapDownloadDidChange(progress: Float) {
        progressView.progress = progress
    }
    
    func mapDownloadDidFinish() {
        UserDefaults.standard.set(Date(), forKey: "MapUpdated")
        UserDefaults.standard.set(true, forKey: "MapOffline")
        _ = navigationController?.popViewController(animated: true)
    }
}
