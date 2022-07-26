//
//  TabBarViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 5/4/22.
//

import UIKit
import AVFoundation
import MediaPlayer

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    private var needToSignIn = false
    
    public let musicTabChildVC = MusicTabViewController()
    
    public let currentSong = CurrentSongViewController()
    
    let messageChildVC = MessageViewController()
    
    let home = HomeViewController()
    
    let search = MainSearchViewController()
    
    let creation = CreationMenuViewController()
    
    let collections = CollectionsViewController()
    
    let profile = ProfileViewController()
    
    public var playing: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MessageManager.shared.delegate = self
        
        guard let _ = UserDefaults.standard.string(forKey: "email"), let _ = UserDefaults.standard.string(forKey: "username"), let _ = UserDefaults.standard.string(forKey: "userId") else {
            AuthenticationManager.shared.signOut(completion: {
                [weak self] success in
                if success {
                    self?.needToSignIn = true
                }})
            return
        }
        
        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: search)
        let nav3 = UINavigationController(rootViewController: creation)
        let nav4 = UINavigationController(rootViewController: collections)
        let nav5 = UINavigationController(rootViewController: profile)
        
        nav1.navigationBar.tintColor = .label
        nav2.navigationBar.tintColor = .label
        nav3.navigationBar.tintColor = .label
        nav4.navigationBar.tintColor = .label
        nav5.navigationBar.tintColor = .label
        
        
        nav1.tabBarItem = UITabBarItem(title: "HOME", image: UIImage(systemName: "globe"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "FIND", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "CREATE", image: UIImage(systemName: "line.3.crossed.swirl.circle.fill"), tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "SHELF", image: UIImage(systemName: "lineweight" ), tag: 4)
        nav5.tabBarItem = UITabBarItem(title: "ME", image: UIImage(systemName: "person.circle"), tag: 5)
        
        self.setViewControllers([nav1, nav2, nav3, nav4, nav5], animated: false)
        
        addChild(musicTabChildVC)
        view.addSubview(musicTabChildVC.view)
        musicTabChildVC.didMove(toParent: self)
        musicTabChildVC.view.isUserInteractionEnabled = true
        musicTabChildVC.view.alpha = 1
        musicTabChildVC.delegate = self
        
        addChild(currentSong)
        view.addSubview(currentSong.view)
        currentSong.didMove(toParent: self)
        currentSong.view.alpha = 0
        currentSong.delegate = self
        
        addChild(messageChildVC)
        view.addSubview(messageChildVC.view)
        messageChildVC.didMove(toParent: self)
        messageChildVC.view.alpha = 0
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //send them to sign up view controller
        
        if needToSignIn == true {
            needToSignIn = false
            let vc = SignInViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let childHeight: CGFloat = 60
        musicTabChildVC.view.frame = CGRect(x: 10, y: self.tabBar.top - childHeight - 7, width: self.view.width - 20, height: childHeight)
        musicTabChildVC.view.layer.cornerRadius = 8
        musicTabChildVC.view.layer.masksToBounds = true
        
        messageChildVC.view.frame = CGRect(x: 10, y: self.musicTabChildVC.view.top - childHeight - 5, width: self.view.width - 20, height: childHeight)
        messageChildVC.view.layer.cornerRadius = 8
        messageChildVC.view.layer.masksToBounds = true
        
        
        currentSong.view.frame = view.bounds
        
    }
    
    @objc func hideMessage() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, animations: { [weak self] in
                self?.messageChildVC.view.alpha = 0
            })
        }
    }
}

extension TabBarViewController: MusicTabDelegate {
    func MusicTabDelegateDidTapPlayOrPause(_ tab: MusicTabViewController) {
        if SharedSongManager.shared.playing {
            SharedSongManager.shared.playing = false
            SharedSongManager.shared.pauseMusic()
            DispatchQueue.main.async { [weak self] in
                let image = UIImage(systemName: "play.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 65))
                self?.currentSong.pauseAndPlayButton.setImage(image, for: .normal)
            }
        } else {
            SharedSongManager.shared.playing = true
            SharedSongManager.shared.playMusic()
            DispatchQueue.main.async { [weak self] in
                let image = UIImage(systemName: "pause.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 65))
                self?.currentSong.pauseAndPlayButton.setImage(image, for: .normal)
            }
        }
    }
    
    func MusicTabDelegateDidTap(_ tab: MusicTabViewController) {
        guard SharedSongManager.shared.currentSong != nil else {return}
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, animations: { [weak self] in
                self?.musicTabChildVC.view.alpha = 0
                self?.messageChildVC.view.alpha = 0
                self?.currentSong.view.alpha = 1
            })
        }
        musicTabChildVC.view.isUserInteractionEnabled = false
        currentSong.view.isUserInteractionEnabled = true
        
    }
    
    
}

extension TabBarViewController: CurrentSongViewControllerDelegate {
    func CurrentSongDelegateDidTapPauseOrPlay(_ view: CurrentSongViewController, play: Bool) {
        DispatchQueue.main.async {
            [weak self] in
            if play == true {
                let playImage = UIImage(systemName: "play.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 65))
                self?.musicTabChildVC.playAndPauseButton.setImage(playImage, for: .normal)
            } else {
                let pauseImage = UIImage(systemName: "pause.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 65))
                self?.musicTabChildVC.playAndPauseButton.setImage(pauseImage, for: .normal)
            }
        }
    }
    
    func CurrentSongDelegateDidTapAddToPlaylist(_ view: CurrentSongViewController, content: Content) {
        self.selectedIndex = 1
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, animations: { [weak self] in
                self?.musicTabChildVC.view.alpha = 1
                self?.currentSong.view.alpha = 0
            })
        }
        musicTabChildVC.view.isUserInteractionEnabled = true
        currentSong.view.isUserInteractionEnabled = false
        self.search.didTapAddToPlaylist(content: content)
    }
    
    func CurrentSongDelegateDidTapArtist(_ view: CurrentSongViewController, content: Content) {
        self.selectedIndex = 1
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, animations: { [weak self] in
                self?.musicTabChildVC.view.alpha = 1
                self?.currentSong.view.alpha = 0
            })
        }
        musicTabChildVC.view.isUserInteractionEnabled = true
        currentSong.view.isUserInteractionEnabled = false
        self.search.didTapArtistFromMusicTab(artistId: content.contentCreator)
        
    }
    
    func CurrentSongDelegateDidTapSong(content: Content) {
        self.selectedIndex = 1
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, animations: { [weak self] in
                self?.musicTabChildVC.view.alpha = 1
                self?.currentSong.view.alpha = 0
            })
        }
        musicTabChildVC.view.isUserInteractionEnabled = true
        currentSong.view.isUserInteractionEnabled = false
        self.search.didTapSongFromMusicTab(content: content)
        
    }
    
    func CurrentSongDelegateDidClose(_ view: CurrentSongViewController) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, animations: { [weak self] in
                self?.musicTabChildVC.view.alpha = 1
                self?.currentSong.view.alpha = 0
            })
        }
        musicTabChildVC.view.isUserInteractionEnabled = true
        currentSong.view.isUserInteractionEnabled = false
    }
}

extension TabBarViewController: MessageManagerDelegate {
    func messageManagerDidCreateEvent(messageType: messageTypes) {
        self.messageChildVC.didReceiveMessage(event: messageType)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, animations: { [weak self] in
                self?.messageChildVC.view.alpha = 1
            })
        }
        let _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(hideMessage), userInfo: nil, repeats: false)
        
    }
}
