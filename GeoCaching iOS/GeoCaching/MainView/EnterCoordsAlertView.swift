//
//  EnterCoordsAlertView.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 21.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import UIKit

class EnterCoordsAlertView: UIView, UITextFieldDelegate {
    
    let viewWidth: CGFloat = 250
    let viewHeight: CGFloat = 200
    
    var delegate: EnterCoordsAlertViewDelegate?
    
    var containerView: UIView!
    var backgroundView: UIView!
    var alertBoxView: UIView!
    var title: UILabel!
    var message: UILabel!
    var NLabel: UILabel!
    var ELabel: UILabel!
    var NTextField: UITextField!
    var ETextField: UITextField!
    var NDegreeLabel: UILabel!
    var EDegreeLabel: UILabel!
    var NRestTextField: UITextField!
    var ERestTextField: UITextField!
    var lineHorizontal: UIView!
    var lineVertical: UIView!
    
    var buttonOK: UIButton!
    var buttonCancel: UIButton!
    
    var x: CGFloat!
    var y: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        backgroundView = UIView(frame: frame)
        backgroundView.backgroundColor = Farbe.schwarz
        backgroundView.alpha = 0
        self.addSubview(backgroundView)
        
        x = frame.width/2.0 - viewWidth/2.0
        y = 80
        
        alertBoxView = UIView(frame: CGRect(x: self.x, y: self.frame.size.height, width: self.viewWidth, height: self.viewHeight))
        alertBoxView.backgroundColor = Farbe.weiß
        alertBoxView.alpha = 0.9
        alertBoxView.layer.cornerRadius = 10
        self.addSubview(alertBoxView)
        
        containerView = UIView(frame: CGRect(x: self.x, y: self.frame.size.height, width: self.viewWidth, height: self.viewHeight))
        containerView.layer.cornerRadius = 10
        
        let yN = 80
        let yE = 115
        let yLine = viewHeight - 40
        let marginLeft = 30
        let x2 = 46
        let x3 = 85
        let x4 = 115
        
        title = UILabel(frame: CGRect(x: 0, y: 0, width: viewWidth, height: 70))
        title.textAlignment = .center
        title.text = NSLocalizedString("Insert coordinates", comment: "Insert Coordinates")
        title.font = Font().avenir(.Bold, size: 18)
        containerView.addSubview(title)
        
        message = UILabel(frame: CGRect(x: 0, y: 45, width: viewWidth, height: 30))
        message.textAlignment = .center
        message.text = NSLocalizedString("Please enter your coordinates here.", comment: "Insert Coordinates")
        message.font = Font().avenir(.Regular, size: 14)
        containerView.addSubview(message)
        
        NLabel = UILabel(frame: CGRect(x: marginLeft, y: yN, width: 30, height: 30))
        NLabel.text = "N"
        containerView.addSubview(NLabel)
        
        NTextField = UITextField(frame: CGRect(x: x2, y: yN, width: 35, height: 30))
        NTextField.borderStyle = .roundedRect
        NTextField.text = "49"
        NTextField.keyboardType = .numberPad
        NTextField.delegate = self
        NTextField.tag = 2
        containerView.addSubview(NTextField)
        
        NDegreeLabel = UILabel(frame: CGRect(x: x3, y: yN, width: 30, height: 30))
        NDegreeLabel.text = "°   ."
        containerView.addSubview(NDegreeLabel)
        
        NRestTextField = UITextField(frame: CGRect(x: x4, y: yN, width: Int(viewWidth/2) - marginLeft, height: 30))
        NRestTextField.borderStyle = .roundedRect
        NRestTextField.text = "6608373"
        NRestTextField.keyboardType = .numberPad
        NRestTextField.delegate = self
        NRestTextField.tag = 3
        containerView.addSubview(NRestTextField)
        
        ELabel = UILabel(frame: CGRect(x: marginLeft, y: yE, width: 30, height: 30))
        ELabel.text = "E"
        containerView.addSubview(ELabel)
        
        ETextField = UITextField(frame: CGRect(x: x2, y: yE, width: 35, height: 30))
        ETextField.borderStyle = .roundedRect
        ETextField.text = "10"
        ETextField.keyboardType = .numberPad
        ETextField.delegate = self
        ETextField.tag = 2
        containerView.addSubview(ETextField)
        
        EDegreeLabel = UILabel(frame: CGRect(x: x3, y: yE, width: 30, height: 30))
        EDegreeLabel.text = "°   ."
        containerView.addSubview(EDegreeLabel)
        
        ERestTextField = UITextField(frame: CGRect(x: x4, y: yE, width: Int(viewWidth/2) - marginLeft, height: 30))
        ERestTextField.borderStyle = .roundedRect
        ERestTextField.text = "060341"
        ERestTextField.keyboardType = .numberPad
        ERestTextField.delegate = self
        ERestTextField.tag = 3
        containerView.addSubview(ERestTextField)
        
        lineHorizontal = UIView(frame: CGRect(x: 0, y: Int(yLine), width: Int(viewWidth), height: 1))
        lineHorizontal.backgroundColor = UIColor.lightGray()
        containerView.addSubview(lineHorizontal)
        
        lineVertical = UIView(frame: CGRect(x: Int(viewWidth/2), y: Int(yLine), width: 1, height: 40))
        lineVertical.backgroundColor = UIColor.lightGray()
        containerView.addSubview(lineVertical)
        
        buttonCancel = UIButton(frame: CGRect(x: 0, y: Int(yLine), width: Int(viewWidth/2), height: 40))
        buttonCancel.setTitle(NSLocalizedString("Cancel", comment: "Cancel-Button"), for: .normal)
        buttonCancel.addTarget(self, action: #selector(cancelClicked), for: .touchUpInside)
        containerView.addSubview(buttonCancel)
        buttonCancel.setTitleColor(Farbe.cacheBlau, for: .normal)
        
        buttonOK = UIButton(frame: CGRect(x: Int(viewWidth/2), y: Int(yLine), width: Int(viewWidth/2), height: 40))
        buttonOK.setTitle(NSLocalizedString("Go!", comment: "Go!"), for: .normal)
        buttonOK.addTarget(self, action: #selector(okClicked), for: .touchUpInside)
        buttonOK.setTitleColor(Farbe.cacheBlau, for: .normal)
        containerView.addSubview(buttonOK)
        
        self.addSubview(containerView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        backgroundView.alpha = 0.5
        
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
            self.containerView.frame = CGRect(x: self.x, y: self.y, width: self.viewWidth, height: self.viewHeight)
            self.alertBoxView.frame = CGRect(x: self.x, y: self.y, width: self.viewWidth, height: self.viewHeight)
            self.layoutIfNeeded()
            self.NRestTextField.becomeFirstResponder()
        }) { (complete) in
        }
    }
    
    func hide() {
        backgroundView.alpha = 0

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.containerView.frame = CGRect(x: self.x, y: self.frame.size.height, width: self.viewWidth, height: self.viewHeight)
            self.alertBoxView.frame = CGRect(x: self.x, y: self.frame.size.height, width: self.viewWidth, height: self.viewHeight)
            self.layoutIfNeeded()
        }) { (complete) in
            self.removeFromSuperview()
        }
    }
    
    func okClicked() {
        
        NRestTextField.text = NRestTextField.text!.isEmpty ? "0" : NRestTextField.text
        ERestTextField.text = ERestTextField.text!.isEmpty ? "0" : ERestTextField.text
        
        guard let N = NTextField.text else { return }
        guard let NRest = NRestTextField.text else { return }
        guard let E = ETextField.text else { return }
        guard let ERest = ERestTextField.text else { return }
        
        if let lat = Double("\(N).\(NRest)"),
            let lon = Double("\(E).\(ERest)") {
            delegate?.enterCoordsButtonOKClicked(lat: lat, lon: lon)
            self.endEditing(true)
            hide()
        }
        
    }
    
    func cancelClicked() {
        self.endEditing(true)
        delegate?.enterCoordsButtonCancelClicked()
        hide()
    }
    
    //MARK: - UITextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.characters.count == 0 {
            return true
        }
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        switch textField.tag {
        case 2: return prospectiveText.isNumeric() && prospectiveText.characters.count <= 2
        case 3: return prospectiveText.isNumeric() && prospectiveText.characters.count <= 8
        default:
            return true
        }
    }
}

protocol EnterCoordsAlertViewDelegate {
    func enterCoordsButtonOKClicked(lat: Double, lon: Double)
    func enterCoordsButtonCancelClicked()
}
