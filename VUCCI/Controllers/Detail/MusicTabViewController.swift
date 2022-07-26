//
//  MusicTabViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 4/15/22.
//

import UIKit
import SDWebImage

protocol MusicTabDelegate: AnyObject {
    func MusicTabDelegateDidTap(_ tab: MusicTabViewController)
    func MusicTabDelegateDidTapPlayOrPause(_ tab: MusicTabViewController)
}

class MusicTabViewController: UIViewController {

    weak var delegate: MusicTabDelegate?
    
    let playAndPauseButton: UIButton = {
       let button = UIButton()
        let image = UIImage(systemName: "pause.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        button.setImage(image, for: .normal)
        button.tintColor = .systemBackground
        button.isHidden = true
        return button
    }()
    
    var songName: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.textColor = .systemBackground
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.isUserInteractionEnabled = true
        label.isHidden = true
        return label
    }()
    
    public var ArtistName: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.textColor = .systemBackground
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.isUserInteractionEnabled = true
        label.isHidden = true
        label.isHidden = true
        return label
    }()
    
    let songCoverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.isHidden = true
        return imageView
    }()
    
    let noSongSelectedLabel: UILabel = {
        let label = UILabel()
        label.text = "NO SONG SELECTED"
        label.textAlignment = .center
        label.textColor = .systemBackground
        label.font = .systemFont(ofSize: 16, weight: .thin)
        label.isUserInteractionEnabled = true
        label.isHidden = false
        return label
    }()

    let loadingSongLabel: UILabel = {
        let label = UILabel()
        label.text = "LOADING"
        label.textAlignment = .center
        label.textColor = .systemBackground
        label.font = .systemFont(ofSize: 16, weight: .thin)
        label.isUserInteractionEnabled = true
        label.isHidden = true
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .label
        view.addSubview(songName)
        view.addSubview(ArtistName)
        view.addSubview(playAndPauseButton)
        view.addSubview(songCoverImage)
        view.addSubview(noSongSelectedLabel)
        view.addSubview(loadingSongLabel)
        
        playAndPauseButton.addTarget(self, action: #selector(didTapPlayAndPause), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapTab))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(didTapTab))
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(didTapTab))
        songCoverImage.addGestureRecognizer(tap)
        songName.addGestureRecognizer(tap2)
        ArtistName.addGestureRecognizer(tap3)
        
        //notifications
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeSong), name: Notification.Name("didChangeSong"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(configureForLoadingSong), name: Notification.Name("loadingSong"), object: nil)
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let imageViewSize: CGFloat = view.height*0.7
        let playPauseButtonSize: CGFloat = view.height*0.65
        let labelWidth: CGFloat = (view.width - imageViewSize - playPauseButtonSize - 25)
        songCoverImage.frame = CGRect(x: 5, y: (view.height-imageViewSize)/2, width: imageViewSize, height: imageViewSize)
        songName.frame = CGRect(x: songCoverImage.right + 5, y: view.safeAreaInsets.top + 3, width: labelWidth, height: (view.height/2.1))
        ArtistName.frame = CGRect(x: songCoverImage.right + 5, y: songName.bottom - 5, width: labelWidth, height: view.height/2.2)
        playAndPauseButton.frame = CGRect(x: view.right - 5 - playPauseButtonSize - 15, y: (view.height-playPauseButtonSize)/2, width: playPauseButtonSize, height: playPauseButtonSize)
        
        noSongSelectedLabel.frame = CGRect(x: 10, y: (view.height - 25)/2, width: view.width - 20, height: 25)
        loadingSongLabel.frame = CGRect(x: 10, y: (view.height - 25)/2, width: view.width - 20, height: 25)
    }
    
    @objc func didChangeSong() {
        guard let song = SharedSongManager.shared.currentSong else {
            configureForNoSongPlaying()
            return
        }
        
        configureForSongPlaying()
        
        DispatchQueue.main.async { [weak self] in
            self?.songCoverImage.sd_setImage(with: URL(string:(song.imageUrl)))
            self?.ArtistName.text = song.ArtistName.uppercased()
            self?.songName.text = song.name.uppercased()
            let image = UIImage(systemName: "pause.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
            self?.playAndPauseButton.setImage(image, for: .normal)
        }
        
        
    }
    
    @objc func didTapPlayAndPause() {
        if SharedSongManager.shared.playing {
            let image = UIImage(systemName: "play.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
            DispatchQueue.main.async { [weak self] in
                self?.playAndPauseButton.setImage(image, for: .normal)
            }
        } else {
            let image = UIImage(systemName: "pause.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
            DispatchQueue.main.async { [weak self] in
                self?.playAndPauseButton.setImage(image, for: .normal)
            }
        }
        
        delegate?.MusicTabDelegateDidTapPlayOrPause(self)
    }
    
    @objc func didTapTab() {
        delegate?.MusicTabDelegateDidTap(self)
    }
    
    public func configureForSongPlaying() {
        DispatchQueue.main.async { [weak self] in
            self?.noSongSelectedLabel.isHidden = true
            self?.playAndPauseButton.isHidden = false
            self?.songName.isHidden = false
            self?.ArtistName.isHidden = false
            self?.songCoverImage.isHidden = false
            self?.loadingSongLabel.isHidden = true
        }
    }
    
    public func configureForNoSongPlaying() {
        DispatchQueue.main.async { [weak self] in
            self?.noSongSelectedLabel.isHidden = false
            self?.playAndPauseButton.isHidden = true
            self?.songName.isHidden = true
            self?.ArtistName.isHidden = true
            self?.songCoverImage.isHidden = true
            self?.loadingSongLabel.isHidden = true
            
        }
    }
    
    @objc func configureForLoadingSong() {
        DispatchQueue.main.async { [weak self] in
            self?.noSongSelectedLabel.isHidden = true
            self?.playAndPauseButton.isHidden = true
            self?.songName.isHidden = true
            self?.ArtistName.isHidden = true
            self?.songCoverImage.isHidden = true
            self?.loadingSongLabel.isHidden = false
        }
    }
}
