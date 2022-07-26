//
//  SongTableViewCell.swift
//  VUCCI
//
//  Created by Jason bartley on 4/12/22.
//

import UIKit

protocol SongTableViewCellDelegate: AnyObject {
    func SongTableViewCellDidTapCell(_ cell: SongTableViewCell)
    func SongTableViewCellDidTapMore(_ cell: SongTableViewCell)
}

class SongTableViewCell: UITableViewCell {

    static let identifier = "SongTableViewCell"
    
    public weak var delegate: SongTableViewCellDelegate?
    
    public var content: Content?
    
    private let SongCoverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let songTitle: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .thin)
        return label
    }()
    
    private let songArtist: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 12, weight: .thin)
        return label
    }()
    
    let moreButton: UIButton = {
       let button = UIButton()
        let image = UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))
        button.setImage(image, for: .normal)
        button.tintColor = .darkGray
        return button
    }()
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        SongCoverImage.image = nil
        songTitle.text = nil
        songArtist.text = nil
        songTitle.textColor = .label
        songArtist.textColor = .label
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        contentView.addSubview(SongCoverImage)
        contentView.addSubview(songTitle)
        contentView.addSubview(songArtist)
        contentView.addSubview(moreButton)
        moreButton.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageViewSize: CGFloat = contentView.height/1.4
        let moreButtonSize: CGFloat = contentView.height*0.45
        let labelWidth: CGFloat = (contentView.width - imageViewSize - moreButtonSize - 45)
        SongCoverImage.frame = CGRect(x: 20, y: (contentView.height-imageViewSize)/2, width: imageViewSize, height: imageViewSize)
        songTitle.frame = CGRect(x: SongCoverImage.right + 7, y: contentView.safeAreaInsets.top + 7, width: labelWidth, height: (contentView.height/2.1))
        songArtist.frame = CGRect(x: SongCoverImage.right + 7, y: songTitle.bottom - 8, width: labelWidth, height: contentView.height/2.2)
        moreButton.frame = CGRect(x: contentView.right - 5 - moreButtonSize - 15, y: (contentView.height-moreButtonSize)/2, width: moreButtonSize + 10, height: moreButtonSize)
    }
    
    func configure(with song: Content) {
        self.content = song
        songTitle.text = song.name.uppercased()
        songArtist.text = song.ArtistName.uppercased()
        
        guard let url = URL(string: song.imageUrl) else {
            return
        }
        SongCoverImage.sd_setImage(with: url)
        
        guard let currentSong = SharedSongManager.shared.currentSong else {return}
        if song.contentId == currentSong.contentId {
            configureForSongPlaying()
        }
    }
    
    public func configureForSongPlaying() {
        DispatchQueue.main.async { [weak self] in
            self?.songTitle.textColor = .systemGreen
            self?.songArtist.textColor = .systemGreen
        }
    }
    
    public func configureForSongNotPlaying() {
        DispatchQueue.main.async { [weak self] in
            self?.songTitle.textColor = .label
            self?.songArtist.textColor = .label
        }
    }
    
    @objc func didTapMore() {
        delegate?.SongTableViewCellDidTapMore(self)
    }
    
}
