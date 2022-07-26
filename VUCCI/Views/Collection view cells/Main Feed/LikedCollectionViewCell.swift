//
//  LikedCollectionViewCell.swift
//  VUCCI
//
//  Created by Jason bartley on 4/25/22.
//

import UIKit

class LikedCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "LikedCollectionViewCell"
    
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
    
    public func configure(with model: LikeCellPostViewModel) {
        self.container.contentNameLabel.text = "\(model.contentName.uppercased())"
        self.container.poster = model.posterId
        self.container.contentId = model.contentId
        
        var contentCreator: String = ""
        
        DatabaseManager.shared.findAUserWithId(userId: model.contentCreatorName, completion: {
            [weak self] user in
            guard let user = user else {return}
            if user.isAnArtistAccount {
                guard let artistName = user.artistName else {return}
                contentCreator = artistName
            } else {
                contentCreator = user.username
            }
            
            if model.contentType == "song" {
                self?.container.contentType = .song
                self?.container.contentCreatorName.text = "BY: \(contentCreator.uppercased())"
            } else if model.contentType == "album" {
                self?.container.contentType = .album
                self?.container.contentCreatorName.text = "AN ALBUM BY: \(contentCreator.uppercased())"
            } else if model.contentType == "playlist" {
                self?.container.contentType = .playlist
                self?.container.contentCreatorName.text = "A PLAYLIST BY \(contentCreator.uppercased())"
            }
        })
        
        DatabaseManager.shared.findAUserWithId(userId: model.posterId, completion: {
            [weak self] user in
            guard let user = user else {return}
            
            if user.isAnArtistAccount {
                guard let artistName = user.artistName else {return}
                self?.container.titleLabel.text = "\(artistName) Liked"
            } else {
                self?.container.titleLabel.text  = "\(user.username) Liked"
            }
        })
        
        
        guard let imageUrl = URL(string: model.songImageUrl) else {return}
        container.musicImage.sd_setImage(with: imageUrl)
        
    }
    
}

