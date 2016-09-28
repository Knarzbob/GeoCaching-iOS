//
//  CacheTutorial3VC.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 02.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import UIKit

class CacheTutorial3VC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    let headline = NSMutableAttributedString(string: NSLocalizedString("Multi Cache", comment: "Multi Cache") + "\n", attributes: [ NSFontAttributeName: Font().avenir(.Regular, size: 42) ])
    
    let contentText = AttributedString(string: NSLocalizedString("The Coordinates of the Multi Cache are not known at the beginning. You have to go through a couple of stations to get the final coordinates.", comment: ""), attributes: [ NSFontAttributeName: Font().avenir(.Regular, size: 18), NSForegroundColorAttributeName: Farbe.grau ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headline.append(contentText)
        textView.attributedText = headline
        imageView.image = UIImage(named: "cache_multi")
    }
}
