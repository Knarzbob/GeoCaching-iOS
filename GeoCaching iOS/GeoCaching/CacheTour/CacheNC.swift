//
//  CacheNC.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 01.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import UIKit

class CacheNC: UINavigationController, UINavigationBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    var cache: Cache!
    var navItem: UINavigationItem!
    var labelTitle: UILabel!
    var imageView: UIImageView!
    var collectionView: UICollectionView!
    var buttonAbbruch: UIButton!
    var positiveAttributes = [CacheAttribute]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.delegate = self
        navItem = navigationBar.items?.first
        navItem?.title = ""
        
        prepareAttributes()
        prepareButton()
        prepareLabel()
        prepareCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let oldFrame = navigationBar.frame
        navigationBar.frame = CGRect(x: oldFrame.origin.x, y: oldFrame.origin.y, width: oldFrame.width, height: 200)
        
        imageView = UIImageView(frame: navigationBar.bounds)
        imageView.contentMode = .scaleAspectFit
        navigationBar.titleTextAttributes = [ NSFontAttributeName: Font().avenir(.DemiBold, size: 14),  NSForegroundColorAttributeName: Farbe.weiß]
        navigationBar.isTranslucent = false
        switch cache.cacheType {
        case .MultiCache:
            navigationBar.barTintColor = Farbe.cacheOrange
            imageView.image = UIImage(named: "cache_multi_l")
        case .TraditionalCache:
            navigationBar.barTintColor = Farbe.cacheGrün
            imageView.image = UIImage(named: "cache_tradi_l")
        case .EarthCache:
            navigationBar.barTintColor = Farbe.cacheBlau
            imageView.image = UIImage(named: "cache_mystery_l")
        case .EventCache:
            navigationBar.barTintColor = Farbe.cacheBlau
            imageView.image = UIImage(named: "cache_mystery_l")
        case .UnknownCache:
            navigationBar.barTintColor = Farbe.cacheBlau
            imageView.image = UIImage(named: "cache_mystery_l")
        }
        imageView.addSubview(labelTitle)
        imageView.addSubview(collectionView)
        navigationBar.addSubview(imageView)
    }
    
    func prepareButton() {
        buttonAbbruch = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 400))
        buttonAbbruch.setTitle(NSLocalizedString("Cancel", comment: "Cancel"), for: .normal)
        buttonAbbruch.addTarget(self, action: #selector(abbruch), for: UIControlEvents.allTouchEvents)
        buttonAbbruch.transform = CGAffineTransform(translationX: 0, y: -160)
        buttonAbbruch.titleLabel!.font = Font().avenir(.Regular, size: 15)
        buttonAbbruch.titleLabel!.textColor = Farbe.weiß
        
        let buttonAbbruchContainer = UIView(frame: buttonAbbruch.frame)
        buttonAbbruchContainer.addSubview(buttonAbbruch)
        let myLeftBarButtonItem = UIBarButtonItem(customView: buttonAbbruchContainer)
        navItem.leftBarButtonItem = myLeftBarButtonItem
    }
    
    func abbruch() {
        dismiss(animated: true, completion: nil)
    }
    
    func prepareAttributes() {
        for attribute in cache.attributes {
            if attribute.inc {
                positiveAttributes.append(attribute)
            }
        }
    }
    
    func prepareLabel() {
        labelTitle = UILabel(frame: CGRect(x: 20, y: 145, width: view.frame.size.width-100, height: 40))
        labelTitle.text = "\(cache.urlname)"
        labelTitle.numberOfLines = 2
        labelTitle.font = Font().avenir(.DemiBold, size: 16)
        labelTitle.textColor = Farbe.weiß
        labelTitle.adjustsFontSizeToFitWidth = true
        labelTitle.sizeToFit()
    }
    
    func prepareCollectionView() {
        collectionView = UICollectionView(frame: CGRect(x: view.frame.size.width-80, y: 10, width: 60, height: 180), collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "attribute")
        collectionView.backgroundColor = Farbe.keine
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //MARK: - CollectionView Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return positiveAttributes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "attribute", for: indexPath)
        
        let cellImageView = UIImageView(frame: CGRect(origin: cell.bounds.origin, size: cell.bounds.size))
        cellImageView.image = chooseAttributeImageForCell(At: indexPath)
        cellImageView.contentMode = .scaleAspectFill
        
        cell.addSubview(cellImageView)
        return cell
    }
    
    //MARK: - Flow Layout Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 25, height: 25)
    }
    
    func chooseAttributeImageForCell(At indexPath: IndexPath) -> UIImage? {
        var imgName = ""
        switch positiveAttributes[indexPath.row].desc {
            case .AbandonedMines: imgName = "mine"
            case .AbandonedStructure: imgName = "abandonedstructure"
            case .AccessOrParkingFee: imgName = "fee"
            case .AvailableAtAllTimes: imgName = "availableatalltimes"
            case .AvailableDuringWinter: imgName = "availableduringwinter"
            case .Bicycles: imgName = "bicycles"
            case .Boat: imgName = "boat"
            case .Campfires: imgName = "campfires"
            case .CampingAvailable: imgName = "camping"
            case .CliffFallingRocks: imgName = "cliff"
            case .ClimbingGear: imgName = "rappelling"
            case .CrossCountrySkis: imgName = "skiis"
            case .DangerousAnimals: imgName = "dangerousanimals"
            case .DangerousArea: imgName = "danger"
            case .DifficultClimbing: imgName = "difficultclimbing"
            case .Dogs: imgName = "dogs"
            case .DrinkingWaterNearby: imgName = "water"
            case .FieldPuzzle: imgName = "field_puzzle"
            case .FlashlightRequired: imgName = "flashlight"
            case .FoodNearby: imgName = "food"
            case .FrontYard: imgName = "frontyard"
            case .FuelNearby: imgName = "fuel"
            case .GeoTourCache: imgName = "geotour"
            case .Horses: imgName = "horses"
            case .Hunting: imgName = "hunting"
            case .LongHike: imgName = "hike_long"
            case .LostAndFoundTour: imgName = "landf"
            case .MayRequireSwimming: imgName = "mayrequireswimming"
            case .MayRequireWading: imgName = "mayrequirewading"
            case .MediumHike: imgName = "hike_med"
            case .Motorcycles: imgName = "motorcycles"
            case .NeedsMaintenance: imgName = "needsmaintenance"
            case .NightCache: imgName = "nightcache"
            case .None: imgName = ""
            case .OffroadVehicles: imgName = "offroad"
            case .ParkAndGrab: imgName = "parkngrab"
            case .ParkingAvailable: imgName = "parking"
            case .PartnershipCache: imgName = "partnership"
            case .PicnicTablesNearby: imgName = "picnic"
            case .PoisonPlants: imgName = "poisonoak"
            case .PublicRestroomsNearby: imgName = "restrooms"
            case .PublicTransportation: imgName = "public"
            case .Quads: imgName = "quads"
            case .RecommendedAtNight: imgName = "recatnight"
            case .RecommendedForKids: imgName = "recforkids"
            case .ScenicView: imgName = "scenic"
            case .ScubaGear: imgName = "scuba"
            case .SeasonalAccess: imgName = "seasonal"
            case .ShortHike: imgName = "hike_short"
            case .SignificantHike: imgName = "significanthike"
            case .Snowmobiles: imgName = "snowmobile"
            case .Snowshoes: imgName = "snowshoes"
            case .SpecialToolRequired: imgName = "s-tool"
            case .StealthRequired: imgName = "stealth"
            case .StrollerAccessible: imgName = "stroller"
            case .TakesLessThanAnHour: imgName = "takeslessthananhour"
            case .TeamworkRequired: imgName = "teamwork"
            case .TelephoneNearby: imgName = "phone"
            case .Thorns: imgName = "thorn"
            case .Ticks: imgName = "ticks"
            case .TouristFriendly: imgName = "touristOK"
            case .TreeClimbing: imgName = "treeclimbing"
            case .TruckDriverRV: imgName = "truckdriverrv"
            case .UVLightRequired: imgName = "UV"
            case .WatchForLivestock: imgName = "watchforlivestock"
            case .WheelchairAccessible: imgName = "wheelchair"
            case .WirelessBeacon: imgName = "wirelessbeacon"
        }
        if imgName != "" {
            return UIImage(named: imgName)
        } else {
            return nil
        }
    }
}
