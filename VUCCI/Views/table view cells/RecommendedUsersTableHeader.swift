//
//  RecommendedUsersTableHeader.swift
//  VUCCI
//
//  Created by Jason bartley on 6/3/22.
//

import UIKit

protocol RecommendedUsersTableHeaderDelegate: AnyObject {
    func recommendedUsersTableHeaderDidTapFindUsers()
}

class RecommendedUsersTableHeader: UIView {
    
    public weak var delegate: RecommendedUsersTableHeaderDelegate?

    private let notFollowingAnybodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .thin)
        label.text = "Your Not Following Anybody!"
        return label
    }()
    
    private let findUsersButton: UILabel = {
        let label = UILabel()
        label.text = "FIND USERS"
        label.textColor = .white
        label.backgroundColor = .systemGreen
        label.layer.cornerRadius = 20
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        return label
    }()
    
    public let recommendedUsersLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .thin)
        label.text = "Recommended Users"
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(findUsersButton)
        addSubview(recommendedUsersLabel)
        addSubview(notFollowingAnybodyLabel)
        
        let findUsersTap = UITapGestureRecognizer(target: self, action: #selector(didTapRecommendedUsers))
        findUsersButton.addGestureRecognizer(findUsersTap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        notFollowingAnybodyLabel.frame = CGRect(x: 10, y: 20, width: width - 20, height: 30)
        findUsersButton.frame = CGRect(x: (width - 130)/2, y: notFollowingAnybodyLabel.bottom + 15, width: 130, height: 40)
        recommendedUsersLabel.frame = CGRect(x: 10, y: findUsersButton.bottom + 40, width: width - 20, height: 30)
    }
    
    
    @objc func didTapRecommendedUsers() {
        delegate?.recommendedUsersTableHeaderDidTapFindUsers()
    }
    
}
