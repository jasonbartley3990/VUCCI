//
//  VucciTextField.swift
//  VUCCI
//
//  Created by Jason bartley on 4/13/22.
//

import UIKit

class VucciTextField: UITextField {

    override init(frame: CGRect){
        super.init(frame: frame)
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        leftViewMode = .always
        layer.cornerRadius = 8
        layer.borderWidth = 1
        backgroundColor = .systemBackground
        layer.borderColor = UIColor.systemBackground.cgColor
        let labelPlaceholderText = NSAttributedString(string: "  ",attributes: [NSAttributedString.Key.foregroundColor: UIColor.label])
        attributedPlaceholder = labelPlaceholderText
        autocapitalizationType = .none
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
