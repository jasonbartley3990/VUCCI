//
//  TopPicksCollectionViewCell.swift
//  VUCCI
//
//  Created by Jason bartley on 5/24/22.
//

import UIKit

protocol TopPicksCollectionViewCellDelegate: AnyObject {
    func topPicksCollectionViewCellDidTapEdit(_ view: TopPicksCollectionViewCell, isTopTen: Bool, rank: Int)
    func topPicksCollectionViewCellDidTapContent(_ view: TopPicksCollectionViewCell, isTopTen: Bool, contentId: String)
    func topPicksCollectionViewCellDidTapMore(_ view: TopPicksCollectionViewCell, isTopTen: Bool, contentId: String)
}

class TopPicksCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TopPicksCollectionViewCell"
    
    weak var delegate: TopPicksCollectionViewCellDelegate?
    
    private var isTopTen: Bool?
    
    private var rank: Int?
    
    private var contentId: String?
    
    private var contentImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let contentTitle: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .thin)
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let contentSubtitle: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .thin)
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let nonSelectedLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .thin)
        label.isHidden = true
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private let rankNumber: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .thin)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
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
        addSubview(nonSelectedLabel)
        addSubview(rankNumber)
        addSubview(editButton)
        addSubview(moreButton)
        
        editButton.addTarget(self, action: #selector(didTapEdit), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)
        
        let rankNumberTap = UITapGestureRecognizer(target: self, action: #selector(didTapContent))
        rankNumber.addGestureRecognizer(rankNumberTap)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(didTapContent))
        contentImage.addGestureRecognizer(imageTap)
        
        let contentTitleTap = UITapGestureRecognizer(target: self, action: #selector(didTapContent))
        contentTitle.addGestureRecognizer(contentTitleTap)
        
        let contentSubtitleTap = UITapGestureRecognizer(target: self, action: #selector(didTapContent))
        contentSubtitle.addGestureRecognizer(contentSubtitleTap)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentImage.image = nil
        contentTitle.text = nil
        contentSubtitle.text = nil
        editButton.isHidden = false
        nonSelectedLabel.isHidden = true
        contentImage.isHidden = false
        contentTitle.isHidden = false
        contentSubtitle.isHidden = false
        contentTitle.textColor = .label
        contentSubtitle.textColor = .label
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let contentImageSize: CGFloat = contentView.height*0.75
        rankNumber.frame = CGRect(x: 7, y: (contentView.height - 30)/2, width: 30, height: 30)
        contentImage.frame = CGRect(x: rankNumber.right + 3, y: 10, width: contentImageSize, height: contentImageSize)
        contentTitle.frame = CGRect(x: contentImage.right + 10, y: contentView.top + 4, width: (contentView.width - 20 - contentImageSize - 50), height: (contentView.height/2.1))
        contentSubtitle.frame = CGRect(x: contentImage.right + 10, y: contentTitle.bottom - 5, width: (contentView.width - 20 - contentImageSize - 50), height: (contentView.height/2.2))
        editButton.frame = CGRect(x: contentView.width - 50, y: (contentView.height - 50)/2 , width: 35, height: 35)
        moreButton.frame = CGRect(x: contentView.width - 50, y: (contentView.height - 50)/2 , width: 35, height: 35)
        
        nonSelectedLabel.frame = CGRect(x: contentImage.left, y: (contentView.height - 40)/2, width: 200, height: 40)
        
    }
    
    func configure(withTopTen model: TopTen, isEditMode: Bool) {
        self.isTopTen = true
        self.contentId = model.contentId
        self.rank = model.rank
        rankNumber.text = String(model.rank)
        contentTitle.text = model.name.uppercased()
        contentSubtitle.text = model.artist.uppercased()
        
        if isEditMode == false {
            editButton.isHidden = true
            editButton.isUserInteractionEnabled = false
            moreButton.isHidden = false
            moreButton.isUserInteractionEnabled = true
        } else {
            editButton.isHidden = false
            editButton.isUserInteractionEnabled = true
            moreButton.isHidden = true
            moreButton.isUserInteractionEnabled = false
        }
    
        if let imageUrl = URL(string: model.imageUrl) {
            self.contentImage.sd_setImage(with: imageUrl)
        }
        
        if model.name == "---" || model.artist == "---" {
            configureForNonSelected()
        }
        
        guard let currentSong = SharedSongManager.shared.currentSong else {return}
        
        if model.contentId == currentSong.contentId {
            configureForSongPlaying()
        }
        
    }
    
    func configure(withTopFive model: TopFive, isEditMode: Bool) {
        self.isTopTen = false
        self.contentId = model.contentId
        self.rank = model.rank
        rankNumber.text = String(model.rank)
        contentTitle.text = model.name.uppercased()
        contentSubtitle.text = model.artist.uppercased()
        
        if isEditMode == false {
            editButton.isHidden = true
            editButton.isUserInteractionEnabled = false
            moreButton.isHidden = true
            moreButton.isUserInteractionEnabled = false
        }
        
        if model.name == "---" || model.artist == "---" {
            configureForNonSelected()
        }
            
        if let imageUrl = URL(string: model.imageUrl) {
            self.contentImage.sd_setImage(with: imageUrl)
        }
    }
    
    func configureForNonSelected() {
        contentImage.isUserInteractionEnabled = false
        contentTitle.isUserInteractionEnabled = false
        contentSubtitle.isUserInteractionEnabled = false
        rankNumber.isUserInteractionEnabled = false
        moreButton.isUserInteractionEnabled = false
        
        DispatchQueue.main.async { [weak self] in
            self?.contentImage.isHidden = true
            self?.contentTitle.isHidden = true
            self?.contentSubtitle.isHidden = true
            self?.nonSelectedLabel.isHidden = false
            self?.moreButton.isHidden = true
            
            guard let isTopTen = self?.isTopTen, isTopTen == true else  {
                self?.nonSelectedLabel.text = "NO ALBUM SELECTED"
                return
            }
            self?.nonSelectedLabel.text = "NO SONG SELECTED"
        }
    }
    
    @objc func didTapEdit() {
        guard let isTopTen = self.isTopTen else {return}
        guard let rank = self.rank else {return}
        delegate?.topPicksCollectionViewCellDidTapEdit(self, isTopTen: isTopTen, rank: rank)
    }
    
    @objc func didTapMore() {
        guard let isTopTen = self.isTopTen, isTopTen == true else {return}
        guard let id = self.contentId else {return}
        delegate?.topPicksCollectionViewCellDidTapMore(self, isTopTen: true, contentId: id)
    }
    
    @objc func didTapContent() {
        guard let isTopTen = self.isTopTen else {return}
        guard let content = self.contentId else {return}
        delegate?.topPicksCollectionViewCellDidTapContent(self, isTopTen: isTopTen, contentId: content)
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
    
    
}
