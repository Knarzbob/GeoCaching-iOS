//
//  WelcomeTutorial1VC.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 02.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import UIKit

class WelcomeTutorial1VC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    let headline = NSMutableAttributedString(string: NSLocalizedString("What is GeoCaching?", comment: "What is GeoCaching?") + "\n", attributes: [ NSFontAttributeName: Font().avenir(.Regular, size: 42) ])
    
    let contentText = AttributedString(string: NSLocalizedString("GeoCaching is a modern form of Paper chase.", comment: "GeoCaching is") + "\n\n" + NSLocalizedString("Equipped with a Global Positioning System (GPS) and coordinates of a \"treasure\" from the internet you can find so called Caches, which are placed by someone else at uncommon places.", comment: "GeoCaching is2"), attributes: [ NSFontAttributeName: Font().avenir(.Regular, size: 18), NSForegroundColorAttributeName: Farbe.grau ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headline.append(contentText)
        textView.attributedText = headline
        imageView.image = UIImage(named: "flat_town")
    }
}
