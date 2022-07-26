//
//  SettingsTableFooter.swift
//  VUCCI
//
//  Created by Jason bartley on 5/28/22.
//

import UIKit

protocol SettingsTableFooterDelegate: AnyObject {
    func SettingTableFooterDidTapSignOut()
}

class SettingsTableFooter: UIView {
    
    public weak var delegate: SettingsTableFooterDelegate?

    private let signOutLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.text = "SIGN OUT"
        label.isUserInteractionEnabled = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(signOutLabel)
        
        let signOutTap = UITapGestureRecognizer(target: self, action: #selector(didTapSignOut))
        signOutLabel.addGestureRecognizer(signOutTap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        signOutLabel.frame = CGRect(x: 10, y: 10, width: width - 20, height: 40)
    }
    
    @objc func didTapSignOut() {
        delegate?.SettingTableFooterDidTapSignOut()
    }
    
    
    
}
