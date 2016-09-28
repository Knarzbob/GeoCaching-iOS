//
//  CacheTutorial1VC.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 02.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import UIKit

class CacheTutorial1VC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    let headline = NSMutableAttributedString(string: NSLocalizedString("Traditional", comment: "") + "\n", attributes: [ NSFontAttributeName: Font().avenir(.Regular, size: 42) ])
    
    let contentText = AttributedString(string: NSLocalizedString("The most common cache-type. The coordinates are known right at the beginning so you can get to it without losing time.", comment: ""), attributes: [ NSFontAttributeName: Font().avenir(.Regular, size: 18), NSForegroundColorAttributeName: Farbe.grau ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headline.append(contentText)
        textView.attributedText = headline
        imageView.image = UIImage(named: "cache_tradi")
    }
}
