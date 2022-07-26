//
//  AccountNameView.swift
//  VUCCI
//
//  Created by Jason bartley on 4/13/22.
//

import UIKit

protocol AccountNameViewDelegate: AnyObject {
    func AccountNameViewDelegateDidTapShowMore(_ view: AccountNameView, isShowing: Bool)
}

class AccountNameView: UIView {
    
    public weak var delegate: AccountNameViewDelegate?
    
    public var isShowing = false

    public let accountNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.text = ""
        label.font = .systemFont(ofSize: 25, weight: .thin)
        return label
    }()
    
    public let showMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("SHOW MORE", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 0.4
        button.layer.cornerRadius = 17
        button.backgroundColor = .systemBackground
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(accountNameLabel)
        addSubview(showMoreButton)
        showMoreButton.addTarget(self, action: #selector(didTapShowMore), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        accountNameLabel.frame = CGRect(x: 10, y: 5, width: width - 20, height: 45)
        showMoreButton.frame = CGRect(x: (width-170)/2, y: accountNameLabel.bottom + 4, width: 170, height: 34)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapShowMore() {
        if isShowing == true {
            delegate?.AccountNameViewDelegateDidTapShowMore(self, isShowing: true)
            isShowing = false
        } else {
            delegate?.AccountNameViewDelegateDidTapShowMore(self, isShowing: false)
            isShowing = true
        }
    }
    
}
