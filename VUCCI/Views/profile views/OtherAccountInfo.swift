//
//  OtherAccountInfo.swift
//  VUCCI
//
//  Created by Jason bartley on 4/20/22.
//

import UIKit

protocol OtherAccountInfoDelegate: AnyObject {
    func OtherAccountInfoDidTapFollow(_ view: OtherAccountInfo, isFollowing: Bool)
    func OtherAccountInfoDidTapFollowers(_ view: OtherAccountInfo)
    func OtherAccountInfoDidTapFollowing(_ view: OtherAccountInfo)
}

class OtherAccountInfo: UIView {

    public weak var delegate: OtherAccountInfoDelegate?
    
    private var isFollowing: Bool = false
    
    private let accountNameLabel: UILabel = {
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
        label.font = .systemFont(ofSize: 20, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let followingNumberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.text = "0"
        label.font = .systemFont(ofSize: 20, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let followersTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.text = "FOLLOWERS"
        label.font = .systemFont(ofSize: 16, weight: .thin)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let followingTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "FOLLOWING"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .thin)
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
    
    private let followButton: UILabel = {
        let label = UILabel()
        label.text = "FOLLOW"
        label.textColor = .white
        label.backgroundColor = .systemGreen
        label.layer.cornerRadius = 20
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(followersTextLabel)
        addSubview(followersNumberLabel)
        addSubview(followingTextLabel)
        addSubview(followingNumberLabel)
        addSubview(accountTypeLabel)
        addSubview(followButton)
        addSubview(accountNameLabel)
        
        let tapFollowerCount = UITapGestureRecognizer(target: self, action: #selector(didTapFollowers))
        let tapFollowerLabel = UITapGestureRecognizer(target: self, action: #selector(didTapFollowers))
        let tapFollowingLabel = UITapGestureRecognizer(target: self, action: #selector(didTapFollowing))
        let tapFollowingCount = UITapGestureRecognizer(target: self, action: #selector(didTapFollowing))
        
        followersNumberLabel.addGestureRecognizer(tapFollowerCount)
        followersTextLabel.addGestureRecognizer(tapFollowerLabel)
        followingNumberLabel.addGestureRecognizer(tapFollowingLabel)
        followingTextLabel.addGestureRecognizer(tapFollowingCount)
        
        let followUnfollowTap = UITapGestureRecognizer(target: self, action: #selector(didTapFollow))
        followButton.addGestureRecognizer(followUnfollowTap)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        accountNameLabel.frame = CGRect(x: 10, y: 30, width: width - 20 , height: 40)
        followingTextLabel.frame = CGRect(x: ((width/2) - 150), y: followersNumberLabel.bottom - 3, width: 150, height: 40)
        followersTextLabel.frame = CGRect(x: (width/2), y: followersNumberLabel.bottom - 3, width: 150, height: 40)
        accountTypeLabel.frame = CGRect(x: 10, y: followersTextLabel.bottom + 13, width: width - 20, height: 30)
        followButton.frame = CGRect(x: (width - 120)/2, y: accountTypeLabel.bottom + 20, width: 120, height: 40)
        
        
        followingNumberLabel.centerXAnchor.constraint(equalTo: followingTextLabel.centerXAnchor).isActive = true
        followingNumberLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        followingNumberLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        followingNumberLabel.topAnchor.constraint(equalTo: accountNameLabel.bottomAnchor, constant: 70).isActive = true
        
        followersNumberLabel.centerXAnchor.constraint(equalTo: followersTextLabel.centerXAnchor).isActive = true
        followersNumberLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        followersNumberLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        followersNumberLabel.topAnchor.constraint(equalTo: accountNameLabel.bottomAnchor, constant: 70).isActive = true
    }
    
    func configure(with info: UserInfo) {
        accountNameLabel.text = "\(info.accountName.uppercased())"
        followersNumberLabel.text = String(info.followerCount)
        followingNumberLabel.text = String(info.followingCount)
        
        if info.followerCount == 1 {
            followersTextLabel.text = "FOLLOWER"
        }
        
        if info.isAnArtist {
            accountTypeLabel.text = "Account Type: ARTIST"
        } else {
            accountTypeLabel.text = "Acount Type: LISTENER"
        }
        
    }
    
    func configureFollowing(isFollowing: Bool) {
        self.isFollowing = isFollowing
        
        if isFollowing {
            DispatchQueue.main.async { [weak self] in
                self?.followButton.text = "UNFOLLOW"
                self?.followButton.textColor = .label
                self?.followButton.backgroundColor = .systemBackground
                self?.followButton.layer.borderWidth = 0.5
                self?.followButton.layer.borderColor = UIColor.label.cgColor
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.followButton.text = "FOLLOW"
                self?.followButton.textColor = .white
                self?.followButton.backgroundColor = .systemGreen
                self?.followButton.layer.borderWidth = 0
                self?.followButton.layer.borderColor = UIColor.systemGreen.cgColor
            }
        }
        
        
    }
    
    @objc func didTapFollow() {
        guard let currentFollowerCount = self.followersNumberLabel.text else {return}
        guard var followerCountInt = Int(currentFollowerCount) else {return}
        
        if self.isFollowing {
            configureFollowing(isFollowing: false)
            delegate?.OtherAccountInfoDidTapFollow(self, isFollowing: true)
            followerCountInt -= 1
            self.followersNumberLabel.text = String(followerCountInt)
            if followerCountInt == 1 {
                followersTextLabel.text = "FOLLOWER"
            } else {
                followersTextLabel.text = "FOLLOWERS"
            }
        } else {
            configureFollowing(isFollowing: true)
            delegate?.OtherAccountInfoDidTapFollow(self, isFollowing: false)
            followerCountInt += 1
            self.followersNumberLabel.text = String(followerCountInt)
            if followerCountInt == 1 {
                followersTextLabel.text = "FOLLOWER"
            } else {
                followersTextLabel.text = "FOLLOWERS"
            }
        }
    }
    
    @objc func didTapFollowers() {
        delegate?.OtherAccountInfoDidTapFollowers(self)
    }
    
    @objc func didTapFollowing() {
        delegate?.OtherAccountInfoDidTapFollowing(self)
    }
}
