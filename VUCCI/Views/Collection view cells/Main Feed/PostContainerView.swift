//
//  PostContainerView.swift
//  VUCCI
//
//  Created by Jason bartley on 4/25/22.
//

import UIKit

protocol PostContainerViewDelegate: AnyObject {
    func PostContainerDelegateDidTapCell(_ view: PostContainerView, contentId: String, type: ContentType)
    func PostContainerDelegateDidTapPoster(_ view: PostContainerView, poster: String)
}

class PostContainerView: UIView {

    public weak var delegate: PostContainerViewDelegate?
    
    public var contentId: String = ""
    
    public var contentType: ContentType = .song
    
    public var poster: String = ""
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .thin)
        label.textColor = .label
        label.isUserInteractionEnabled = true
        return label
    }()
    
    public let musicImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    public let contentNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .thin)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    public let contentCreatorName: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .label
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(musicImage)
        addSubview(contentNameLabel)
        addSubview(contentCreatorName)
        backgroundColor = .secondarySystemBackground
        
        let tapPoster = UITapGestureRecognizer(target: self, action: #selector(didTapPoster))
        let tapContentName = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
        let tapContentCreator = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
        let tapContentImage = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
        
        titleLabel.addGestureRecognizer(tapPoster)
        contentNameLabel.addGestureRecognizer(tapContentName)
        contentCreatorName.addGestureRecognizer(tapContentCreator)
        musicImage.addGestureRecognizer(tapContentImage)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 0, y: 2, width: width, height: height * 0.25)
        musicImage.frame = CGRect(x: 8, y: titleLabel.bottom, width: height * 0.65, height: height * 0.65)
        contentNameLabel.frame = CGRect(x: musicImage.right + 8, y: titleLabel.bottom + 8, width: width - (height * 0.65) - 15, height: height * 0.3)
        contentCreatorName.frame = CGRect(x: musicImage.right + 8, y: contentNameLabel.bottom - 6, width: width - (height * 0.65) - 15, height: height * 0.3)
        
    }
    
    @objc func didTapCell() {
        delegate?.PostContainerDelegateDidTapCell(self, contentId: self.contentId, type: self.contentType)
    }
    
    @objc func didTapPoster() {
        delegate?.PostContainerDelegateDidTapPoster(self, poster: self.poster)
    }
    
    
}
