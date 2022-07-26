//
//  SongGroupFooter.swift
//  VUCCI
//
//  Created by Jason bartley on 4/12/22.
//

import UIKit

protocol SongGroupFooterDelegate: AnyObject {
    func songGroupFooterDidTapLikeButton(_ footer: SongGroupFooter)
    func SongGroupFooterIsLiked(_ footer: SongGroupFooter)
    func SongGroupFooterDidTapShare(_ footer: SongGroupFooter)
    func SongGroupFooterErrorSharingPost()
    func deleteAPlaylist(_ footer: SongGroupFooter)
}

class SongGroupFooter: UIView {
    
    weak var delegate: SongGroupFooterDelegate?
    
    public var isContentLiked: Bool = false
    
    private var isCreatorOfContent: Bool = false
    
    private var content: Content?

    private let timeAndNumberOfSongsText: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .thin)
        label.text = ""
        return label
    }()
    
    private let releasedtext: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .thin)
        label.text = ""
        return label
    }()
    
    private let addToCollectionButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "shareplay", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "trash.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35))
        button.setImage(image, for: .normal)
        button.isHidden = true
        button.isUserInteractionEnabled = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(timeAndNumberOfSongsText)
        addSubview(releasedtext)
        addSubview(addToCollectionButton)
        addSubview(shareButton)
        addSubview(deleteButton)
        addToCollectionButton.addTarget(self, action: #selector(didTapAddToCollection), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.isCreatorOfContent {
            timeAndNumberOfSongsText.frame = CGRect(x: 15, y: 20, width: width - 14, height: 20)
            releasedtext.frame = CGRect(x: 15, y: timeAndNumberOfSongsText.bottom + 13 , width: width - 14, height: 20)
            deleteButton.frame = CGRect(x: (width - 50)/2 , y: timeAndNumberOfSongsText.bottom + 15, width: 50, height: 50)
            
            addToCollectionButton.isHidden = true
            shareButton.isHidden = true
            guard let content = self.content else {return}
            if content.isPlaylist {
                deleteButton.isHidden = false
                deleteButton.isUserInteractionEnabled = true
            }
        } else {
            addToCollectionButton.frame = CGRect(x: (width - 120 - 5)/2, y: 30, width: 50, height: 50)
            shareButton.frame = CGRect(x: addToCollectionButton.right + 15, y: 30, width: 70 , height: 50)
            timeAndNumberOfSongsText.frame = CGRect(x: 15, y: addToCollectionButton.bottom + 25, width: width - 14, height: 20)
            releasedtext.frame = CGRect(x: 15, y: timeAndNumberOfSongsText.bottom + 13 , width: width - 14, height: 20)
        }
    }
    
    
    func configure(model: Content) {
        self.content = model
        
        if model.isPlaylist {
            self.releasedtext.text = ""
            
            guard let songCount = model.playlistSongCount else {return}
            
            if songCount == 1 {
                self.timeAndNumberOfSongsText.text = "\(songCount) Song"
            } else {
                self.timeAndNumberOfSongsText.text = "\(songCount) Songs"
            }
            
        } else if model.isAlbum {
            
            self.releasedtext.text = "Released \(model.yearPosted)"
            
            guard let albumDuration = model.duration?.albumTimeInString() else {return}
            let songCount = model.songIds.count
            
            if songCount == 1 {
                self.timeAndNumberOfSongsText.text = "\(songCount) Song, \(albumDuration)"
            } else {
                self.timeAndNumberOfSongsText.text = "\(songCount) Songs, \(albumDuration)"
            }
        }
        
        guard let userId = InformationManager.shared.getUserId() else {return}
        self.isCreatorOfContent = (model.contentCreator == userId)
        
        DatabaseManager.shared.isContentLiked(userId: userId, contentId: model.contentId, completion: {
            [weak self] isLiked in
            if isLiked {
                self?.changeLike(isLiked: true)
                self?.contentIsLiked()
            }
        })
    }
    
    public func configurePlaylistFooterText(songCount: Int) {
        if songCount == 1 {
            self.timeAndNumberOfSongsText.text = "\(songCount) Song"
        } else {
            self.timeAndNumberOfSongsText.text = "\(songCount) Songs"
        }
        
    }
    
    public func changeLike(isLiked: Bool) {
        if isLiked {
            let image = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35))
            addToCollectionButton.setImage(image, for: .normal)
            addToCollectionButton.tintColor = .red
            self.isContentLiked = true
        } else {
            let image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35))
            addToCollectionButton.setImage(image, for: .normal)
            addToCollectionButton.tintColor = .label
            self.isContentLiked = false
        }
        
    }
    
    public func contentIsLiked() {
        delegate?.SongGroupFooterIsLiked(self)
    }
    
    @objc func didTapAddToCollection() {
        delegate?.songGroupFooterDidTapLikeButton(self)
    }
    
    @objc func didTapShare() {
        delegate?.SongGroupFooterDidTapShare(self)
        
        let uniquePostId = UUID().uuidString
        
        guard let userId = InformationManager.shared.getUserId() else {return}
        
        guard let content = self.content else {return}
        
        let postedDate = NSDate().timeIntervalSince1970
        
        let newPost = Post(posterId: userId, postType: "like", contentId: content.contentId, contentType: "album", contentName: content.name, contentCreator: content.contentCreator, contentImageUrl: content.imageUrl, postedDate:  postedDate, postId: uniquePostId)
        
        DatabaseManager.shared.shareAPost(post: newPost, postId: uniquePostId, completion: { [weak self] success in
            if success {
                MessageManager.shared.createdEvent(eventType: .shared)
            } else {
                self?.delegate?.SongGroupFooterErrorSharingPost()
            }
            
        })
    }
    
    @objc func didTapDelete() {
        delegate?.deleteAPlaylist(self)
    }
    
}
