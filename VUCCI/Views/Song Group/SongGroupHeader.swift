//
//  SongGroupHeader.swift
//  VUCCI
//
//  Created by Jason bartley on 4/12/22.
//

import UIKit

protocol SongGroupHeaderDelegate: AnyObject {
    func SongGroupHeaderDelegateDidTapArtist(artistId: String)
}

class SongGroupHeader: UIView {
    
    public weak var delegate: SongGroupHeaderDelegate?
    
    private var content: Content?
    
    private let SongGroupImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    private let SongGroupNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 22, weight: .thin)
        return label
    }()
    
    private let SongGroupArtistOrCreatorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(SongGroupImage)
        addSubview(SongGroupNameLabel)
        addSubview(SongGroupArtistOrCreatorLabel)
        
        let artistTap = UITapGestureRecognizer(target: self, action: #selector(didTapArtist))
        SongGroupArtistOrCreatorLabel.addGestureRecognizer(artistTap)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = width * 0.7
        SongGroupImage.frame = CGRect(x: ((width - size)/2), y: ((width - size)/2), width: size, height: size)
        SongGroupNameLabel.frame = CGRect(x: 10, y: SongGroupImage.bottom + 25, width: width - 20, height: 30)
        SongGroupArtistOrCreatorLabel.frame = CGRect(x: 10, y: SongGroupNameLabel.bottom + 10, width: width - 20, height: 20)
    }
    
    
    func configure(with model: Content) {
        self.content = model
        let url = URL(string: model.imageUrl)
        SongGroupImage.sd_setImage(with: url)
        
        SongGroupNameLabel.text = model.name
        
        DatabaseManager.shared.findAUserWithId(userId: model.contentCreator , completion: {
            [weak self] user in
            guard let user = user else {return}
            if let artistName = user.artistName {
                if model.isAlbum {
                    self?.SongGroupArtistOrCreatorLabel.text = "AN ALBUM BY: \(artistName.uppercased())"
                } else if model.isPlaylist {
                    self?.SongGroupArtistOrCreatorLabel.text = "A PLAYLIST BY: \(artistName.uppercased())"
                }
            } else {
                if model.isAlbum {
                    self?.SongGroupArtistOrCreatorLabel.text = "AN ALBUM BY: \(user.username.uppercased())"
                } else if model.isPlaylist {
                    self?.SongGroupArtistOrCreatorLabel.text = "A PLAYLIST BY: \(user.username.uppercased())"
                }
            }
        })
    }
    
    @objc func didTapArtist() {
        guard let album = self.content else {return}
        delegate?.SongGroupHeaderDelegateDidTapArtist(artistId: album.contentCreator)
    }
}
