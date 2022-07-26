//
//  CurrentSongViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 4/13/22.
//

import UIKit
import AVFAudio
import AVFoundation

protocol CurrentSongViewControllerDelegate: AnyObject {
    func CurrentSongDelegateDidClose(_ view: CurrentSongViewController)
    func CurrentSongDelegateDidTapArtist(_ view: CurrentSongViewController, content: Content)
    func CurrentSongDelegateDidTapSong(content: Content)
    func CurrentSongDelegateDidTapAddToPlaylist(_ view: CurrentSongViewController, content: Content)
    func CurrentSongDelegateDidTapPauseOrPlay(_ view: CurrentSongViewController, play: Bool)
}

class CurrentSongViewController: UIViewController, AVAudioPlayerDelegate {
    
    public weak var delegate: CurrentSongViewControllerDelegate?
    
    public var content: Content?
    
    private var secondOptionsShowing: Bool = false
    
    var timer: Timer? = nil
    
    private let coloredBackground: CAGradientLayer = {
        let background = CAGradientLayer()
        background.colors = [
            UIColor.systemGray.cgColor,
            UIColor.secondarySystemBackground.cgColor,
            UIColor.secondarySystemBackground.cgColor,
            UIColor.systemBackground.cgColor,
            UIColor.systemBackground.cgColor,
            UIColor.systemBackground.cgColor,
            UIColor.systemBackground.cgColor,
            UIColor.secondarySystemBackground.cgColor,
            UIColor.secondarySystemBackground.cgColor,
            UIColor.systemGray.cgColor,
            UIColor.darkGray.cgColor
        ]
        return background
    }()
    
    private let songImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let previousButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public let pauseAndPlayButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "play.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 65))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("CLOSE", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        return button
    }()
    
    private let timeBar: UIProgressView = {
        let time = UIProgressView()
        time.progressTintColor = .label
        time.progress = 0.5
        return time
    }()
    
    private let timePassedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.text = "3:00"
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private let timeToComeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .right
        label.text = "3:00"
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private var songTitle: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.isUserInteractionEnabled = true
        label.textColor = .label
        return label
    }()
    
    private var artistTitle: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 19, weight: .light)
        label.isUserInteractionEnabled = true
        label.textColor = .label
        return label
    }()
    
    public let likeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let addToPlaylistButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "shareplay", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        return button
    }()
    
    
    private let seeMoreButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "line.3.horizontal", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(songImage)
        view.addSubview(previousButton)
        view.addSubview(nextButton)
        view.addSubview(pauseAndPlayButton)
        view.addSubview(closeButton)
        view.addSubview(timeBar)
        view.addSubview(timePassedLabel)
        view.addSubview(timeToComeLabel)
        view.addSubview(songTitle)
        view.addSubview(artistTitle)
        view.addSubview(likeButton)
        view.addSubview(addToPlaylistButton)
        view.addSubview(seeMoreButton)
        view.addSubview(shareButton)
        
        view.layer.addSublayer(coloredBackground)
        coloredBackground.opacity = 0.25
        
        SharedSongManager.shared.player?.delegate = self
        
        previousButton.addTarget(self, action: #selector(didTapPreviousSong), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextSong), for: .touchUpInside)
        pauseAndPlayButton.addTarget(self, action: #selector(didTapPlayOrPause), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        addToPlaylistButton.addTarget(self, action: #selector(didTapAddToPlaylist), for: .touchUpInside)
        seeMoreButton.addTarget(self, action: #selector(didTapSeeMore), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        
        let artistTap = UITapGestureRecognizer(target: self, action: #selector(didTapArtist))
        let songTap = UITapGestureRecognizer(target: self, action: #selector(didTapSong))
        
        songTitle.addGestureRecognizer(songTap)
        artistTitle.addGestureRecognizer(artistTap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeSong), name: Notification.Name("didChangeSong"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(badConnection), name: Notification.Name("badConnection"), object: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let imageSize: CGFloat = view.width * 0.75
        let playButtonSize: CGFloat = view.width * 0.28
        let miscButtonSize: CGFloat = view.width * 0.24
        coloredBackground.frame = view.bounds
        
        songImage.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        songImage.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        songImage.bottomAnchor.constraint(equalTo: timeBar.topAnchor, constant: -30).isActive = true
        songImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        timeBar.frame = CGRect(x: songImage.left, y: (view.height/2) + 40, width: imageSize, height: 10)
        timePassedLabel.frame = CGRect(x: songImage.left, y: timeBar.bottom + 3 , width: 40, height: 12)
        timeToComeLabel.frame = CGRect(x: songImage.right - 40, y: timeBar.bottom + 3, width: 40, height: 12)
        songTitle.frame = CGRect(x: songImage.left, y: timeToComeLabel.bottom + 15, width: imageSize, height: 40)
        artistTitle.frame = CGRect(x: songImage.left, y: songTitle.bottom, width: imageSize, height: 30)
        pauseAndPlayButton.frame = CGRect(x: (view.width - playButtonSize)/2, y: artistTitle.bottom, width: playButtonSize, height: playButtonSize)
        
        previousButton.heightAnchor.constraint(equalToConstant: miscButtonSize).isActive = true
        previousButton.widthAnchor.constraint(equalToConstant: miscButtonSize).isActive = true
        previousButton.leftAnchor.constraint(equalTo: songImage.leftAnchor).isActive = true
        previousButton.centerYAnchor.constraint(equalTo: pauseAndPlayButton.centerYAnchor).isActive = true
        
        nextButton.heightAnchor.constraint(equalToConstant: miscButtonSize).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: miscButtonSize).isActive = true
        nextButton.rightAnchor.constraint(equalTo: songImage.rightAnchor).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: pauseAndPlayButton.centerYAnchor).isActive = true
        
        closeButton.frame = CGRect(x: (view.width - 150)/2 , y: pauseAndPlayButton.bottom, width: 150, height: 50)
        
        likeButton.leftAnchor.constraint(equalTo: songImage.leftAnchor).isActive = true
        likeButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: miscButtonSize).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: miscButtonSize).isActive = true
        
        addToPlaylistButton.rightAnchor.constraint(equalTo: songImage.rightAnchor).isActive = true
        addToPlaylistButton.centerYAnchor.constraint(equalTo: pauseAndPlayButton.centerYAnchor).isActive = true
        addToPlaylistButton.heightAnchor.constraint(equalToConstant: miscButtonSize).isActive = true
        addToPlaylistButton.widthAnchor.constraint(equalToConstant: miscButtonSize).isActive = true
        
        shareButton.leftAnchor.constraint(equalTo: songImage.leftAnchor).isActive = true
        shareButton.centerYAnchor.constraint(equalTo: pauseAndPlayButton.centerYAnchor).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: miscButtonSize).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: miscButtonSize).isActive = true
        
        seeMoreButton.widthAnchor.constraint(equalToConstant: miscButtonSize).isActive = true
        seeMoreButton.heightAnchor.constraint(equalToConstant: miscButtonSize).isActive = true
        seeMoreButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor).isActive = true
        seeMoreButton.rightAnchor.constraint(equalTo: songImage.rightAnchor, constant: 12).isActive = true
        
    }
    
    @objc func didChangeSong() {
        guard let song = SharedSongManager.shared.currentSong else {
            return
        }
        
        self.content = song
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updatePlayer), userInfo: nil, repeats: true)
        
        DispatchQueue.main.async { [weak self] in
            self?.songImage.sd_setImage(with: URL(string: song.imageUrl))
            self?.artistTitle.text = song.ArtistName.uppercased()
            self?.songTitle.text = song.name.uppercased()
            self?.timePassedLabel.text = "0:00"
            self?.timeToComeLabel.text = song.duration?.timeInString()
            self?.timeBar.progress = 0
            
            let image = UIImage(systemName: "pause.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 65))
            self?.pauseAndPlayButton.setImage(image, for: .normal)
            
            if SharedSongManager.shared.isLiked {
                self?.likeButton.tintColor = .red
                let image = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35))
                self?.likeButton.setImage(image, for: .normal)
            } else {
                self?.likeButton.tintColor = .label
                let image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35))
                self?.likeButton.setImage(image, for: .normal)
            }
            
        }
        
        
    }
    
    @objc func didTapPreviousSong() {
        UIView.animate(withDuration: 0.1, animations: {
            self.previousButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { finish in
            UIView.animate(withDuration: 0.1, animations: {
                self.previousButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            })})
        
        SharedSongManager.shared.didTapPrevious()
        
        DispatchQueue.main.async { [weak self] in
            let image = UIImage(systemName: "pause.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 65))
            self?.pauseAndPlayButton.setImage(image, for: .normal)
        }
        
    }
    
    @objc func didTapNextSong() {
        UIView.animate(withDuration: 0.1, animations: {
            self.nextButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { finish in
            UIView.animate(withDuration: 0.1, animations: {
                self.nextButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            })})
        SharedSongManager.shared.didTapNext()
        
        DispatchQueue.main.async { [weak self] in
            let image = UIImage(systemName: "pause.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 65))
            self?.pauseAndPlayButton.setImage(image, for: .normal)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        SharedSongManager.shared.didTapNext()
    }
    
    @objc func didTapPlayOrPause() {
        UIView.animate(withDuration: 0.1, animations: {
            self.pauseAndPlayButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { finish in
            UIView.animate(withDuration: 0.1, animations: {
                self.pauseAndPlayButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            })})
        
        if SharedSongManager.shared.playing == true {
            SharedSongManager.shared.pauseMusic()
            let image = UIImage(systemName: "play.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 65))
            pauseAndPlayButton.setImage(image, for: .normal)
            delegate?.CurrentSongDelegateDidTapPauseOrPlay(self, play: true)
            
        } else {
            SharedSongManager.shared.playMusic()
            let image = UIImage(systemName: "pause.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 65))
            pauseAndPlayButton.setImage(image, for: .normal)
            delegate?.CurrentSongDelegateDidTapPauseOrPlay(self, play: false)
        }
    }
    
    @objc func didTapClose() {
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.previousButton.alpha = 1
            self?.nextButton.alpha = 1
            self?.likeButton.alpha = 1
            self?.shareButton.alpha = 0
            self?.addToPlaylistButton.alpha = 0
        })
        delegate?.CurrentSongDelegateDidClose(self)
    }
    
    @objc func didTapArtist() {
        guard let currentUserId = UserDefaults.standard.string(forKey: "userId") else {return}
        guard let song = self.content else {return}
        if song.contentCreator == currentUserId { return }
        delegate?.CurrentSongDelegateDidTapArtist(self, content: song)
    }
    
    @objc func updatePlayer() {
        DispatchQueue.main.async {
            let time = SharedSongManager.shared.player?.currentTime ?? 0.00
            self.timePassedLabel.text = time.timeInString()
            self.timeBar.progress = Float(time/(SharedSongManager.shared.player?.duration ?? 1))
        }
    }
    
    @objc func didTapSong() {
        guard let song = self.content else {return}
        if let albumId = song.albumId {
            DatabaseManager.shared.findAlbum(withId: albumId, completion: {
                [weak self] album in
                guard let album = album else {
                    return
                }
                self?.delegate?.CurrentSongDelegateDidTapSong(content: album)
            })
        }
    }
    
    @objc func didTapLike() {
        guard let userId = InformationManager.shared.getUserId() else {
            return
        }
        
        guard let content = self.content else {
            return
        }
        
        if SharedSongManager.shared.isLiked {
            likeButton.tintColor = .label
            let image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35))
            likeButton.setImage(image, for: .normal)
            
            DatabaseManager.shared.removeFromLikedSongs(user: userId, song: content, completion: {
                success in
                if success {
                    SharedSongManager.shared.isLiked
                    = !SharedSongManager.shared.isLiked
                }
            })
            
        } else {
            likeButton.tintColor = .red
            let image = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35))
            likeButton.setImage(image, for: .normal)
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.1, animations: {
                    self.likeButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }, completion: { finish in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.likeButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                })})
            }
            
            DatabaseManager.shared.addToLikedSongs(user: userId, song: content, completion: {
                success in
                if success {
                    SharedSongManager.shared.isLiked = !SharedSongManager.shared.isLiked
                }
            })
        }
    }
    
    @objc func didTapShare() {
        uploadingPost()
        guard let accountId = InformationManager.shared.getUserId() else {
            showUnableToPost()
            return
        }
        
        guard let song = self.content else {
            showUnableToPost()
            return
        }
        
        let postedDate = NSDate().timeIntervalSince1970
        
        let newPostId = UUID().uuidString
        
        let newPost = Post(posterId: accountId, postType: "like", contentId: song.contentId, contentType: "song", contentName: song.name, contentCreator: song.contentCreator, contentImageUrl: song.imageUrl, postedDate: postedDate, postId: newPostId)
        
        DatabaseManager.shared.shareAPost(post: newPost, postId: newPostId, completion: {
            [weak self] success in
            if !success {
                self?.showUnableToPost()
            }
        })
        
    }
    
    @objc func didTapAddToPlaylist() {
        guard let song = self.content else {return}
        delegate?.CurrentSongDelegateDidTapAddToPlaylist(self, content: song)
    }
    
    @objc func didTapSeeMore() {
        
        if secondOptionsShowing {
            self.secondOptionsShowing = false
            UIView.animate(withDuration: 0.4, animations: { [weak self] in
                self?.previousButton.alpha = 1
                self?.nextButton.alpha = 1
                self?.shareButton.alpha = 0
                self?.addToPlaylistButton.alpha = 0
            })
        } else {
            self.secondOptionsShowing = true
            UIView.animate(withDuration: 0.4, animations: { [weak self] in
                self?.previousButton.alpha = 0
                self?.nextButton.alpha = 0
                self?.shareButton.alpha = 1
                self?.addToPlaylistButton.alpha = 1
            })
        }
        
    }
    
    @objc func badConnection() {
        let ac = UIAlertController(title: "Slow connection at the moment", message:nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "ok", style: .cancel))
        DispatchQueue.main.async { [weak self] in
            self?.present(ac, animated: true)
        }
    }
    
    private func showUnableToPost() {
        let ac = UIAlertController(title: "Unable to post right now", message: "Please try again later", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(ac, animated: true)
    }
    
    private func uploadingPost() {
        let ac = UIAlertController(title: "Uploading Post", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(ac, animated: true)
    }
}
