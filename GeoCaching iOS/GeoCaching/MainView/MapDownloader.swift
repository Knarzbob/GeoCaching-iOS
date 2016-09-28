//
//  MapDownloader.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 19.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import Foundation
import Mapbox

class MapDownloader: NSObject, MGLMapViewDelegate {
    
    var delegate: MapDownloaderDelegate?
    var pack: MGLOfflinePack?
    
    func startOfflinePackDownload() {
        // Create a region that includes the current viewport and any tiles needed to view it when zoomed further in.
        // Because tile count grows exponentially with the maximum zoom level, you should be conservative with your `toZoomLevel` setting.
        let OchsenfurtMapRegion = MGLCoordinateBounds(
            sw: CLLocationCoordinate2D(
                latitude: 49.6035 - 0.001,
                longitude: 9.93995 - 0.001
            ),
            ne: CLLocationCoordinate2D(
                latitude: 49.745167 + 0.001,
                longitude: 10.167467 + 0.001
            )
        )
        
        let region = MGLTilePyramidOfflineRegion(styleURL: MGLStyle.lightStyleURL(withVersion: 9), bounds: OchsenfurtMapRegion, fromZoomLevel: 12, toZoomLevel: 15)
        
        // Store some data for identification purposes alongside the downloaded resources.
        let userInfo = ["name": "Ochsenfurt"]
        let context = NSKeyedArchiver.archivedData(withRootObject: userInfo)
        
        // Create and register an offline pack with the shared offline storage object.
        MGLOfflineStorage.shared().addPack(for: region, withContext: context) { (pack, error) in
            guard error == nil else {
                // The pack couldn’t be created for some reason.
                print("Error: \(error?.localizedFailureReason)")
                return
            }
            
            // Start downloading.
            self.pack = pack
            self.pack!.resume()
        }
    }
    
    // MARK: - MGLOfflinePack notification handlers
    
    func offlinePackProgressDidChange(notification: NSNotification) {
        // Get the offline pack this notification is regarding,
        // and the associated user info for the pack; in this case, `name = My Offline Pack`
        if let pack = notification.object as? MGLOfflinePack, let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String] {
            let progress = pack.progress
            // or notification.userInfo![MGLOfflinePackProgressUserInfoKey]!.MGLOfflinePackProgressValue
            let completedResources = progress.countOfResourcesCompleted
            let expectedResources = progress.countOfResourcesExpected
            
            // Calculate current progress percentage.
            let progressPercentage = Float(completedResources) / Float(expectedResources)
            
            delegate?.mapDownloadDidChange(progress: progressPercentage)
            
            // If this pack has finished, print its size and resource count.
            if completedResources == expectedResources {
                let byteCount = ByteCountFormatter.string(fromByteCount: Int64(pack.progress.countOfBytesCompleted), countStyle: .memory)
                print("Offline pack “\(userInfo["name"])” completed: \(byteCount), \(completedResources) resources")
                delegate?.mapDownloadDidFinish()
            } else {
                // Otherwise, print download/verification progress.
                print("Offline pack “\(userInfo["name"])” has \(completedResources) of \(expectedResources) resources — \(progressPercentage * 100)%.")
            }
        }
    }
    
    func offlinePackDidReceiveError(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack, let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String], let error = notification.userInfo?[MGLOfflinePackErrorUserInfoKey] as? NSError {
            print("Offline pack “\(userInfo["name"])” received error: \(error.localizedFailureReason)")
        }
    }
    
    func offlinePackDidReceiveMaximumAllowedMapboxTiles(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
            let maximumCount = notification.userInfo?[MGLOfflinePackMaximumCountUserInfoKey]?.uint64Value {
            print("Offline pack “\(userInfo["name"])” reached limit of \(maximumCount) tiles.")
        }
    }
    
    func suspendDownloadTemporarily() {
        guard let pack = pack else { return }
        pack.suspend()
    }
}

protocol MapDownloaderDelegate {
    func mapDownloadDidChange(progress: Float)
    func mapDownloadDidFinish()
}
