//
//  MoreInfoView.swift
//  VUCCI
//
//  Created by Jason bartley on 4/13/22.
//

import UIKit

protocol MoreInfoViewDelegate: AnyObject {
    func MoreInfoViewDidTapFollowing(_ view: MoreInfoView)
    func MoreInfoViewDidTapFollowers(_ view: MoreInfoView)
}

class MoreInfoView: UIView {

    public weak var delegate: MoreInfoViewDelegate?
    
    public let accountNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.text = ""
        label.font = .systemFont(ofSize: 21, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        return label
    }()
    
    
    private let followersNumberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.text = "0"
        label.font = .systemFont(ofSize: 21, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let followingNumberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.text = "0"
        label.font = .systemFont(ofSize: 21, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let followersTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.text = "FOLLOWERS"
        label.font = .systemFont(ofSize: 17, weight: .thin)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let followingTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "FOLLOWING"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .thin)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let accountTypeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Account Type: LISTENER"
        label.textColor = .label
        label.font = .systemFont(ofSize: 22, weight: .thin)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(followersNumberLabel)
        addSubview(followingNumberLabel)
        addSubview(followersTextLabel)
        addSubview(followingTextLabel)
        addSubview(accountTypeLabel)
        addSubview(accountNameLabel)
        
        let tapFollowerCount = UITapGestureRecognizer(target: self, action: #selector(didTapFollowers))
        let tapFollowerLabel = UITapGestureRecognizer(target: self, action: #selector(didTapFollowers))
        let tapFollowingLabel = UITapGestureRecognizer(target: self, action: #selector(didTapFollowing))
        let tapFollowingCount = UITapGestureRecognizer(target: self, action: #selector(didTapFollowing))
        
        followersNumberLabel.addGestureRecognizer(tapFollowerCount)
        followersTextLabel.addGestureRecognizer(tapFollowerLabel)
        followingNumberLabel.addGestureRecognizer(tapFollowingLabel)
        followingTextLabel.addGestureRecognizer(tapFollowingCount)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        accountNameLabel.frame = CGRect(x: 10, y: 70, width: width - 20 , height: 40)
        followingTextLabel.frame = CGRect(x: ((width/2) - 150), y: followersNumberLabel.bottom - 3, width: 150, height: 40)
        followersTextLabel.frame = CGRect(x: (width/2), y: followersNumberLabel.bottom - 3, width: 150, height: 40)
        accountTypeLabel.frame = CGRect(x: 10, y: followersTextLabel.bottom + 25, width: width - 20, height: 30)
       
        followingNumberLabel.centerXAnchor.constraint(equalTo: followingTextLabel.centerXAnchor).isActive = true
        followingNumberLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        followingNumberLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        followingNumberLabel.topAnchor.constraint(equalTo: accountNameLabel.bottomAnchor, constant: 110).isActive = true
        
        followersNumberLabel.centerXAnchor.constraint(equalTo: followersTextLabel.centerXAnchor).isActive = true
        followersNumberLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        followersNumberLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        followersNumberLabel.topAnchor.constraint(equalTo: accountNameLabel.bottomAnchor, constant: 110).isActive = true
        
    }
    
    func configure(info: UserInfo) {
        accountNameLabel.text = "\(info.accountName.uppercased())"
        followersNumberLabel.text = String(info.followerCount)
        followingNumberLabel.text = String(info.followingCount)
        
        if info.followerCount == 1 {
            followersTextLabel.text = "FOLLOWER"
        }
        
        if info.isAnArtist {
            accountTypeLabel.text = "Account Type: ARTIST"
        } else {
            accountTypeLabel.text = "Account Type: LISTENER"
        }
        
    }
    
    @objc func didTapFollowing() {
        delegate?.MoreInfoViewDidTapFollowing(self)
    }
    
    @objc func didTapFollowers() {
        delegate?.MoreInfoViewDidTapFollowers(self)
    }
    
    @objc func updateFollowingCount(didFollow: Bool) {
        guard let followingCount = followingNumberLabel.text else {return}
        guard var followingCountInt = Int(followingCount) else {return}
                
        if didFollow {
            followingCountInt += 1
            followingNumberLabel.text = String(followingCountInt)
        } else {
            followingCountInt -= 1
            followingNumberLabel.text = String(followingCountInt)
        }
    }
    
}
