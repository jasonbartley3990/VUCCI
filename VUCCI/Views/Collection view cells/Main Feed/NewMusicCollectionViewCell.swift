//
//  NewSongCollectionViewCell.swift
//  VUCCI
//
//  Created by Jason bartley on 4/18/22.
//

import UIKit

class NewMusicCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "NewMusicCollectionViewCell"
    
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
    
    public func configure(with model: NewMusicPostViewModel) {
        self.container.contentNameLabel.text = "\(model.contentName.uppercased())"
        self.container.poster = model.contentCreator
        self.container.contentId = model.contentId
        var creator: String = ""
       
        DatabaseManager.shared.findAUserWithId(userId: model.contentCreator, completion: {
            [weak self] user in
            guard let artistName = user?.artistName else {return}
            creator = artistName
            
            if model.contentType == "song" {
                self?.container.contentCreatorName.text = "BY: \(creator.uppercased())"
                self?.container.contentType = .song
            } else if model.contentType == "album" {
                self?.container.contentCreatorName.text = "ALBUM BY: \(creator.uppercased())"
                self?.container.contentType = .album
            }
            
            self?.container.titleLabel.text = "New Music By: \(creator)"
            
        })
        
        guard let imageUrl = URL(string: model.songImageUrl) else {return}
        self.container.musicImage.sd_setImage(with: imageUrl)
        
    }
}
