//
//  MapVC.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 01.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import UIKit
import Mapbox
import RealmSwift

class MapVC: UIViewController, MGLMapViewDelegate, EnterCoordsAlertViewDelegate {
    
    //MARK: - Variablen
    var caches: Results<Cache>?
    var mapView: MGLMapView!
    var userDefinedMarker = MGLPointAnnotation()
    var userDefinedMarkerPlaced = false
    var cacheToSend: Cache!
    var activeCache: Cache!
    var shapeToCache: MGLPolyline?
    var shapeToUserDefinedMarker: MGLPolyline?
    var tooltip: UIView!
    var tooltipLabel: UILabel!
    var tooltip2: UIView!
    var tooltipLabel2: UILabel!
    var enterCoordsAlertView: EnterCoordsAlertView!
    var optionsButton: UIBarButtonItem!
    
    //MARK: - App-Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Loc: Karte
        title = NSLocalizedString("Map", comment: "TitleForMapView")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "info")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(startCacheTutorial))
        optionsButton = UIBarButtonItem(image: UIImage(named: "options")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(openMenu))
        navigationItem.rightBarButtonItem = optionsButton
        
        setUpTooltip()
        setUpMap()
        setUpEnterCoordsAlertView()
        createUserDefinedMarker()
        setMapCamera()
    }
    
    func setUpEnterCoordsAlertView() {
        enterCoordsAlertView = EnterCoordsAlertView(frame: self.view.bounds)
        enterCoordsAlertView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        loadCaches()
    }
    
    func startCacheTutorial() {
        performSegue(withIdentifier: "toCacheTutorial", sender: self)
    }
    
    func openMenu(sender: UIBarButtonItem) {
        let optionenAlert = UIAlertController(title: NSLocalizedString("Options", comment: "Options-Menu Title"), message: nil, preferredStyle: .actionSheet)
        if UserDefaults.standard.bool(forKey: "OchsenfurtTourIsActive") {
            optionenAlert.addAction(UIAlertAction(title: NSLocalizedString("End Ochsenfurt-Tour", comment: "End Ochsenfurt-Tour"), style: .default, handler: { (action) in
                UserDefaults.standard.set(false, forKey: "OchsenfurtTourIsActive")
                self.loadCaches()
            }))
        } else {
            optionenAlert.addAction(UIAlertAction(title: NSLocalizedString("Start Ochsenfurt-Tour", comment: "Start Ochsenfurt-Tour"), style: .default, handler: { (action) in
                UserDefaults.standard.set(true, forKey: "OchsenfurtTourIsActive")
                self.loadCaches()
            }))
        }
        if userDefinedMarkerPlaced {
            optionenAlert.addAction(UIAlertAction(title: NSLocalizedString("Update coordinates", comment: "Update coordinates"), style: .default, handler: { (action) in
                self.mapView.isUserInteractionEnabled = false
                self.optionsButton.isEnabled = false
                self.view.addSubview(self.enterCoordsAlertView)
                self.enterCoordsAlertView.show()
            }))
            optionenAlert.addAction(UIAlertAction(title: NSLocalizedString("Delete own Marker", comment: "Delete Marker"), style: .destructive, handler: { (action) in
                self.deleteOwnMarker()
            }))
        } else {
            optionenAlert.addAction(UIAlertAction(title: NSLocalizedString("Create own Marker", comment: "Create own Marker"), style: .default, handler: { (action) in
                self.mapView.isUserInteractionEnabled = false
                self.optionsButton.isEnabled = false
                self.view.addSubview(self.enterCoordsAlertView)
                self.enterCoordsAlertView.show()
            }))
        }
        optionenAlert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel-Button"), style: .cancel, handler: nil))
        optionenAlert.modalPresentationStyle = .popover
        optionenAlert.popoverPresentationController?.barButtonItem = sender
        self.present(optionenAlert, animated: true, completion: nil)
    }
    
    func enterCoordsButtonOKClicked(lat: Double, lon: Double) {
        mapView.isUserInteractionEnabled = true
        optionsButton.isEnabled = true
        userDefinedMarkerPlaced = true
        userDefinedMarker.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        mapView.addAnnotation(self.userDefinedMarker)
    }
    
    func enterCoordsButtonCancelClicked() {
        mapView.isUserInteractionEnabled = true
        optionsButton.isEnabled = true
    }
    
    func deleteOwnMarker() {
        userDefinedMarkerPlaced = false
        mapView.removeAnnotation(self.userDefinedMarker)
    }
    
    func setUpMap() {
        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.lightStyleURL(withVersion: 9))
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.tintColor = .darkGray()
        mapView.delegate = self
        mapView.setCenter(CLLocationCoordinate2D(latitude: 49.661379, longitude: 10.069847), zoomLevel: 11, animated: false)
        view.addSubview(mapView)
        mapView.showsUserLocation = true
        mapView.addSubview(tooltip)
        mapView.addSubview(tooltipLabel)
        mapView.addSubview(tooltip2)
        mapView.addSubview(tooltipLabel2)
    }
    
    func setMapCamera() {
        guard let caches = caches else { return }
        if caches.count > 1 {
            var maxLon: CLLocationDegrees = 0
            var maxLat: CLLocationDegrees = 0
            var minLon: CLLocationDegrees = 11
            var minLat: CLLocationDegrees = 52
            for cache in caches {
                if cache.latitude > maxLat {
                    maxLat = cache.latitude
                }
                if cache.latitude < minLat {
                    minLat = cache.latitude
                }
                if cache.longitude > maxLon {
                    maxLon = cache.longitude
                }
                if cache.longitude < minLon {
                    minLon = cache.longitude
                }
            }
            let bounds = MGLCoordinateBounds(
                sw: CLLocationCoordinate2D(latitude: minLat - 0.02, longitude: minLon - 0.02),
                ne: CLLocationCoordinate2D(latitude: maxLat + 0.02, longitude: maxLon + 0.02))
            mapView.setVisibleCoordinateBounds(bounds, animated: false)
        }
    }
    
    func loadCaches() {
        //Zuerst checken ob ein Cache bereits als 'AKTIVIERT' markiert worden ist
        caches = realm.allObjects(ofType: Cache.self).filter(using: Predicate(format: "isActivated = true"))
        
        //Wenn kein aktivierter Cache gefunden werden konnte, abfragen ob OchsenTour aktiviert ist. Ansonsten normale Tour, also alle Caches anzeigen, die noch nicht als 'Gefunden' markiert worden sind.
        if caches!.count == 0 {
            if UserDefaults.standard.bool(forKey: "OchsenfurtTourIsActive") {
                caches = realm.allObjects(ofType: Cache.self).filter(using: Predicate(format: "isFound = false AND groundspeakName BEGINSWITH[c] 'AL#'"))
            } else {
                caches = realm.allObjects(ofType: Cache.self).filter(using: Predicate(format: "isFound = false"))
                tooltip.alpha = 0
                tooltipLabel.alpha = 0
            }
        }
        //Marker platzieren
        setMarkers()
    }
    
    func setMarkers() {
        guard let caches = caches else { return }
        if let annotations = mapView.annotations {
            mapView.removeAnnotations(annotations)
        }
        for cache in caches {
            let marker = CacheAnnotation(reuseIdentifier: "Cache")
            marker.myCoordinate = CLLocationCoordinate2D(latitude: cache.latitude, longitude: cache.longitude)
            marker.myTitle = "\(cache.urlname)"
            marker.mySubtitle = NSLocalizedString("More informations…", comment: "More informations…")
            marker.cache = cache
            
            mapView.addAnnotation(marker)
        }
        if userDefinedMarkerPlaced {
            mapView.addAnnotation(userDefinedMarker)
        }
    }
    
    func createUserDefinedMarker() {
        userDefinedMarker = MGLPointAnnotation()
        userDefinedMarker.title = NSLocalizedString("Your Marker", comment: "Your Marker")
        mapView.addAnnotation(userDefinedMarker)
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        if let annotation = annotation as? CacheAnnotation {
            var imageName: String?
            switch annotation.cache.cacheType {
            case .MultiCache: imageName = "cache_multi_map"
            case .UnknownCache: imageName = "cache_mystery_map"
            case .TraditionalCache: imageName = "cache_tradi_map"
            case .EarthCache: imageName = "cache_mystery_map"
            case .EventCache: imageName = "cache_mystery_map"
            }
            if let imageName = imageName, let image = UIImage(named: imageName) {
                let croppedImage = image.withAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
                return MGLAnnotationImage(image: croppedImage, reuseIdentifier: imageName)
            }
        }
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return annotation is CacheAnnotation ? true : false
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        toCacheDetail(annotation)
    }
    
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        guard let caches = caches else { return }
        if let location = userLocation {
            if caches.count == 1 {
                let cacheCoord = CLLocationCoordinate2D(latitude: caches.first!.latitude, longitude: caches.first!.longitude)
                drawShapeToCache(userCoord: location.coordinate, cacheCoord: cacheCoord)
            }
            if userDefinedMarkerPlaced {
                drawShapeToUserDefinedMarker(userCoord: location.coordinate, cacheCoord: userDefinedMarker.coordinate)
            }
        }
    }
    
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        return 0.5
    }
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return Farbe.cacheBlau
    }
    
    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        return UIButton(type: .detailDisclosure)
    }
    
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        toCacheDetail(annotation)
    }
    
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        return 3
    }
    
    func drawShapeToCache(userCoord: CLLocationCoordinate2D, cacheCoord: CLLocationCoordinate2D) {
        let user = CLLocation(latitude: userCoord.latitude, longitude: userCoord.longitude)
        let cach = CLLocation(latitude: cacheCoord.latitude, longitude: cacheCoord.longitude)
        let distance = user.distance(from: cach)
        var coordinates = [
            userCoord,
            cacheCoord
        ]
        shapeToCache = MGLPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
        mapView.removeAnnotation(shapeToCache!)
        mapView.addAnnotation(shapeToCache!)
        showDistanceToCache(distance: distance)
    }
    
    func drawShapeToUserDefinedMarker(userCoord: CLLocationCoordinate2D, cacheCoord: CLLocationCoordinate2D) {
        let user = CLLocation(latitude: userCoord.latitude, longitude: userCoord.longitude)
        let cach = CLLocation(latitude: cacheCoord.latitude, longitude: cacheCoord.longitude)
        let distance = user.distance(from: cach)
        var coordinates = [
            userCoord,
            cacheCoord
        ]
        shapeToUserDefinedMarker = MGLPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
        mapView.removeAnnotation(shapeToUserDefinedMarker!)
        mapView.addAnnotation(shapeToUserDefinedMarker!)
        showDistanceToUserDefinedMarker(distance: distance)
    }
    
    func setUpTooltip() {
        let width = view.frame.width - 100
        tooltip = UIView(frame: CGRect(x: view.frame.width/2 - width/2, y: view.frame.height - 110, width: width, height: 30))
        tooltip.alpha = 0
        tooltip.backgroundColor = Farbe.transparent
        tooltip.layer.cornerRadius = 8.0
        tooltip.clipsToBounds = true
        tooltipLabel = UILabel(frame: CGRect(x: view.frame.width/2 - width/2, y: view.frame.height - 110, width: width, height: 30))
        tooltipLabel.textAlignment = .center
        tooltipLabel.textColor = Farbe.weiß
        tooltipLabel.font = Font().avenir(.Regular, size: 12)
        tooltipLabel.alpha = 0
        
        tooltip2 = UIView(frame: CGRect(x: view.frame.width/2 - width/2, y: view.frame.height - 145, width: width, height: 30))
        tooltip2.alpha = 0
        tooltip2.backgroundColor = Farbe.transparent
        tooltip2.layer.cornerRadius = 8.0
        tooltip2.clipsToBounds = true
        tooltipLabel2 = UILabel(frame: CGRect(x: view.frame.width/2 - width/2, y: view.frame.height - 145, width: width, height: 30))
        tooltipLabel2.textAlignment = .center
        tooltipLabel2.textColor = Farbe.weiß
        tooltipLabel2.font = Font().avenir(.Regular, size: 12)
        tooltipLabel2.alpha = 0
    }
    
    func showDistanceToCache(distance: CLLocationDistance) {
        tooltipLabel.text = NSLocalizedString("Distance to cache:", comment: "Distance to cache") + " \(Int(distance))m"
        UIView.animate(withDuration: 1.5, animations: {
            self.tooltip.alpha = 1
            self.tooltipLabel.alpha = 1
        })
    }
    
    func showDistanceToUserDefinedMarker(distance: CLLocationDistance) {
        tooltipLabel2.text = NSLocalizedString("Distance to marker:", comment: "Distance to marker") + " \(Int(distance))m"
        UIView.animate(withDuration: 1.5, animations: {
            self.tooltip2.alpha = 1
            self.tooltipLabel2.alpha = 1
        })
    }
    
    //MARK: - Segue-Actions
    func toCacheDetail(_ annotation: MGLAnnotation) {
        if let annotation = annotation as? CacheAnnotation {
            cacheToSend = annotation.cache
            performSegue(withIdentifier: "ShowCache", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cacheNC = segue.destinationViewController as? CacheNC {
            cacheNC.cache = cacheToSend
        }
    }
}
