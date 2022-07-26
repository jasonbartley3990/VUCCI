//
//  NewPlaylistPostCollectionViewCell.swift
//  VUCCI
//
//  Created by Jason bartley on 4/25/22.
//

import UIKit

class NewPlaylistPostCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "NewPlaylistPostCollectionViewCell"
    
    public let container: PostContainerView = {
        let container = PostContainerView()
        container.layer.cornerRadius = 15
        container.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        container.layer.borderWidth = 2
        return container
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(container)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let containerWidth: CGFloat = contentView.width * 0.9
        let containerHeight: CGFloat = contentView.height * 0.94
        container.frame = CGRect(x: (contentView.width - containerWidth)/2 , y: (contentView.height - containerHeight)/2, width: containerWidth, height: containerHeight)
    }
    
    public func configure(with model: NewPlaylistPostViewModel) {
        self.container.contentNameLabel.text = "\(model.playlistName.uppercased())"
        self.container.poster = model.playlistCreator
        self.container.contentId = model.contentId
        self.container.contentType = .playlist
       
        DatabaseManager.shared.findAUserWithId(userId: model.playlistCreator, completion: {
            [weak self] user in
            guard let user = user else {return}
            if user.isAnArtistAccount {
                guard let artistName = user.artistName else {return}
                self?.container.contentCreatorName.text = "BY: \(artistName.uppercased())"
                self?.container.titleLabel.text = "New Playlist By: \(artistName)"
            } else {
                self?.container.contentCreatorName.text = "BY: \(user.username.uppercased())"
                self?.container.titleLabel.text = "New Playlist By: \(user.username)"
            }
            
        })
        
        guard let imageUrl = URL(string: model.playlistImageUrl) else {return}
        self.container.musicImage.sd_setImage(with: imageUrl)
    }
}
