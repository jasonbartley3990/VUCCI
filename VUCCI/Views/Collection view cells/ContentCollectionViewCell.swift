//
//  ContentCollectionViewCell.swift
//  VUCCI
//
//  Created by Jason bartley on 4/14/22.
//

import UIKit

protocol ContentCollectionViewCellDelegate: AnyObject {
    func ContentCollectionViewCellDidTapMore(content: Content)
}

class ContentCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ContentCollectionViewCell"
    
    public weak var delegate: ContentCollectionViewCellDelegate?
    
    private var content: Content?
    
    private var contentImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    private var contentTitle: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .thin)
        label.textAlignment = .left
        return label
    }()
    
    private var contentSubtitle: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .thin)
        label.textAlignment = .left
        return label
    }()
    
    private var otherOptionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .thin)
        label.isHidden = true
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.isUserInteractionEnabled = false
        button.isHidden = true
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        addSubview(contentImage)
        addSubview(contentTitle)
        addSubview(contentSubtitle)
        addSubview(moreButton)
        addSubview(otherOptionLabel)
        
        moreButton.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let songImageSize: CGFloat = contentView.height*0.75
        let labelWidth: CGFloat = (contentView.width - songImageSize - 90)
        
        contentImage.frame = CGRect(x: 30, y: (contentView.height - songImageSize)/2, width: songImageSize, height: songImageSize)
        contentTitle.frame = CGRect(x: contentImage.right + 10, y: contentView.top + 4, width: labelWidth, height: contentView.height/2.1)
        contentSubtitle.frame = CGRect(x: contentImage.right + 10, y: contentTitle.bottom - 5, width: labelWidth, height: contentView.height/2.2)
        moreButton.frame = CGRect(x: contentView.width - 50, y: (contentView.height - 50)/2 , width: 35, height: 35)
        
        otherOptionLabel.frame = CGRect(x: 10, y: (contentView.height - 40)/2, width: contentView.width - 20, height: 40)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentImage.image = nil
        contentTitle.text = nil
        contentSubtitle.text = nil
        contentTitle.textColor = .label
        contentSubtitle.textColor = .label
        otherOptionLabel.text = nil
        contentImage.isHidden = false
        contentTitle.isHidden = false
        contentSubtitle.isHidden = false
        otherOptionLabel.isHidden = true
        
    }
    
    func configure(with model: Content) {
        if model.name == "NO RELEASED SONGS" || model.name == "NO PUBLIC PLAYLISTS" || model.name == "NO RELEASED ALBUMS"  || model.name == "SEE MORE SONGS" || model.name == "SEE MORE PLAYLISTS" {
            configureCellForOther(content: model)
        }
        
        guard let imageUrl = URL(string: model.imageUrl) else {
            return
        }
        
        self.contentImage.sd_setImage(with: imageUrl)
        self.content = model
        contentTitle.text = model.name.uppercased()
        
        
        if model.isAlbum {
            contentSubtitle.text = "AN ALBUM BY: \(model.ArtistName.uppercased())"
        }
        
        if model.isSong {
            contentSubtitle.text = model.ArtistName.uppercased()
            self.moreButton.isHidden = false
            self.moreButton.isUserInteractionEnabled = true
        }
        
        if model.isPlaylist {
            DatabaseManager.shared.findAUserWithId(userId: model.contentCreator, completion: {
                [weak self] user in
                guard let user = user else {
                    return
                }
                if user.isAnArtistAccount {
                    self?.contentSubtitle.text = "A PLAYLIST BY: \(user.artistName!.uppercased())"
                } else {
                    self?.contentSubtitle.text = "A PLAYLIST BY: \(user.username.uppercased())"
                }
            })
        }
        
        guard let currentSong = SharedSongManager.shared.currentSong else {return}
        
        if model.contentId == currentSong.contentId {
            configureForSongPlaying()
        }
        
        
    }
    
    func configureCellForOther(content: Content) {
        otherOptionLabel.text = content.name
        
        DispatchQueue.main.async { [weak self] in
            self?.moreButton.isHidden = true
            self?.contentImage.isHidden = true
            self?.contentSubtitle.isHidden = true
            self?.contentTitle.isHidden = true
            self?.otherOptionLabel.isHidden = false
        }
        
    }
    
    public func configureForSongPlaying() {
        DispatchQueue.main.async { [weak self] in
            self?.contentSubtitle.textColor = .systemGreen
            self?.contentTitle.textColor = .systemGreen
        }
    }
    
    public func configureForSongNotPlaying() {
        DispatchQueue.main.async { [weak self] in
            self?.contentSubtitle.textColor = .label
            self?.contentTitle.textColor = .label
        }
    }
    
    @objc func didTapMore() {
        guard let content = self.content else {return}
        delegate?.ContentCollectionViewCellDidTapMore(content:  content)
    }
    
    
}
