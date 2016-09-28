//
//  CacheAttribute.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 12.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import Foundation
import RealmSwift

class CacheAttribute: Object {
    dynamic var id = 0
    dynamic var inc = false
    dynamic var descRaw = ""
    var desc: Attribute {
        get {
            if let a = Attribute(rawValue: descRaw) {
                return a
            }
            return .None
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

//Alle Attribute von: https://www.geocaching.com/about/icons.aspx
enum Attribute: String {
    case AbandonedMines = "Abandoned mines"
    case AbandonedStructure = "Abandoned Structure"
    case AccessOrParkingFee = "Access or parking fee"
    case AvailableAtAllTimes = "Available at all times"
    case AvailableDuringWinter = "Available during winter"
    case Bicycles = "Bicycles"
    case Boat = "Boat"
    case Campfires = "Campfires"
    case CampingAvailable = "Camping Available"
    case CliffFallingRocks = "Cliff / falling rocks"
    case ClimbingGear = "Climbing gear"
    case CrossCountrySkis = "Croos Country Skis"
    case DangerousAnimals = "Dangerous Animals"
    case DangerousArea = "Dangerous area"
    case DifficultClimbing = "Difficult climbing"
    case Dogs = "Dogs"
    case DrinkingWaterNearby = "Drinking water nearby"
    case FlashlightRequired = "Flashlight required"
    case FieldPuzzle = "Field Puzzle"
    case FoodNearby = "Food Nearby"
    case FrontYard = "Front Yard(Private Residence)"
    case FuelNearby = "Fuel Nearby"
    case GeoTourCache = "GeoTour Cache"
    case Horses = "Horses"
    case Hunting = "Hunting"
    case LongHike = "Long Hike (+10km)"
    case LostAndFoundTour = "Lost And Found Tour"
    case MayRequireWading = "May require wading"
    case MayRequireSwimming = "May require swimming"
    case MediumHike = "Medium hike (1km-10km)"
    case Motorcycles = "Motorcycles"
    case NeedsMaintenance = "Needs maintenance"
    case NightCache = "Night Cache"
    case OffroadVehicles = "Off-road vehicles"
    case ParkAndGrab = "Park and Grab"
    case ParkingAvailable = "Parking available"
    case PartnershipCache = "Partnership Cache"
    case PicnicTablesNearby = "Picnic tables nearby"
    case PoisonPlants = "Poison plants"
    case PublicRestroomsNearby = "Public restrooms nearby"
    case PublicTransportation = "Public transportation"
    case Quads = "Quads"
    case RecommendedAtNight = "Recommended at night"
    case RecommendedForKids = "Recommended for kids"
    case ScenicView = "Scenic view"
    case ScubaGear = "Scuba Gear"
    case SeasonalAccess = "Seasonal Access"
    case ShortHike = "Short hike (less than 1km)"
    case SignificantHike = "Significant Hike"
    case Snowmobiles = "Snowmobiles"
    case Snowshoes = "Snowshoes"
    case SpecialToolRequired = "Special Tool Required"
    case StealthRequired = "Stealth required"
    case StrollerAccessible = "Stroller accessible"
    case TakesLessThanAnHour = "Takes less than an hour"
    case TeamworkRequired = "Teamwork Required"
    case TelephoneNearby = "Telephone nearby"
    case Thorns = "Thorns"
    case Ticks = "Ticks"
    case TouristFriendly = "Tourist Friendly"
    case TreeClimbing = "Tree Climbing"
    case TruckDriverRV = "Truck Driver/RV"
    case UVLightRequired = "UV Light Required"
    case WatchForLivestock = "Watch for Livestock"
    case WheelchairAccessible = "Wheelchair accessible"
    case WirelessBeacon = "Wireless Beacon"
    
    case None = "None"
}
