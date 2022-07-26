//
//  NewAlbumHeader.swift
//  VUCCI
//
//  Created by Jason bartley on 5/9/22.
//

import UIKit

protocol NewAlbumHeaderDelegate: AnyObject {
    func newAlbumHeaderDidChangeNumberOfSongs(value: Int)
}

class NewAlbumHeader: UIView {
    
    public weak var delegate: NewAlbumHeaderDelegate?
    
    public var numberOfSongs = 1

    private let albumTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = ""
        label.textColor = .label
        label.font = .systemFont(ofSize: 22, weight: .thin)
        return label
    }()
    
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let howManySongsLabel: UILabel = {
        let label = UILabel()
        label.text = "How Many Songs Would You Like\n On the Album?"
        label.numberOfLines = 2
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .thin)
        label.textAlignment = .center
        return label
    }()
    
    private let addSongButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "plus.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let decrementSongButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "minus.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let numberOfSongsLabel: UILabel = {
        let label = UILabel()
        label.text = "1 Song"
        label.numberOfLines = 2
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(albumTitleLabel)
        addSubview(imageView)
        addSubview(howManySongsLabel)
        addSubview(numberOfSongsLabel)
        addSubview(addSongButton)
        addSubview(decrementSongButton)
        
        addSongButton.addTarget(self, action: #selector(didAddSong), for: .touchUpInside)
        decrementSongButton.addTarget(self, action: #selector(didDecrementSongCount), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        albumTitleLabel.frame = CGRect(x: 10, y: 15, width: width - 20, height: 30)
        imageView.frame = CGRect(x: (width - (width * 0.5))/2, y: albumTitleLabel.bottom + 15, width: (width * 0.5), height: (width * 0.5))
        howManySongsLabel.frame = CGRect(x: 10, y: imageView.bottom + 20, width: width - 20, height: 60)
        decrementSongButton.frame = CGRect(x: (width - 80 - 20 - 90)/2, y: howManySongsLabel.bottom + 15, width: 40, height: 40)
        addSongButton.frame = CGRect(x: decrementSongButton.right + 10, y: howManySongsLabel.bottom + 15, width: 40, height: 40)
        
        numberOfSongsLabel.widthAnchor.constraint(equalToConstant: 90).isActive = true
        numberOfSongsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        numberOfSongsLabel.centerYAnchor.constraint(equalTo: addSongButton.centerYAnchor).isActive = true
        numberOfSongsLabel.leftAnchor.constraint(equalTo: addSongButton.rightAnchor, constant: 10).isActive = true
    }
    
    
    public func configure(albumImage: UIImage, albumName: String) {
        self.imageView.image = albumImage
        self.albumTitleLabel.text = albumName.uppercased()
    }
    
    
    @objc func didAddSong() {
        if numberOfSongs < 20 {
            numberOfSongs += 1
            numberOfSongsLabel.text = "\(numberOfSongs) Songs"
            delegate?.newAlbumHeaderDidChangeNumberOfSongs(value: numberOfSongs)
        }
    }
    
    @objc func didDecrementSongCount() {
        if numberOfSongs >= 2 {
            numberOfSongs -= 1
            
            if numberOfSongs == 1 {
                numberOfSongsLabel.text = "\(numberOfSongs) Song"
            } else {
                numberOfSongsLabel.text = "\(numberOfSongs) Songs"
            }
            
            delegate?.newAlbumHeaderDidChangeNumberOfSongs(value: numberOfSongs)
        }
    }
}
