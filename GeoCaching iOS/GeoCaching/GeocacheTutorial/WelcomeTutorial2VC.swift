//
//  WelcomeTutorial2VC.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 02.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import UIKit

class WelcomeTutorial2VC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    let headline = NSMutableAttributedString(string: NSLocalizedString("About the App", comment: "About the App") + "\n", attributes: [ NSFontAttributeName: Font().avenir(.Regular, size: 42) ])
    
    let contentText = AttributedString(string: NSLocalizedString("Your smartphone is already equipped with a GPS receiver.", comment: "") + "\n\n" + NSLocalizedString("This App contains informations about the caches, which are placed in and around Ochsenfurt.", comment: "") + "\n\n" + NSLocalizedString("The map will support you at your hunt after the caches.", comment: ""), attributes: [ NSFontAttributeName: Font().avenir(.Regular, size: 18), NSForegroundColorAttributeName: Farbe.grau ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headline.append(contentText)
        textView.attributedText = headline
        imageView.image = UIImage(named: "flat_city")
    }
}
