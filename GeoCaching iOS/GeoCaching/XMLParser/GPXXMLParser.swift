//
//  GPXXMLParser.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 01.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import Foundation
class GPXXMLParser: NSObject, XMLParserDelegate {
    
    //MARK: - Variablen
    var delegate: GPXXMLParserDelegate?
    var wptDictionary = [String: AnyObject]()
    var wpts = [[String: AnyObject]]()
    var cacheAttributeDictionary = [String: AnyObject]()
    var cacheAttributes = [[String: AnyObject]]()
    var currentElementName = ""
    var knot = ""
    var logDictionary = [String: AnyObject]()
    var logs = [[String: AnyObject]]()
    var completeGroundspeakShortDescription = ""
    var completeGroundspeakLongDescription = ""
    var completeGroundspeakEncodedHint = ""
    var completeLogGroundspeakFinder = ""
    var completeLogGroundspeakDate = ""
    var completeLogGroundspeakType = ""
    var completeLogGroundspeakText = ""
    var completeDesc = ""
    var completeUrlname = ""
    var completeGroundspeakName = ""
    var completeGroundspeakPlacedBy = ""
    var completeGroundspeakOwner = ""
    var completeGroundspeakType = ""
    var completeGroundspeakContainer = ""
    var completeGroundspeakCountry = ""
    var completeGroundspeakState = ""
    
    func downloadAndParseGPX(with url: URL) {
        DispatchQueue.global(attributes: .qosUserInitiated).async {
            if let parser = XMLParser(contentsOf: url) {
                parser.delegate = self
                parser.parse()
            } else {
                _ = DispatchQueue.main.sync {
                    self.delegate?.downloadDidFail()
                }
            }
        }
    }
    
    func parseGPXFile(named name: String) {
        DispatchQueue.global(attributes: .qosUserInitiated).async {
            guard let path = Bundle.main.pathForResource(name, ofType: "gpx") else {
                print("Fehler: Falsche URL/Dateiname!")
                return
            }
            let url = URL(fileURLWithPath: path)
            guard let stream = InputStream(url: url) else { return }
            let parser = XMLParser(stream: stream)
            parser.delegate = self
            parser.parse()
        }
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        _ = DispatchQueue.main.sync {
            self.delegate?.downloadDidFinish()
        }
    }
    
    //MARK: - XMLParser Delegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElementName = elementName
        switch elementName {
        case "gpx": knot = "gpx"
        case "wpt": knot = "wpt"
            for attr in attributeDict {
                if attr.0 == "lat" || attr.0 == "lon" {
                    if let latlon = Double(attr.1) {
                        wptDictionary[attr.0] = latlon
                    }
                }
            }
        case "groundspeak:cache": knot = "groundspeak:cache"
            for attr in attributeDict {
                if attr.0 == "id" {
                    if let id = Int(attr.1) {
                        wptDictionary["cacheId"] = id
                    }
                }
                if attr.0 == "available" || attr.0 == "archived" {
                    wptDictionary[attr.0] = attr.1.toBool()
                }
            }
        case "groundspeak:owner":
            for attr in attributeDict {
                if attr.0 == "id" {
                    if let id = Int(attr.1) {
                        wptDictionary["ownerId"] = id
                    }
                }
            }
        case "groundspeak:attributes": knot = "groundspeak:attributes"
        case "groundspeak:attribute":
            for attr in attributeDict {
                if attr.0 == "id" {
                    if let id = Int(attr.1) {
                        cacheAttributeDictionary["id"] = id
                    }
                } else if attr.0 == "inc" {
                    if let inc = attr.1.toBool() {
                        cacheAttributeDictionary["inc"] = inc
                    }
                }
            }
        case "groundspeak:logs": knot = "groundspeak:logs"
        case "groundspeak:log":
            for attr in attributeDict {
                if attr.0 == "id" {
                    if let id = Int(attr.1) {
                        logDictionary["logId"] = id
                    }
                }
            }
        case "groundspeak:finder":
            for attr in attributeDict {
                if attr.0 == "id" {
                    if let id = Int(attr.1) {
                        logDictionary["finderId"] = id
                    }
                }
            }
        case "groundspeak:short_description":
            for attr in attributeDict {
                if attr.0 == "html" {
                    wptDictionary["groundspeak:short_description:html"] = attr.1
                }
            }
        case "groundspeak:long_description":
            for attr in attributeDict {
                if attr.0 == "html" {
                    wptDictionary["groundspeak:long_description:html"] = attr.1
                }
            }
        default: return
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if string != "" && !string.isEmpty && string != "\n          " && string != "\n         " && string != "\n        " && string != "\n       " && string != "\n      " && string != "\n     " && string != "\n    " && string != "\n   " && string != "\n  " && string != "\n " {
            switch knot {
            case "wpt":
                switch currentElementName {
                case "time": wptDictionary["time"] = string
                case "name": wptDictionary["name"] = string
                case "desc": completeDesc += string
                case "url": wptDictionary["url"] = string
                case "urlname": completeUrlname += string
                case "sym": wptDictionary["sym"] = string
                case "type": wptDictionary["type"] = string
                default: return
                }
            case "groundspeak:cache":
                switch currentElementName {
                case "groundspeak:name": completeGroundspeakName += string
                case "groundspeak:placed_by": completeGroundspeakPlacedBy += string
                case "groundspeak:owner": completeGroundspeakOwner += string
                case "groundspeak:type": completeGroundspeakType += string
                case "groundspeak:container": completeGroundspeakContainer += string
                case "groundspeak:difficulty":
                    if let i = Double(string) {
                        wptDictionary["groundspeak:difficulty"] = i
                    }
                case "groundspeak:terrain":
                    if let i = Double(string) {
                        wptDictionary["groundspeak:terrain"] = i
                    }
                case "groundspeak:country": completeGroundspeakCountry += string
                case "groundspeak:state": completeGroundspeakState += string
                case "groundspeak:short_description": completeGroundspeakShortDescription += string
                case "groundspeak:long_description": completeGroundspeakLongDescription += string
                case "groundspeak:encoded_hints": completeGroundspeakEncodedHint += string
                default: return
                }
            case "groundspeak:travelbug":
                print("Travelbug gefunden")
            case "groundspeak:attributes":
                switch currentElementName {
                case "groundspeak:attribute": cacheAttributeDictionary["attributeDesc"] = string
                cacheAttributes.append(cacheAttributeDictionary)
                cacheAttributeDictionary = [String: AnyObject]()
                default: return
                }
            case "groundspeak:logs":
                switch currentElementName{
                case "groundspeak:date": completeLogGroundspeakDate += string
                case "groundspeak:type": completeLogGroundspeakType += string
                case "groundspeak:finder": completeLogGroundspeakFinder += string
                case "groundspeak:text": completeLogGroundspeakText += string
                default: return
                }
            default: return
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "groundspeak:attributes":
            wptDictionary["attributes"] = cacheAttributes
            cacheAttributes = [[String: AnyObject]]()
            knot = "groundspeak:cache"
        case "groundspeak:log":
            logs.append(logDictionary)
            logDictionary = [String: AnyObject]()
        case "groundspeak:logs":
            wptDictionary["logs"] = logs
            logs = [[String: AnyObject]]()
            knot = "groundspeak:cache"
        case "wpt":
            wpts.append(wptDictionary)
            wptDictionary = [String: AnyObject]()
        case "groundspeak:short_description":
            wptDictionary["groundspeak:short_description"] = completeGroundspeakShortDescription
            completeGroundspeakShortDescription = ""
        case "groundspeak:long_description":
            wptDictionary["groundspeak:long_description"] = completeGroundspeakLongDescription
            completeGroundspeakLongDescription = ""
        case "groundspeak:encoded_hints":
            wptDictionary["groundspeak:encoded_hints"] = completeGroundspeakEncodedHint
            completeGroundspeakEncodedHint = ""
        case "groundspeak:text":
            logDictionary["groundspeak:text"] = completeLogGroundspeakText
            completeLogGroundspeakText = ""
        case "desc":
            wptDictionary["desc"] = completeDesc
            completeDesc = ""
        case "urlname":
            wptDictionary["urlname"] = completeUrlname
            completeUrlname = ""
        case "groundspeak:name":
            wptDictionary["groundspeak:name"] = completeGroundspeakName
            completeGroundspeakName = ""
        case "groundspeak:placed_by":
            wptDictionary["groundspeak:placed_by"] = completeGroundspeakPlacedBy
            completeGroundspeakPlacedBy = ""
        case "groundspeak:owner":
            wptDictionary["groundspeak:owner"] = completeGroundspeakOwner
            completeGroundspeakOwner = ""
        case "groundspeak:type":
            if knot == "groundspeak:cache" {
                wptDictionary["groundspeak:type"] = completeGroundspeakType
                completeGroundspeakType = ""
            } else if knot == "groundspeak:logs" {
                logDictionary["groundspeak:type"] = completeLogGroundspeakType
                completeLogGroundspeakType = ""
            }
        case "groundspeak:container":
            wptDictionary["groundspeak:container"] = completeGroundspeakContainer
            completeGroundspeakContainer = ""
        case "groundspeak:country":
            wptDictionary["groundspeak:country"] = completeGroundspeakCountry
            completeGroundspeakCountry = ""
        case "groundspeak:state":
            wptDictionary["groundspeak:state"] = completeGroundspeakState
            completeGroundspeakState = ""
        case "groundspeak:date":
            logDictionary["groundspeak:date"] = completeLogGroundspeakDate
            completeLogGroundspeakDate = ""
        case "groundspeak:finder":
            logDictionary["groundspeak:finder"] = completeLogGroundspeakFinder
            completeLogGroundspeakFinder = ""
        default: return
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.sync {
            self.saveToDatabase()
        }
        print("wpts.count: \(wpts.count)")
    }

    //MARK: - Die geparsten Elemente in die Datenbank schreiben
    func saveToDatabase() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        for wpt in wpts {
            let cache = Cache()
            if let lat = wpt["lat"] as? Double {
                cache.latitude = lat
            }
            if let lon = wpt["lon"] as? Double {
                cache.longitude = lon
            }
            if let cacheId = wpt["cacheId"] as? Int {
                cache.id = cacheId
            }
            if let cacheType = wpt["groundspeak:type"] as? String {
                cache.cacheTypeRaw = cacheType
            }
            if let time = wpt["time"] as? String {
                if let date = dateFormatter.date(from: time) {
                    cache.time = date
                }
            }
            if let name = wpt["name"] as? String {
                cache.name = name
            }
            if let desc = wpt["desc"] as? String {
                cache.desc = desc
            }
            if let urlname = wpt["urlname"] as? String {
                cache.urlname = urlname
            }
            if let groundspeakName = wpt["groundspeak:name"] as? String {
                cache.groundspeakName = groundspeakName
            }
            if let available = wpt["available"] as? Bool {
                cache.available = available
            }
            if let placedBy = wpt["groundspeak:placed_by"] as? String {
                cache.placedBy = placedBy
            }
            if let owner = wpt["groundspeak:owner"] as? String {
                cache.owner = owner
            }
            if let container = wpt["groundspeak:container"] as? String {
                cache.containerRaw = container
            }
            if let ownerId = wpt["ownerId"] as? Int {
                cache.ownerId = ownerId
            }
            if let attributes = wpt["attributes"] as? [[String: AnyObject]] {
                for attribute in attributes {
                    let attr = CacheAttribute()
                    if let id = attribute["id"] as? Int {
                        attr.id = id
                    }
                    if let inc = attribute["inc"] as? Bool {
                        attr.inc = inc
                    }
                    if let attributeDesc = attribute["attributeDesc"] as? String {
                        attr.descRaw = attributeDesc
                    }
                    cache.attributes.append(attr)
                }
            }
            if let difficulty = wpt["groundspeak:difficulty"] as? Double {
                cache.difficulty = difficulty
            }
            if let terrain = wpt["groundspeak:terrain"] as? Double {
                cache.terrain = terrain
            }
            if let country = wpt["groundspeak:country"] as? String {
                cache.country = country
            }
            if let state = wpt["groundspeak:state"] as? String {
                cache.state = state
            }
            if let shortDescHtml = (wpt["groundspeak:short_description:html"] as? String)?.toBool() {
                cache.shortDescIsHtml = shortDescHtml
            }
            if let shortDesc = wpt["groundspeak:short_description"] as? String {
                cache.shortDesc = shortDesc
            }
            if let longDescHtml = (wpt["groundspeak:long_description:html"] as? String)?.toBool() {
                cache.longDescIsHtml = longDescHtml
            }
            if let longDesc = wpt["groundspeak:long_description"] as? String {
                cache.longDesc = longDesc
            }
            if let encodedHints = wpt["groundspeak:encoded_hints"] as? String {
                cache.encodedHints = encodedHints
            }
            if let logs = wpt["logs"] as? [[String: AnyObject]] {
                for log in logs {
                    let l = Log()
                    if let text = log["groundspeak:text"] as? String {
                        l.text = text
                    }
                    if let type = log["groundspeak:type"] as? String {
                        l.type = type
                    }
                    if let date = log["groundspeak:date"] as? String {
                        if let date = dateFormatter.date(from: date) {
                            l.date = date
                        }
                    }
                    if let finder = log["groundspeak:finder"] as? String {
                        l.finder = finder
                    }
                    if let finderId = log["finderId"] as? Int {
                        l.finderId = finderId
                    }
                    if let logId = log["logId"] as? Int {
                        l.id = logId
                    }
                    cache.logs.append(l)
                }
            }
            
            try! realm.write {
                realm.add(cache, update: true)
            }
        }
        delegate?.didFinishUpdateDatabase()
    }
}

protocol GPXXMLParserDelegate {
    func didFinishUpdateDatabase()
    func downloadDidFinish()
    func downloadDidFail()
}
