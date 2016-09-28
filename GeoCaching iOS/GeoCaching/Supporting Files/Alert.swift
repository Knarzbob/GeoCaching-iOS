//
//  Alert.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 01.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    func showHint(title: String, info: String, view: UIViewController?) {
        NSLog("\(info)")
        let alert = UIAlertController(title: title, message: info, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        alert.modalPresentationStyle = .popover
        if let v = view {
            v.self.present(alert, animated: true, completion: nil)
        } else {
            NSLog("Falsche View")
        }
    }
    
    func error(error: NSError, view: UIViewController) {
        let title = "Fehler"
        var info = error.localizedDescription
        if let reason =  error.localizedFailureReason, let sugges = error.localizedRecoverySuggestion {
            info += "\n\n\(reason)\n\n\(sugges)"
        } else if let sugges = error.localizedRecoverySuggestion {
            info += "\n\n\(sugges)"
        } else if let reason = error.localizedFailureReason {
            info += "\n\n\(reason)"
        }
        showHint(title: title, info: info, view: view)
    }
}
