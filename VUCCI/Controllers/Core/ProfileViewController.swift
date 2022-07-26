//
//  ProfileViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 2/18/22.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = false
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    
    private let ProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    private let playlistLabel: UILabel = {
        let label = UILabel()
        label.text = "MY PLAYLISTS"
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 25, weight: .thin)
        return label
    }()
    
    private let artistSongsLabel: UILabel = {
        let label = UILabel()
        label.text = "RELEASED SONGS"
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 25, weight: .thin)
        label.isHidden = true
        return label
    }()
    
    private let artistAlbumsLabel: UILabel = {
        let label = UILabel()
        label.text = "RELEASED ALBUMS"
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 25, weight: .thin)
        label.isHidden = true
        return label
    }()
    
    private var topTenCollectionView: UICollectionView?
    
    private var topFiveCollectionView: UICollectionView?
    
    private var playlistCollectionView: UICollectionView?
    
    private var artistSongsCollectionView: UICollectionView?
    
    private var artistAlbumsCollectionView: UICollectionView?
    
    private let moreInfo = MoreInfoView()
    
    private let accountNameView = AccountNameView()
    
    private let myTopTenHeader = TopTenView()
    
    private let myTopFiveHeader = TopTenView()
    
    private var playlists = [Content]()
    
    private var topTenSongContent = [TopTen]()
    
    private var topFiveAlbumsContent = [TopFive]()
    
    private var artistSongs = [Content]()
    
    private var artistAlbums = [Content]()
    
    private let loadingViewChildVC = LoadingViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        
        setUpProfilePage()
        setUpName()
        getUserData()
        
        moreInfo.delegate = self
        moreInfo.alpha = 0
        moreInfo.isUserInteractionEnabled = false
        
        accountNameView.delegate = self
        myTopFiveHeader.configure(isTopTen: false)
        
        configureTonTenCollectionView()
        configureTopFiveCollectionView()
        configurePlaylistCollectionView()
        
        var isAnArtist: String = "false"
        
        if let isAnArtistAccount = InformationManager.shared.isAnArtistAccount() {
            isAnArtist = isAnArtistAccount
        }
        
        if isAnArtist == "true" {
            artistAlbumsLabel.isHidden = false
            artistSongsLabel.isHidden = false
            configureArtistAlbumsCollectionView()
            configureArtistsSongsCollectionView()
        }
        
        self.addBlurToViewController()
        addChild(loadingViewChildVC)
        view.addSubview(loadingViewChildVC.view)
        loadingViewChildVC.didMove(toParent: self)
        loadingViewChildVC.view.alpha = 1
        loadingViewChildVC.view.layer.cornerRadius = 20
        loadingViewChildVC.view.clipsToBounds = true
        loadingViewChildVC.startAnimation()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeSong), name: Notification.Name("didChangeSong"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeAccount), name: Notification.Name("didChangeAccount"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didPostContent), name: Notification.Name("didPostContent"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didFollow), name: Notification.Name("didFollow"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didUnfollow), name: Notification.Name("didUnfollow"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeProfilePhoto), name: Notification.Name("didChangeProfilePhoto"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeUsername), name: Notification.Name("didChangeUsername"), object: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRect(x: 0, y: 0 - view.safeAreaInsets.top, width: view.width, height: view.height)
        scrollView.contentSize = CGSize(width: view.width, height: 2000)
        scrollView.addSubview(moreInfo)
        scrollView.addSubview(ProfileImage)
        scrollView.addSubview(accountNameView)
        scrollView.addSubview(myTopTenHeader)
        scrollView.addSubview(myTopFiveHeader)
        scrollView.addSubview(playlistLabel)
        scrollView.addSubview(artistSongsLabel)
        scrollView.addSubview(artistAlbumsLabel)
        
        loadingViewChildVC.view.frame = CGRect(x: ((view.width - (view.width * 0.4))/2), y: (view.height - (view.width * 0.4))/2, width: (view.width * 0.4), height: (view.width * 0.4))
        
        var isAnArtist: String = "false"
        
        if let isAnArtistAccount =  InformationManager.shared.isAnArtistAccount() {
            isAnArtist = isAnArtistAccount
        }
        
        if isAnArtist == "true" {
            configureArtistAccountScrollView()
        } else {
            configureListenerAccountScrollView()
        }
    }
    
    private func configureListenerAccountScrollView() {
        let playlistSectionHeight: CGFloat = CGFloat(playlists.count) * 60
        
        scrollView.contentSize = CGSize(width: view.width, height: playlistSectionHeight + (view.width) + 1300)
        
        ProfileImage.frame = CGRect(x: 0, y: 0 , width: view.width, height: view.width)
        moreInfo.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: (view.width - view.safeAreaInsets.top))
        accountNameView.frame = CGRect(x: 0, y: ProfileImage.bottom, width: view.width, height: 100)
        myTopTenHeader.frame = CGRect(x: 0, y: accountNameView.bottom, width: view.width, height: 50)
        topTenCollectionView?.frame = CGRect(x: 0, y: myTopTenHeader.bottom + 15, width: view.width, height: 600)
        myTopFiveHeader.frame = CGRect(x: 0, y: myTopTenHeader.bottom + 600 + 30, width: view.width, height: 50)
        topFiveCollectionView?.frame = CGRect(x: 0, y: myTopFiveHeader.bottom + 5, width: view.width, height: 300)
        playlistLabel.frame = CGRect(x: 10, y: myTopFiveHeader.bottom + 330, width: view.width - 20, height: 50)
        playlistCollectionView?.frame = CGRect(x: 0, y: playlistLabel.bottom, width: view.width, height: playlistSectionHeight)
    }
    
    private func configureArtistAccountScrollView() {
        let artistSongSectionHeight: CGFloat = CGFloat(artistSongs.count) * 60
        let artistAlbumsSectionHeight: CGFloat = CGFloat(artistAlbums.count) * 60
        let playlistSectionHeight: CGFloat = CGFloat(playlists.count) * 60
        
        let combinedHeight = artistSongSectionHeight + artistAlbumsSectionHeight + playlistSectionHeight
        
        scrollView.contentSize = CGSize(width: view.width, height: view.width + combinedHeight + 1450)
        
        ProfileImage.frame = CGRect(x: 0, y: 0 , width: view.width, height: view.width)
        moreInfo.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: (view.width - view.safeAreaInsets.top))
        accountNameView.frame = CGRect(x: 0, y: ProfileImage.bottom, width: view.width, height: 100)
        artistSongsLabel.frame = CGRect(x: 0, y: accountNameView.bottom, width: view.width, height: 50)
        artistSongsCollectionView?.frame = CGRect(x: 0, y: artistSongsLabel.bottom + 15, width: view.width, height: artistSongSectionHeight)
        artistAlbumsLabel.frame = CGRect(x: 0, y: artistSongsLabel.bottom + (artistSongSectionHeight + 30), width: view.width, height: 50)
        artistAlbumsCollectionView?.frame = CGRect(x: 0, y: artistAlbumsLabel.bottom + 15, width: view.width, height: artistAlbumsSectionHeight)
        myTopTenHeader.frame = CGRect(x: 0, y: artistAlbumsLabel.bottom + (artistAlbumsSectionHeight + 30), width: view.width, height: 50)
        topTenCollectionView?.frame = CGRect(x: 0, y: myTopTenHeader.bottom + 15, width: view.width, height: 600)
        myTopFiveHeader.frame = CGRect(x: 0, y: myTopTenHeader.bottom + 600 + 30, width: view.width, height: 50)
        topFiveCollectionView?.frame = CGRect(x: 0, y: myTopFiveHeader.bottom + 5, width: view.width, height: 300)
        playlistLabel.frame = CGRect(x: 10, y: myTopFiveHeader.bottom + 330, width: view.width - 20, height: 50)
        playlistCollectionView?.frame = CGRect(x: 0, y: playlistLabel.bottom, width: view.width, height: playlistSectionHeight)
    }
    
    //MARK: set up account name
    
    private func setUpName() {
        guard let userId = InformationManager.shared.getUserId() else {return}
        guard let username = InformationManager.shared.getUsername() else {return}
        
        var isAnArtist: String = "false"
        
        if let isAnArtistAccount = InformationManager.shared.isAnArtistAccount() {
            isAnArtist = isAnArtistAccount
        }
        
        if isAnArtist == "true" {
            DatabaseManager.shared.findAUserWithId(userId: userId, completion: {
                [weak self] user in
                guard let user = user, let artistName = user.artistName else {
                    self?.accountNameView.accountNameLabel.text = "\(username.uppercased())"
                    return
                }
                self?.accountNameView.accountNameLabel.text = "\(artistName.uppercased())"
            })
        } else {
            self.accountNameView.accountNameLabel.text = "\(username.uppercased())"
        }
    }
    
    
    //MARK: grab artist songs, albums, playlist, top ten and top five
    
    private func setUpProfilePage() {
        self.topTenSongContent = []
        self.topFiveAlbumsContent = []
        self.artistSongs = []
        self.artistAlbums = []
        self.playlists = []
        
        guard let userId = InformationManager.shared.getUserId() else {return}
        
        var isAnArtist: String = "false"
        
        if let isAnArtistAccount =  InformationManager.shared.isAnArtistAccount() {
            isAnArtist = isAnArtistAccount
        }
        
        let group = DispatchGroup()
        
        group.enter()
        StorageManager.shared.profilePictureUrl(for: userId, completion: {
            [weak self] url in
            defer{
                group.leave()
            }
            self?.ProfileImage.sd_setImage(with: url)
        })
        
        group.enter()
        DatabaseManager.shared.grabTopTen(user: userId, completion: {
            [weak self] songs in
            defer {
                group.leave()
            }
            let orderedSongs = songs.sorted { songA, songB in
                songA.rank < songB.rank
            }
            self?.topTenSongContent = orderedSongs
            
        })
        
        group.enter()
        DatabaseManager.shared.grabTopFive(user: userId, completion: {
            [weak self] albums in
            defer {
                group.leave()
            }
            let orderedAlbums = albums.sorted { albumA, albumB in
                albumA.rank < albumB.rank
            }
            self?.topFiveAlbumsContent = orderedAlbums
        })
        
        group.enter()
        DatabaseManager.shared.grabFiveUserPlaylistThatCreated(userId: userId, completion: {
            [weak self] fetchedPlaylists in
            defer {
                group.leave()
            }
            if let playlists = fetchedPlaylists {
                self?.playlists = playlists
                if playlists.count >= 5 {
                    let seeMoreCell = Content(name: "SEE MORE PLAYLISTS", isArtist: false, isSong: false, isAlbum: false, isPlaylist: false, imageUrl: "", ArtistName: "", contentCreator: "", orderNumber: nil, isPublic: false, contentId: "SeeMore", songIds: [], yearPosted: "", albumId: "", duration: nil, playlistSongCount: nil, totalStreams: nil)
                    self?.playlists.append(seeMoreCell)
                }
                if playlists.count == 0 {
                    let noPlaylistCell = Content(name: "NO PUBLIC PLAYLISTS", isArtist: false, isSong: false, isAlbum: false, isPlaylist: false, imageUrl: "", ArtistName: "", contentCreator: "", orderNumber: nil, isPublic: false, contentId: "SeeMore", songIds: [], yearPosted: "", albumId: "", duration: nil, playlistSongCount: nil, totalStreams: nil)
                    self?.playlists.append(noPlaylistCell)
                }
            }
        })
        
        if isAnArtist == "true" {
            group.enter()
            DatabaseManager.shared.grabAnArtistTopFiveSongs(userId: userId, completion: {
                [weak self] content in
                defer {
                    group.leave()
                }
                if let songs = content {
                    self?.artistSongs = songs
                    if songs.count >= 5 {
                        let seeMoreCell = Content(name: "SEE MORE SONGS", isArtist: false, isSong: false, isAlbum: false, isPlaylist: false, imageUrl: "", ArtistName: "", contentCreator: "", orderNumber: nil, isPublic: false, contentId: "SeeMore", songIds: [], yearPosted: "", albumId: "", duration: nil, playlistSongCount: nil, totalStreams: nil)
                        self?.artistSongs.append(seeMoreCell)
                    }
                    
                    if songs.count == 0 {
                        let noContentCell = Content(name: "NO RELEASED SONGS", isArtist: false, isSong: false, isAlbum: false, isPlaylist: false, imageUrl: "", ArtistName: "", contentCreator: "", orderNumber: nil, isPublic: false, contentId: "SeeMore", songIds: [], yearPosted: "", albumId: "", duration: nil, playlistSongCount: nil, totalStreams: nil)
                        self?.artistSongs.append(noContentCell)
                    }
                }
            })
        }
        
        if isAnArtist == "true" {
            group.enter()
            DatabaseManager.shared.grabAnArtistsFiveAlbums(userId: userId, completion: {
                [weak self] content in
                defer {
                    group.leave()
                }
                
                if let albums = content {
                    self?.artistAlbums = albums
                    if albums.count >= 5 {
                        let seeMoreCell = Content(name: "SEE MORE ALBUMS", isArtist: false, isSong: false, isAlbum: false, isPlaylist: false, imageUrl: "", ArtistName: "", contentCreator: "", orderNumber: nil, isPublic: false, contentId: "SeeMore", songIds: [], yearPosted: "", albumId: "", duration: nil, playlistSongCount: nil, totalStreams: nil)
                        self?.artistAlbums.append(seeMoreCell)
                    }
                    if albums.count == 0 {
                        let noContentCell = Content(name: "NO RELEASED ALBUMS", isArtist: false, isSong: false, isAlbum: false, isPlaylist: false, imageUrl: "", ArtistName: "", contentCreator: "", orderNumber: nil, isPublic: false, contentId: "SeeMore", songIds: [], yearPosted: "", albumId: "", duration: nil, playlistSongCount: nil, totalStreams: nil)
                        self?.artistAlbums.append(noContentCell)
                    }
                }
            })
        }
        
        group.notify(queue: .main, execute: {
            self.topTenCollectionView?.reloadData()
            self.topFiveCollectionView?.reloadData()
            self.playlistCollectionView?.reloadData()
            
            if isAnArtist == "true" {
                self.configureArtistAccountScrollView()
                self.artistSongsCollectionView?.reloadData()
                self.artistAlbumsCollectionView?.reloadData()
            } else {
                self.configureListenerAccountScrollView()
            }
            
            self.stopLoadingView()
        })
    }
    
    //MARK: get following count and follower count
    
   private func getUserData() {
        var followingCount: Int = 0
        var followerCount: Int = 0
        var isAnArtist: Bool = false
        
        guard let userId = InformationManager.shared.getUserId() else {return}
       
        let group = DispatchGroup()
        
        group.enter()
        DatabaseManager.shared.getUsersFollowers(user: userId, completion: {
            users, success in
            defer {
                group.leave()
            }
            followerCount = (users.count)
        })
        
        group.enter()
        DatabaseManager.shared.getUsersFollowing(user: userId, completion: {
            users, success in
            defer {
                group.leave()
            }
            followingCount = (users.count)
        })
        
       var isAnArtistString: String = "false"
       
       if let isAnArtistAccount =  InformationManager.shared.isAnArtistAccount() {
           isAnArtistString = isAnArtistAccount
       }
       
       if isAnArtistString == "true" {
           isAnArtist = true
       } else {
           isAnArtist = false
       }
        
        group.notify(queue: .main) { [weak self] in
            let name = self?.accountNameView.accountNameLabel.text ?? ""
            let info = UserInfo(followerCount: followerCount, followingCount: followingCount, isAnArtist: isAnArtist, accountName: name)
            self?.moreInfo.configure(info: info)
        }
        
        
    }
    
    //change the color of a song to green if it is currently playing
    
    @objc func didChangeSong() {
        DispatchQueue.main.async { [weak self] in
            
            var isAnArtist: String = "false"
            if let isAnArtistAccount = InformationManager.shared.isAnArtistAccount() {
                isAnArtist = isAnArtistAccount
            }
            
            if isAnArtist == "true" {
                self?.artistSongsCollectionView?.reloadData()
                self?.artistAlbumsCollectionView?.reloadData()
            }
        
            self?.playlistCollectionView?.reloadData()
            self?.topTenCollectionView?.reloadData()
            self?.topFiveCollectionView?.reloadData()
        }
    }
    
    //change configuration accordingly if they changed there account type
    
    @objc func didChangeAccount() {
        var isAnArtist: String = "false"
        
        if let isAnArtistAccount = InformationManager.shared.isAnArtistAccount() {
            isAnArtist = isAnArtistAccount
        }
        
        if isAnArtist == "true" {
            artistAlbumsLabel.isHidden = false
            artistSongsLabel.isHidden = false
            configureArtistAlbumsCollectionView()
            configureArtistsSongsCollectionView()
        }
                
        
        setUpProfilePage()
        setUpName()
        getUserData()
        hideStats()
    }
    
    @objc func didPostContent() {
        setUpProfilePage()
        hideStats()
    }
    
    @objc func didFollow() {
        self.moreInfo.updateFollowingCount(didFollow: true)
    }
    
    @objc func didUnfollow() {
        self.moreInfo.updateFollowingCount(didFollow: false)
    }
    
    @objc func didChangeProfilePhoto() {
        DispatchQueue.main.async { [weak self] in
            self?.ProfileImage.image = InformationManager.shared.profileImage
        }
    }
    
    //change the users username if they changed it
    
    @objc func didChangeUsername() {
        var isAnArtist: String = "false"
        
        if let isAnArtistAccount =  InformationManager.shared.isAnArtistAccount() {
            isAnArtist = isAnArtistAccount
        }
        
        if isAnArtist == "false" {
            guard let username = InformationManager.shared.getUsername() else {return}
            
            DispatchQueue.main.async { [weak self] in
                self?.accountNameView.accountNameLabel.text = "\(username.uppercased())"
                self?.moreInfo.accountNameLabel.text = "\(username.uppercased())"
            }
        }
    }
    
}


extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return topTenSongContent.count
        } else if collectionView.tag == 1 {
            return topFiveAlbumsContent.count
        } else if collectionView.tag == 2 {
            return playlists.count
        } else if collectionView.tag == 3 {
            return artistSongs.count
        } else {
            return artistAlbums.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let model = topTenSongContent[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopPicksCollectionViewCell.identifier, for: indexPath) as? TopPicksCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(withTopTen: model, isEditMode: true)
            return cell
        } else if collectionView.tag == 1 {
            let model = topFiveAlbumsContent[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopPicksCollectionViewCell.identifier, for: indexPath) as? TopPicksCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(withTopFive: model, isEditMode: true)
            return cell
        } else if collectionView.tag == 2 {
            let model = playlists[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCollectionViewCell.identifier, for: indexPath) as? ContentCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: model)
            return cell
        } else if collectionView.tag == 3 {
            let model = artistSongs[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCollectionViewCell.identifier, for: indexPath) as? ContentCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: model)
            return cell
            
        } else {
            let model = artistAlbums[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCollectionViewCell.identifier, for: indexPath) as? ContentCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: model)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let userId = InformationManager.shared.getUserId() else {return}
        
        if collectionView.tag == 0 {
            let song = topTenSongContent[indexPath.row]
            guard song.contentId != "" else {return}
            DatabaseManager.shared.findSong(withId: song.contentId, completion: {
                song in
                guard let song = song else {return}
                SharedSongManager.shared.currentQueuePosition = 0
                SharedSongManager.shared.wasQueued = false
                SharedSongManager.shared.currentSong = song
            })
        } else if collectionView.tag == 1 {
            let album = topFiveAlbumsContent[indexPath.row]
            guard album.contentId != "" else {return}
            DatabaseManager.shared.findAlbum(withId: album.contentId, completion: {
                [weak self] albumContent in
                guard let albumContent = albumContent else {return}
                let vc = SongGroupDetailViewController(contentData: albumContent)
                self?.navigationController?.pushViewController(vc, animated: true)
            })
        } else if collectionView.tag == 2 {
            guard playlists.count >= indexPath.row else {return}
            let playlistContent = playlists[indexPath.row]
            let vc = SongGroupDetailViewController(contentData: playlistContent)
            navigationController?.pushViewController(vc, animated: true)
        } else if collectionView.tag == 3 {
            let song = artistSongs[indexPath.row]
            guard song.name != "SEE MORE SONGS" else {
                let vc = AllContentViewController(type: .song, user: userId)
                navigationController?.pushViewController(vc, animated: true)
                return
            }
            SharedSongManager.shared.currentQueuePosition = 0
            SharedSongManager.shared.wasQueued = false
            SharedSongManager.shared.currentSong = song
        } else {
            let album = artistAlbums[indexPath.row]
            guard album.name != "SEE MORE ALBUMS" else {
                let vc = AllContentViewController(type: .album, user: userId)
                navigationController?.pushViewController(vc, animated: true)
                return
            }
            let vc = SongGroupDetailViewController(contentData: album)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: configuring collection views

extension ProfileViewController {
    private func configureTonTenCollectionView() {
        let sectionHeight: CGFloat = 600
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: {
            index, _ -> NSCollectionLayoutSection? in
            
            
            let firstSong = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let secondSong = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let thirdSong = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let fourthSong = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let fifthSong = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let sixthSong = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let seventhSong = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let eigthSong = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let ninthSong = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let tenthSong = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
           
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(sectionHeight)), subitems: [firstSong, secondSong, thirdSong, fourthSong, fifthSong, sixthSong, seventhSong, eigthSong, ninthSong, tenthSong]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 10, trailing: 0)
            
            return section
        }))
        scrollView.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.tag = 0
        collectionView.isScrollEnabled = false
        collectionView.register(TopPicksCollectionViewCell.self, forCellWithReuseIdentifier: TopPicksCollectionViewCell.identifier)
        self.topTenCollectionView = collectionView
    }
    
    private func configureTopFiveCollectionView() {
        let sectionHeight: CGFloat = 300
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: {
            index, _ -> NSCollectionLayoutSection? in
            
            let firstAlbum = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let secondAlbum = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let thirdAlbum = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let fourthAlbum = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let fifthAlbum = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(sectionHeight)), subitems: [firstAlbum, secondAlbum, thirdAlbum, fourthAlbum, fifthAlbum]
            )
           
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 10, trailing: 0)
            
            return section
        }))
        scrollView.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.tag = 1
        collectionView.register(TopPicksCollectionViewCell.self, forCellWithReuseIdentifier: TopPicksCollectionViewCell.identifier)
        self.topFiveCollectionView = collectionView
    }
    
    
    private func configurePlaylistCollectionView() {
        let sectionHeight: CGFloat = 360
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: {
            index, _ -> NSCollectionLayoutSection? in
            
            
            let firstPlaylist = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let secondPlaylist = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let thirdPlaylist = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            
            let fourthPlaylist = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let fifthPlaylist = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let seeMore = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            var subItems: [NSCollectionLayoutItem] = []
            
            if self.playlists.count == 1 {
                subItems = [firstPlaylist]
            } else if self.playlists.count == 2 {
                subItems = [firstPlaylist, secondPlaylist]
            } else if self.playlists.count == 3 {
                subItems = [firstPlaylist, secondPlaylist, thirdPlaylist]
            } else if self.playlists.count == 4 {
                subItems = [firstPlaylist, secondPlaylist, thirdPlaylist, fourthPlaylist]
            } else {
                subItems = [firstPlaylist, secondPlaylist, thirdPlaylist, fourthPlaylist, fifthPlaylist, seeMore]
            }
            
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(sectionHeight)), subitems: subItems
            )
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 10, trailing: 0)
            
            return section
        }))
        scrollView.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.tag = 2
        collectionView.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: ContentCollectionViewCell.identifier)
        self.playlistCollectionView = collectionView
        
    }
    
    private func configureArtistsSongsCollectionView() {
        let sectionHeight: CGFloat = 300
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: {
            index, _ -> NSCollectionLayoutSection? in
            
            
            let firstSong = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            
            let secondSong = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let thirdSong = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let fourthSong = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let fifthSong = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let seeMore = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let subItems: [NSCollectionLayoutItem]
            
            if self.artistSongs.count == 1 {
                subItems = [firstSong]
            } else if self.artistSongs.count == 2 {
                subItems = [firstSong, secondSong]
            } else if self.artistSongs.count == 3 {
                subItems = [firstSong, secondSong, thirdSong]
            } else if self.artistSongs.count == 4 {
                subItems = [firstSong, secondSong, thirdSong, fourthSong]
            } else {
                subItems = [firstSong, secondSong, thirdSong, fourthSong, fifthSong, seeMore]
            }
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(sectionHeight)), subitems: subItems
            )
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 10, trailing: 0)
            
            return section
        }))
        scrollView.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.tag = 3
        collectionView.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: ContentCollectionViewCell.identifier)
        self.artistSongsCollectionView = collectionView

    }
    
    private func configureArtistAlbumsCollectionView() {
        let sectionHeight: CGFloat = 360
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: {
            index, _ -> NSCollectionLayoutSection? in
            
            
            let firstAlbum = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let secondAlbum = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let thirdAlbum = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let fourthAlbum = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let fifthAlbum = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let seeMore = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            var subItems: [NSCollectionLayoutItem] = []
            
            if self.artistAlbums.count == 1 {
                subItems = [firstAlbum]
            } else if self.artistAlbums.count == 2 {
                subItems = [firstAlbum, secondAlbum]
            } else if self.artistAlbums.count == 3 {
                subItems = [firstAlbum, secondAlbum, thirdAlbum]
            } else if self.artistAlbums.count == 4 {
                subItems = [firstAlbum, secondAlbum, thirdAlbum, fourthAlbum]
            } else {
                subItems = [firstAlbum, secondAlbum, thirdAlbum, fourthAlbum, fifthAlbum, seeMore]
            }
            
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(sectionHeight)), subitems: subItems
            )
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 10, trailing: 0)
            
            return section
        }))
        scrollView.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.tag = 4
        collectionView.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: ContentCollectionViewCell.identifier)
        self.artistAlbumsCollectionView = collectionView
    }
}


extension ProfileViewController: MoreInfoViewDelegate {
    
    func MoreInfoViewDidTapFollowing(_ view: MoreInfoView) {
        guard let userId = InformationManager.shared.getUserId() else {return}
        let vc = UserListViewController(followers: false, user: userId)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func MoreInfoViewDidTapFollowers(_ view: MoreInfoView) {
        guard let userId = InformationManager.shared.getUserId() else {return}
        let vc = UserListViewController(followers: true, user: userId)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension ProfileViewController: AccountNameViewDelegate {
    func AccountNameViewDelegateDidTapShowMore(_ view: AccountNameView, isShowing: Bool) {
        if isShowing == false {
            didTapViewStats()
            DispatchQueue.main.async {
                self.accountNameView.isShowing = true
                self.accountNameView.showMoreButton.setTitle("SHOW LESS", for: .normal)
            }
        }
        if isShowing == true {
            hideStats()
            DispatchQueue.main.async {
                self.accountNameView.isShowing = false
                self.accountNameView.showMoreButton.setTitle("SHOW MORE", for: .normal)
            }
        }
    }
}

extension ProfileViewController: ContentCollectionViewCellDelegate {
    func ContentCollectionViewCellDidTapMore(content: Content) {
        showOptionAlert(content: content)
    }
}

extension ProfileViewController: TopPicksCollectionViewCellDelegate {
    func topPicksCollectionViewCellDidTapMore(_ view: TopPicksCollectionViewCell, isTopTen: Bool, contentId: String) {
        //do nothing here
    }
    
    func topPicksCollectionViewCellDidTapContent(_ view: TopPicksCollectionViewCell, isTopTen: Bool, contentId: String) {
        if isTopTen {
            DatabaseManager.shared.findSong(withId: contentId, completion: {
                song in
                SharedSongManager.shared.currentQueuePosition = 0
                SharedSongManager.shared.wasQueued = false
                SharedSongManager.shared.currentSong = song
            })
        } else {
            DatabaseManager.shared.findAlbum(withId: contentId, completion: {
                [weak self] album in
                guard let selectedAlbum = album else {return}
                let vc = SongGroupDetailViewController(contentData: selectedAlbum)
                self?.navigationController?.pushViewController(vc, animated: true)
            })
        }
    }
    
    func topPicksCollectionViewCellDidTapEdit(_ view: TopPicksCollectionViewCell, isTopTen: Bool, rank: Int) {
        if isTopTen {
            let vc = TopSongOrAlbumSearchViewController(type: .song, rank: rank)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = TopSongOrAlbumSearchViewController(type: .album, rank: rank)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension ProfileViewController {
    
    @objc func didTapSettings() {
        let vc = SettingsMainMenuViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func didTapViewStats() {
        self.accountNameView.isShowing = true
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, animations: { [weak self] in
                self?.moreInfo.alpha = 1
                self?.ProfileImage.alpha = 0
                self?.accountNameView.accountNameLabel.isHidden = true
                self?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(self?.didTapSettings))
                var isAnArtist: String = "false"
                
                if let isAnArtistAccount =  InformationManager.shared.isAnArtistAccount() {
                    isAnArtist = isAnArtistAccount
                }
                
                if isAnArtist == "true" {
                    self?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "UPLOAD", style: .plain, target: self, action: #selector(self?.didTapUpload))
                }
            })
        }
        InformationManager.shared.profileImage = ProfileImage.image
        moreInfo.isUserInteractionEnabled = true
    }
    
    private func hideStats() {
        self.accountNameView.isShowing = false
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, animations: { [weak self] in
                self?.moreInfo.alpha = 0
                self?.ProfileImage.alpha = 1
                self?.accountNameView.accountNameLabel.isHidden = false
                self?.accountNameView.showMoreButton.setTitle("SHOW MORE", for: .normal)
                self?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: ""), style: .done, target: self, action: nil)
                self?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: ""), style: .done, target: self, action: nil)
            })
        }
        moreInfo.isUserInteractionEnabled = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: ""), style: .done, target: self, action: nil)
    }
    
    private func stopLoadingView() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingViewChildVC.view.alpha = 0
            self?.removeBlurFromViewController()
            self?.loadingViewChildVC.ImageView.transform = .identity
        }
    }
    
    @objc func didTapUpload() {
        let vc = UploadMenuViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ProfileViewController {
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
        DispatchQueue.main.async { [weak self] in
            self?.present(ac, animated: true)
        }
    }
    
    
    private func addToPlaylist(content: Content) {
        let vc = PlaylistOrSongSearchViewController(type: .playlist, playlistName: nil, rank: 0, content: content)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func shareASong(content: Content) {
        uploadingPost()
        guard let userId = InformationManager.shared.getUserId() else {return}
        
        let song = content
        
        let postedDate = NSDate().timeIntervalSince1970
        
        let newPostId = UUID().uuidString
        
        let newPost = Post(posterId: userId, postType: "like", contentId: song.contentId, contentType: "song", contentName: song.name, contentCreator: song.contentCreator, contentImageUrl: song.imageUrl, postedDate: postedDate, postId: newPostId)
        
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
        DispatchQueue.main.async { [weak self] in
            self?.present(ac, animated: true)
        }
        
    }
    
    private func uploadingPost() {
        let ac = UIAlertController(title: "Uploading Post", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
        DispatchQueue.main.async { [weak self] in
            self?.present(ac, animated: true)
        }
    }
    
}

extension ProfileViewController {
    //    @objc func didTapUpload() {
    //        let vc = UploadMenuViewController()
    //        navigationController?.pushViewController(vc, animated: true)
    //    }
    
    
}
