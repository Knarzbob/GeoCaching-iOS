//
//  Welcome.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 01.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    let headline = NSMutableAttributedString(string: NSLocalizedString("Welcome, Traveller!", comment: "Welcome") + "\n", attributes: [ NSFontAttributeName: Font().avenir(.Regular, size: 42) ])
    
    let contentText = AttributedString(string: NSLocalizedString("Thank you for your interest in our GeoCaching-App for the city of Ochsenfurt.", comment: "Thank you") + "\n\n" + NSLocalizedString("To show you what GeoCaching is all about, we created a small tour for you!", comment: "GeoCaching Tour"), attributes: [ NSFontAttributeName: Font().avenir(.Regular, size: 18), NSForegroundColorAttributeName: Farbe.grau ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headline.append(contentText)
        textView.attributedText = headline
        imageView.image = UIImage(named: "flat_landscape")
    }
    
    @IBAction func buttonSkipAction() {
        performSegue(withIdentifier: "toMapVC", sender: self)
    }
    
    @IBAction func buttonProceedTutorialAction() {
        performSegue(withIdentifier: "toTourVC", sender: self)
    }
}
