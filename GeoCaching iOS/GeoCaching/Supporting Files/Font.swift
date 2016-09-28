//
//  Font.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 01.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import Foundation
import UIKit

class Font {
    func avenir(_ weight: FontWeight, size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-\(weight.rawValue)", size: size)!
    }
}

enum FontName: String {
    case AvenirNext = "AvenirNext-"
}

enum FontWeight: String {
    case UltraLight = "UltraLight"
    case UltraLightItalic = "UltraLightItalic"
    case Medium = "Medium"
    case MediumItalic = "MediumItalic"
    case Regular = "Regular"
    case Italic = "Italic"
    case Heavy = "Heavy"
    case HeavyItalic = "HeavyItalic"
    case DemiBold = "DemiBold"
    case DemiBoldItalic = "DemiBoldItalic"
    case Bold = "Bold"
    case BoldItalic = "BoldItalic"
}

enum Farbe {
    static let grün = UIColor(red: 141/255, green: 198/255, blue: 0, alpha: 1)
    static let blau = UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1)
    static let schwachesGrün = UIColor(red: 141/255, green: 198/255, blue: 0, alpha: 0.1)
    static let rot = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
    static let orange = UIColor(red: 255/255, green: 153/255, blue: 0/255, alpha: 1)
    static let grau = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
    static let schwachesGrau = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    static let transparent = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
    static let schwarz = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
    static let weiß = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    static let keine = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    
    static let cacheOrange = UIColor(red: 242/255, green: 145/255, blue: 0/255, alpha: 1)
    static let cacheGrün = UIColor(red: 69/255, green: 119/255, blue: 46/255, alpha: 1)
    static let cacheBlau = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
}
