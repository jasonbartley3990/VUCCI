//
//  SoundFileTableViewCell.swift
//  VUCCI
//
//  Created by Jason bartley on 5/9/22.
//

import UIKit

class SoundFileTableViewCell: UITableViewCell {

    static let identifier = "SoundFileTableViewCell"
    
    private let albumPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    private let songTitle: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.text = "---"
        label.textAlignment = .left
        label.isHidden = false
        return label
    }()
    
    private let songDuration: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.text = "---"
        label.textAlignment = .left
        label.isHidden = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(albumPhoto)
        contentView.addSubview(songTitle)
        contentView.addSubview(songDuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let albumPhotoSize: CGFloat = contentView.height/1.3
        let labelWidth: CGFloat = (contentView.width - albumPhotoSize - 40)
        albumPhoto.frame = CGRect(x: 15, y: (contentView.height-albumPhotoSize)/2, width: albumPhotoSize, height: albumPhotoSize)
        songTitle.frame = CGRect(x: albumPhoto.right + 5, y: contentView.top + 3, width: labelWidth, height: contentView.height/2.1)
        songDuration.frame = CGRect(x: albumPhoto.right + 5, y: songTitle.bottom - 5, width: labelWidth, height: contentView.height/2.2)
    }
    
    
    public func configure(with model: NewSongViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.albumPhoto.image = model.coverImage
            self?.songTitle.text = model.name
            self?.songDuration.text = model.songDuration.timeInString()
        }
        
    }

}
