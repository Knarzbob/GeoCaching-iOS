//
//  WelcomeTutorial3VC.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 02.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import UIKit

class WelcomeTutorial3VC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    let headline = NSMutableAttributedString(string: NSLocalizedString("And now?", comment: "And now?") + "\n", attributes: [ NSFontAttributeName: Font().avenir(.Regular, size: 42) ])
    
    let contentText = AttributedString(string: NSLocalizedString("There are exciting puzzles, misterious places and unique caches wating for you to find – Just go ahead and start your adventure!", comment: "") + "\n\n" + NSLocalizedString("Have fun wishes you the team of City Marketing Ochsenfurt.", comment: ""), attributes: [ NSFontAttributeName: Font().avenir(.Regular, size: 18), NSForegroundColorAttributeName: Farbe.grau ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headline.append(contentText)
        textView.attributedText = headline
        imageView.image = UIImage(named: "flat_night")
    }
    
    @IBAction func los() {
        if UserDefaults.standard.bool(forKey: "TourFromSettingsStarted") {
            dismiss(animated: true, completion: nil)
            UserDefaults.standard.set(false, forKey: "TourFromSettingsStarted")
        } else {
            performSegue(withIdentifier: "toMapVC", sender: self)
        }
    }
}
