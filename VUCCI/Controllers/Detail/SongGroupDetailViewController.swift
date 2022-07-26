//
//  SongGroupDetailViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 4/12/22.
//

import UIKit

class SongGroupDetailViewController: UIViewController {
    
    private var content: Content
    private var songs = [Content]()
    
    private var isPlaylist: Bool = false
    private var isAlbum: Bool = false
    
    private var header: SongGroupHeader?
    private var footer: SongGroupFooter?
    
    private var isLiked: Bool = false
    
    private var songTableView: UITableView = {
        let table = UITableView()
        table.register(SongTableViewCell.self, forCellReuseIdentifier: SongTableViewCell.identifier)
        table.register(NoSongsInPlaylistTableViewCell.self, forCellReuseIdentifier: NoSongsInPlaylistTableViewCell.identifier)
        return table
    }()
    
    init(contentData: Content) {
        self.content = contentData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view .backgroundColor = .systemBackground
        view.addSubview(songTableView)
        
        if content.isAlbum {
            self.isAlbum = true
            self.isPlaylist = false
        } else if content.isPlaylist {
            self.isPlaylist = true
            self.isAlbum = false
            
            if let userId =  InformationManager.shared.getUserId() {
                if userId == self.content.contentCreator {
                    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddSong))
                }
            }
        }
    
        songTableView.delegate = self
        songTableView.dataSource = self
        setUpHeaderAndFooter()
        grabSongs()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeSong), name: Notification.Name("didChangeSong"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeCollection), name: Notification.Name("didChangeCollection"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        songTableView.frame = view.bounds
        header?.frame = CGRect(x: 0, y: 0, width: view.width, height: view.width + 50)
        footer?.frame = CGRect(x: 0, y: songTableView.bottom + 2, width: view.width, height: 240)
    }
    
    @objc func willEnterForeground() {
        DispatchQueue.main.async { [weak self] in
            self?.songTableView.reloadData()
        }
    }
    
    private func setUpHeaderAndFooter() {
        header = SongGroupHeader()
        header?.configure(with: content)
        header?.delegate = self
        songTableView.tableHeaderView = header
        
        footer = SongGroupFooter()
        footer?.configure(model: self.content)
        footer?.delegate = self
        songTableView.tableFooterView = footer
    }
    
    private func grabSongs() {
        if self.isAlbum {
            let group = DispatchGroup()
            
            for _ in content.songIds {
                group.enter()
            }
        
            for song in content.songIds {
                DatabaseManager.shared.findSong(withId: song, completion: {
                    [weak self] song in
                    guard let content = song else {
                        group.leave()
                        return
                    }
                    self?.songs.append(content)
                    group.leave()
                })
            }
            
            group.notify(queue: .main, execute: {
                guard self.songs.count == self.content.songIds.count else {
                    self.showError()
                    return
                }
                let orderedSongs = self.songs.sorted { songA, songB in
                    songA.orderNumber ?? 0 < songB.orderNumber ?? 1
                }
                self.songs = orderedSongs
                    
                DispatchQueue.main.async { [weak self] in
                    self?.songTableView.reloadData()
                }
            })
        }
        
        if self.isPlaylist {
            DatabaseManager.shared.grabSongsFromPlaylist(playlist: self.content.contentId, completion: {
                [weak self] songs in
                let orderedSongs = songs.sorted { songA, songB in
                    songA.orderNumber ?? 0 < songB.orderNumber ?? 1
                }
                self?.songs = orderedSongs
                DispatchQueue.main.async { [weak self] in
                    self?.footer?.configurePlaylistFooterText(songCount: orderedSongs.count)
                    self?.songTableView.reloadData()
                }
            })
        }
    }
    
    //if song was changed reload table view to check if current song is playing and if it is change text to green
    @objc func didChangeSong() {
        DispatchQueue.main.async { [weak self] in
            self?.songTableView.reloadData()
        }
    }
    
    //used if a song is added or remove from a playlist to update table accordingly
    @objc func didChangeCollection() {
        guard let userId = InformationManager.shared.getUserId() else {return}
        
        if content.isPlaylist && content.contentCreator == userId  {
            DatabaseManager.shared.findAlbum(with: self.content.contentId, completion: {
                [weak self] playlists in
                if playlists.count != 0 {
                    self?.content = playlists[0]
                    self?.grabSongs()
                }
            })
        }
    }
    
    
    private func showError() {
        let ac = UIAlertController(title: "An issue occured!", message: "Please try again later", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        present(ac, animated: true)
    }
    
    private func showOptionAlert(content: Content) {
        guard let userId = InformationManager.shared.getUserId() else {return}
        
        let ac = UIAlertController(title: content.name, message: "What Would You Like To Do?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "ADD TO PLAYLIST", style: .default, handler: { [weak self] _ in
            self?.addToPlaylist(content: content)
        }))
        ac.addAction(UIAlertAction(title: "SHARE", style: .default, handler: {
            [weak self] _ in
            self?.shareASong(content: content)
        }))
        if self.isPlaylist && self.content.contentCreator == userId {
            ac.addAction(UIAlertAction(title: "REMOVE FROM PLAYLIST", style: .default, handler: { [weak self] _ in
                guard let playlist = self?.content else {return}
                
                DatabaseManager.shared.deleteASongFromPlaylist(playlist: playlist, songToRemoveId: content.contentId, userId: userId, completion: {
                    success in
                    if success {
                        MessageManager.shared.createdEvent(eventType: .removeFromPlaylist)
                        self?.songSuccessfullyRemoved(songId: content.contentId)
                    }
                })
            }))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    private func songSuccessfullyRemoved(songId: String) {
        for (index, song) in self.songs.enumerated() {
            if song.contentId == songId {
                self.songs.remove(at: index)
            }
        }
        let songCount: Int = self.songs.count
        
        DispatchQueue.main.async { [weak self] in
            self?.songTableView.reloadData()
            self?.footer?.configurePlaylistFooterText(songCount: songCount)
        }
    }
    
    @objc func didTapAddSong() {
        let vc = PlaylistOrSongSearchViewController(type: .song, playlistName: nil , rank: 0, content: self.content)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func addToPlaylist(content: Content) {
        let vc = PlaylistOrSongSearchViewController(type: .playlist, playlistName: nil, rank: 0, content: content)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func shareASong(content: Content) {
        uploadingPost()
        guard let accountId =  InformationManager.shared.getUserId() else {
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

extension SongGroupDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if songs.count == 0 {
            return 1
        } else {
            return songs.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if songs.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NoSongsInPlaylistTableViewCell.identifier, for: indexPath) as! NoSongsInPlaylistTableViewCell
            cell.delegate = self
            if let userId = InformationManager.shared.getUserId() {
                if userId == content.contentCreator {
                    cell.configure(isCreator: true)
                } else {
                    cell.configure(isCreator: false)
                }
            } else {
                cell.configure(isCreator: false)
            }
            return cell
        } else {
            let song = songs[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.identifier, for: indexPath) as! SongTableViewCell
            cell.configure(with: song)
            cell.delegate = self
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if songs.count == 0 {
            if let userId = InformationManager.shared.getUserId() {
                if userId == content.contentCreator {
                    return 150
                } else {
                    return 75
                }
            }
            return 150
        } else {
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let song = songs[indexPath.row]
        SharedSongManager.shared.wasQueued = false
        SharedSongManager.shared.currentSong = song
        SharedSongManager.shared.queueToPrepare = self.songs
        SharedSongManager.shared.setUpQueue()
        SharedSongManager.shared.currentQueuePosition = indexPath.row
    }
    
    
}

extension SongGroupDetailViewController: NoSongsInPlaylistTableViewCellDelegate {
    func NoSongsInPlaylistTableViewCellDidTapAdd() {
        let vc = PlaylistOrSongSearchViewController(type: .song, playlistName: nil , rank: 0, content: self.content)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SongGroupDetailViewController: SongTableViewCellDelegate {
    func SongTableViewCellDidTapMore(_ cell: SongTableViewCell) {
        guard let content = cell.content else {return}
        self.showOptionAlert(content: content)
    }
    
    func SongTableViewCellDidTapCell(_ cell: SongTableViewCell) {
        //song will play because didSelectCellAt in collectionView will execute.
    }
    
    
}

extension SongGroupDetailViewController: SongGroupFooterDelegate {
    func deleteAPlaylist(_ footer: SongGroupFooter) {
        let ac = UIAlertController(title: "Delete this playlist?", message: "You cannot undo this delete", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "DELETE", style: .default, handler: { [weak self] _ in
            self?.databaseDeletePlaylist()
        }))
        ac.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
        DispatchQueue.main.async { [weak self] in
            self?.present(ac, animated: true)
        }
    }
    
    func databaseDeletePlaylist() {
        DatabaseManager.shared.findAPost(contentId: self.content.contentId, completion: {
            [weak self] post in
            
            guard let playlistPost = post else {return}
            guard let userId = InformationManager.shared.getUserId() else {return}
            guard let playlist = self?.content else {return}

            DatabaseManager.shared.deleteAPlaylist(playlistId: playlist.contentId, poster: userId, post: playlistPost.postId, completion: {
                [weak self] success in
                if success {
                    NotificationCenter.default.post(name: NSNotification.Name("didChangeCollection"), object: nil)
                    self?.navigationController?.popToRootViewController(animated: true)
                    MessageManager.shared.createdEvent(eventType: .deletePlaylist)
                }
            })
            
        })
        
    }
    
    func SongGroupFooterErrorSharingPost() {
        self.errorSharingPost()
    }
    
    func SongGroupFooterDidTapShare(_ footer: SongGroupFooter) {
        self.uploadingPost()
    }
    
    func SongGroupFooterIsLiked(_ footer: SongGroupFooter) {
        self.isLiked = true
    }
    
    func songGroupFooterDidTapLikeButton(_ footer: SongGroupFooter) {
        
        guard let userId = InformationManager.shared.getUserId() else {
            return
        }
        
        if self.isLiked {
            DatabaseManager.shared.removeSongGroupFromCollection(user: userId, content: self.content, completion: {
                [weak self] success in
                if success {
                    MessageManager.shared.createdEvent(eventType: .removeFromCollection)
                    NotificationCenter.default.post(name: NSNotification.Name("didChangeCollection"), object: nil)
                    self?.isLiked = false
                    self?.footer?.changeLike(isLiked: false)
                }
            })
        } else {
            DatabaseManager.shared.addSongGroupToCollection(user: userId, content: self.content, completion: {
                [weak self] success in
                if success {
                    MessageManager.shared.createdEvent(eventType: .addedToCollection)
                    NotificationCenter.default.post(name: NSNotification.Name("didChangeCollection"), object: nil)
                    self?.isLiked = true
                    self?.footer?.changeLike(isLiked: true)
                }
            })
        }
    }
}

extension SongGroupDetailViewController: SongGroupHeaderDelegate {
    func SongGroupHeaderDelegateDidTapArtist(artistId: String) {
        guard let currentUserId = InformationManager.shared.getUserId() else {return}
        if artistId == currentUserId { return }
        let vc = ArtistOrUserViewController(userId: artistId)
        navigationController?.pushViewController(vc, animated: true)
    }
}
