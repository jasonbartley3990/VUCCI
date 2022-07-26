//
//  AllContentViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 6/1/22.
//

import UIKit

class AllContentViewController: UIViewController {
    
    private var allContent: [Content] = []
    
    private let contentType: ContentType
    
    private let user: String
    
    private let loadingViewChildVC = LoadingViewController()
    
    private let noLikedSongsLabel: UILabel = {
        let label = UILabel()
        label.text = "NO LIKED SONGS"
        label.textColor = .label
        label.font = .systemFont(ofSize: 24, weight: .thin)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private var contentTableView: UITableView = {
        let table = UITableView()
        table.register(ContentTableViewCell.self, forCellReuseIdentifier: ContentTableViewCell.identifier)
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        return table
    }()
    
    init(type: ContentType, user: String) {
        self.contentType = type
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(contentTableView)
        view.addSubview(noLikedSongsLabel)
        contentTableView.delegate = self
        contentTableView.dataSource = self
        
        if self.contentType == .song {
            title = "ALL SONGS"
            grabAllSongsForUser()
        } else if self.contentType == .album {
            title = "ALL ALBUMS"
            grabAllAlbumsForUser()
        } else if self.contentType == .playlist {
            title = "ALL PLAYLISTS"
            grabAllPlaylistsForUser()
        }
        if self.contentType == .likedPlaylist {
            title = "LIKED SONGS"
            grabUsersLikedSongs()
        }
        
        
        addChild(loadingViewChildVC)
        view.addSubview(loadingViewChildVC.view)
        loadingViewChildVC.didMove(toParent: self)
        loadingViewChildVC.view.alpha = 0
        loadingViewChildVC.view.layer.cornerRadius = 20
        loadingViewChildVC.view.clipsToBounds = true
        loadingViewChildVC.view.backgroundColor = .label
        loadingViewChildVC.ImageView.tintColor = .systemBackground
        loadingViewChildVC.ImageView.backgroundColor = .label
        
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeSong), name: Notification.Name("didChangeSong"), object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentTableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 60)
        noLikedSongsLabel.frame = CGRect(x: 5, y: (view.height - 30)/2, width: view.width - 10, height: 30)
        
        loadingViewChildVC.view.frame = CGRect(x: ((view.width - (view.width * 0.4))/2), y: (view.height - (view.width * 0.4))/2, width: (view.width * 0.4), height: (view.width * 0.4))
    }
    
    private func grabAllSongsForUser() {
        showLoadingView()
        DatabaseManager.shared.grabAllOfAnArtistSongs(userId: self.user, completion: {
            [weak self] songs in
            guard let songs = songs else {return}
            self?.allContent = songs
            DispatchQueue.main.async {
                self?.hideLoadingView()
                self?.contentTableView.reloadData()
            }
        })
    }
    
    private func grabAllAlbumsForUser() {
        showLoadingView()
        DatabaseManager.shared.grabAllOfAnArtistAlbums(userId: self.user, completion: {
            [weak self] albums in
            guard let albums = albums else {return}
            self?.allContent = albums
            DispatchQueue.main.async {
                self?.hideLoadingView()
                self?.contentTableView.reloadData()
            }
        })
    }
    
    private func grabAllPlaylistsForUser() {
        showLoadingView()
        DatabaseManager.shared.grabUsersPlaylists(userId: self.user, completion: {
            [weak self] playlists in
            self?.allContent = playlists
            DispatchQueue.main.async {
                self?.hideLoadingView()
                self?.contentTableView.reloadData()
            }
        })
    }
    
    private func grabUsersLikedSongs() {
        showLoadingView()
        DatabaseManager.shared.grabUsersLikedSongs(userId: self.user , completion: {
            [weak self] songs in
            guard let songs = songs else {return}
            self?.allContent = songs
            if songs.count == 0 {
                DispatchQueue.main.async { [weak self] in
                    self?.hideLoadingView()
                    self?.contentTableView.isHidden = true
                    self?.noLikedSongsLabel.isHidden = false
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.hideLoadingView()
                    self?.contentTableView.reloadData()
                }
            }
        })
    }
    
    @objc func didChangeSong() {
        DispatchQueue.main.async { [weak self] in
            self?.contentTableView.reloadData()
        }
    }
    

    private func showLoadingView() {
        DispatchQueue.main.async {
            [weak self] in
            self?.loadingViewChildVC.view.alpha = 1
            self?.loadingViewChildVC.startAnimation()
        }
    }
    
    private func hideLoadingView() {
        DispatchQueue.main.async {
            [weak self] in
            self?.loadingViewChildVC.view.alpha = 0
            self?.loadingViewChildVC.ImageView.transform = .identity
        }
        
    }
    
    private func showError() {
        let ac = UIAlertController(title: "An issue occured!", message: "Please try again later", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        self.present(ac, animated: true)
    }
    
}

extension AllContentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allContent.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let content = allContent[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.identifier, for: indexPath) as! ContentTableViewCell
        cell.configure(with: content, index: indexPath.row)
        cell.delegate = self
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = allContent[indexPath.row]
        if self.contentType == .song {
            SharedSongManager.shared.wasQueued = false
            SharedSongManager.shared.currentSong = item
            SharedSongManager.shared.queueToPrepare = allContent
            SharedSongManager.shared.setUpQueue()
            SharedSongManager.shared.currentQueuePosition = indexPath.row
        } else if self.contentType == .album {
            let vc = SongGroupDetailViewController(contentData: item)
            navigationController?.pushViewController(vc, animated: true)
        } else if self.contentType == .playlist {
            let vc = SongGroupDetailViewController(contentData: item)
            navigationController?.pushViewController(vc, animated: true)
        }
        if self.contentType == .likedPlaylist {
            SharedSongManager.shared.wasQueued = false
            SharedSongManager.shared.currentSong = item
            SharedSongManager.shared.queueToPrepare = allContent
            SharedSongManager.shared.setUpQueue()
            SharedSongManager.shared.currentQueuePosition = indexPath.row
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
extension AllContentViewController {
    private func showOptionAlert(content: Content) {
        let ac = UIAlertController(title: content.name, message: "What Would You Like To Do?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "ADD TO PLAYLIST", style: .default, handler: { [weak self] _ in
            self?.addToPlaylist(content: content)
        }))
        ac.addAction(UIAlertAction(title: "SHARE", style: .default, handler: {
            [weak self] _ in
            self?.shareASong(content: content)
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    private func addToPlaylist(content: Content) {
        let vc = PlaylistOrSongSearchViewController(type: .playlist, playlistName: nil, rank: 0, content: content)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func shareASong(content: Content) {
        uploadingPost()
        guard let accountId = InformationManager.shared.getUserId() else {
            showError()
            return
        }
        
        let song = content
        
        let postedDate = NSDate().timeIntervalSince1970
        
        let newPostId = UUID().uuidString
        
        let newPost = Post(posterId: accountId, postType: "like", contentId: song.contentId, contentType: "song", contentName: song.name, contentCreator: song.contentCreator, contentImageUrl: song.imageUrl, postedDate: postedDate, postId: newPostId)
        
        DatabaseManager.shared.shareAPost(post: newPost, postId: newPostId, completion: {
            [weak self] success in
            if !success {
                self?.errorSharingPost()
            }
        })
    }
    
}

extension AllContentViewController: ContentTableViewCellDelegate {
    func contentTableViewCellDidTapEditButton(_ view: ContentTableViewCell) {
        //No edit in this view controller
    }
    
    func contentTableViewCellDidTapMore(_ view: ContentTableViewCell) {
        guard let content = view.content else {return}
        showOptionAlert(content: content)
    }
}

extension AllContentViewController {
    
    private func errorSharingPost() {
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
