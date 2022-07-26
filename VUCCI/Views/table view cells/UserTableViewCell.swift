//
//  UserTableViewCell.swift
//  VUCCI
//
//  Created by Jason bartley on 4/21/22.
//

import UIKit
import SDWebImage

class UserTableViewCell: UITableViewCell {
    
    static let identifier = "UserTableViewCell"

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .thin)
        label.textAlignment = .left
        label.textColor = .label
        label.text = ""
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let ImageSize: CGFloat = contentView.height*0.75
        let labelWidth: CGFloat = (contentView.width - ImageSize - 70)
        
        profileImageView.frame = CGRect(x: 25, y: (contentView.height - ImageSize)/2, width: ImageSize, height: ImageSize)
        usernameLabel.frame = CGRect(x: profileImageView.right + 10, y: (contentView.height - (contentView.height * 0.65))/2, width: labelWidth, height: contentView.height * 0.65)
    }
    
    public func configure(with user: User) {
        if user.isAnArtistAccount {
            usernameLabel.text = user.artistName?.uppercased()
        } else {
            usernameLabel.text = user.username.uppercased()
        }
        
        StorageManager.shared.profilePictureUrl(for: user.userId, completion: {
            [weak self] url in
            guard let url = url else {return}
            self?.profileImageView.sd_setImage(with: url)
        })
    }
}
