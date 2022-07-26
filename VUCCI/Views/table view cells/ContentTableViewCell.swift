//
//  ContentTableViewCell.swift
//  VUCCI
//
//  Created by Jason bartley on 2/18/22.
//

import UIKit

protocol ContentTableViewCellDelegate: AnyObject {
    func contentTableViewCellDidTapEditButton(_ view: ContentTableViewCell)
    func contentTableViewCellDidTapMore(_ view: ContentTableViewCell)
}

class ContentTableViewCell: UITableViewCell {
    
    static let identifier = "ContentTableViewCell"
    
    public var content: Content?
    
    public var rank: Int = 0
    
    public weak var delegate: ContentTableViewCellDelegate?

    private let contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .thin)
        label.textAlignment = .left
        label.textColor = .label
        return label
    }()
    
    private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.textColor = .label
        return label
    }()
    
    let moreButton: UIButton = {
       let button = UIButton()
        let image = UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))
        button.setImage(image, for: .normal)
        button.tintColor = .darkGray
        button.isHidden = true
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let rankNumber: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "1"
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .thin)
        return label
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(contentImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(rankNumber)
        contentView.addSubview(moreButton)
        
        moreButton.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.textColor = .label
        self.subtitleLabel.textColor = .label
        moreButton.isHidden = true
        moreButton.isUserInteractionEnabled = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let songImageSize: CGFloat = contentView.height*0.75
        let labelWidth: CGFloat = (contentView.width - songImageSize - 70 - 55)
        
        contentImageView.frame = CGRect(x: 20, y: (contentView.height - songImageSize)/2, width: songImageSize, height: songImageSize)
        titleLabel.frame = CGRect(x: contentImageView.right + 10, y: contentView.top + 10, width: labelWidth, height: contentView.height/2.1)
        subtitleLabel.frame = CGRect(x: contentImageView.right + 10, y: titleLabel.bottom - 10, width: labelWidth, height: contentView.height/2.2)
        moreButton.frame = CGRect(x: contentView.width - 50, y: (contentView.height - 50)/2 , width: 35, height: 35)
    }
    
    public func configure(with model: Content, index: Int) {
        self.content = model
        self.rank = index
        
        if model.isArtist {
            titleLabel.text = model.name.uppercased()
            subtitleLabel.text = "ARTIST"
        } else if model.isAlbum {
            titleLabel.text = model.name.uppercased()
            subtitleLabel.text = "AN ALBUM BY \(model.ArtistName.uppercased())"
        } else if model.isSong {
            titleLabel.text = model.name.uppercased()
            subtitleLabel.text = "BY \(model.ArtistName.uppercased())"
            moreButton.isHidden = false
            moreButton.isUserInteractionEnabled = true
        } else if model.isPlaylist {
            titleLabel.text = model.name.uppercased()
            DatabaseManager.shared.findAUserWithId(userId: model.contentCreator, completion: {
                [weak self] user in
                guard let creator = user else {return}
                if creator.isAnArtistAccount {
                    if let artistName = creator.artistName {
                        self?.subtitleLabel.text = "A PLAYLIST BY: \(artistName.uppercased())"
                    } else {
                        self?.subtitleLabel.text = "A PLAYLIST BY: \(creator.username.uppercased())"
                    }
                } else {
                    self?.subtitleLabel.text = "A PLAYLIST BY: \(creator.username.uppercased()) "
                }
            })
        }
        
        let imageUrl = URL(string: model.imageUrl)
        
        DispatchQueue.main.async { [weak self] in
            self?.contentImageView.sd_setImage(with: imageUrl, completed: nil)
        }
        
        guard let currentSong = SharedSongManager.shared.currentSong else {return}
        if model.contentId == currentSong.contentId {
            configureForSongPlaying()
        }
        
        
    }
    
    @objc func didTapEdit() {
        delegate?.contentTableViewCellDidTapEditButton(self)
    }
    
    public func configureForSongPlaying() {
        DispatchQueue.main.async { [weak self] in
            self?.titleLabel.textColor = .systemGreen
            self?.subtitleLabel.textColor = .systemGreen
        }
    }
    
    public func configureForSongNotPlaying() {
        DispatchQueue.main.async { [weak self] in
            self?.titleLabel.textColor = .label
            self?.subtitleLabel.textColor = .label
        }
    }
    
    @objc func didTapMore() {
        delegate?.contentTableViewCellDidTapMore(self)
    }
    
}
