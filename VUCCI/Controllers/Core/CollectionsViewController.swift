//
//  CollectionsViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 4/11/22.
//

import UIKit

class CollectionsViewController: UIViewController {
    
    private var items = [Content]()
    
    private var collectionView: UICollectionView?
    
    let newPlaylistChildVC = NewPlaylistNameViewController()
    
    let selectPlaylistPictureChildVC = SelectPlaylistPictureViewController()
    
    let loadingViewChildVC = LoadingViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "COLLECTION"
        
        configureCollectionView()
        fetchGroups()
        setUpAddPlaylistMenu()
        configureNavBar()
        
        addChild(loadingViewChildVC)
        view.addSubview(loadingViewChildVC.view)
        loadingViewChildVC.didMove(toParent: self)
        loadingViewChildVC.view.alpha = 0
        loadingViewChildVC.view.layer.cornerRadius = 20
        loadingViewChildVC.view.clipsToBounds = true
        loadingViewChildVC.view.backgroundColor = .label
        loadingViewChildVC.ImageView.tintColor = .systemBackground
        loadingViewChildVC.ImageView.backgroundColor = .label
        
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeCollection), name: Notification.Name("didChangeCollection"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        title = "SHELF"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "COLLECTION"
    }
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(didTapAddPlaylist))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 60)
        loadingViewChildVC.view.frame = CGRect(x: ((view.width - (view.width * 0.4))/2), y: (view.height - (view.width * 0.4))/2, width: (view.width * 0.4), height: (view.width * 0.4))
    }
    
    //grab users collection
    
    private func fetchGroups() {
        showLoadingView()
        guard let userId = InformationManager.shared.getUserId() else {
            hideLoadingView()
            return
        }
        
        DatabaseManager.shared.grabUsersPlaylists(userId: userId, completion: {
            [weak self] playlists in
            self?.items = playlists
            
            guard var playlistItems = self?.items else {
                self?.hideLoadingView()
                return
            }
            
            for (index, playlist) in playlistItems.enumerated() {
                if playlist.name == "Liked Songs" {
                    let likePlaylist = playlistItems[index]
                    playlistItems.remove(at: index)
                    playlistItems.insert(likePlaylist, at: 0)
                    self?.items = playlistItems
                }
            }
            
            self?.hideLoadingView()
            self?.collectionView?.reloadData()
        })
    }
    
    //if someone changed collection from another view controller regrab collection.
    @objc func didChangeCollection() {
        self.fetchGroups()
    }
    
    func setUpAddPlaylistMenu() {
        addChild(newPlaylistChildVC)
        view.addSubview(newPlaylistChildVC.view)
        newPlaylistChildVC.didMove(toParent: self)
        newPlaylistChildVC.view.alpha = 0
        newPlaylistChildVC.view.isUserInteractionEnabled = false
        
        addChild(selectPlaylistPictureChildVC)
        view.addSubview(selectPlaylistPictureChildVC.view)
        selectPlaylistPictureChildVC.didMove(toParent: self)
        selectPlaylistPictureChildVC.view.alpha = 0
        selectPlaylistPictureChildVC.view.isUserInteractionEnabled = false
    }
    
    private func configureCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: {
            index, _ -> NSCollectionLayoutSection? in

            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))

            item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 5, trailing: 1)

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.6)), subitem: item, count: 2)

            let section = NSCollectionLayoutSection(group: group)
            return section
        })

        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SongGroupCollectionViewCell.self, forCellWithReuseIdentifier: SongGroupCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        self.collectionView = collectionView
        
    }

}

extension CollectionsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SongGroupCollectionViewCell.identifier, for: indexPath) as? SongGroupCollectionViewCell else {
            fatalError()
        }
        
        let item = items[indexPath.row]
        if item.name == "Liked Songs" {
            cell.configureForLiked()
        } else  {
            cell.configure(with: items[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        if item.name == "Liked Songs" {
            guard let userId = InformationManager.shared.getUserId() else {return}
            let vc = AllContentViewController(type: .likedPlaylist, user: userId)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = SongGroupDetailViewController(contentData: item)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension CollectionsViewController {
    
    @objc func didTapAddPlaylist() {
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.newPlaylistChildVC.view.alpha = 1
            self?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "NEXT", style: .done, target: self, action: #selector(self?.didTapNext))
            self?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "CANCEL", style: .done, target: self, action: #selector(self?.dismissNewPlaylist))
           
        })
        newPlaylistChildVC.view.isUserInteractionEnabled = true
        self.title = ""
        self.collectionView?.isUserInteractionEnabled = false
        
    }
    
    @objc func dismissNewPlaylist() {
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.newPlaylistChildVC.view.alpha = 0
            self?.configureNavBar()
        })
        newPlaylistChildVC.view.isUserInteractionEnabled = false
        self.title = "COLLECTION"
        self.collectionView?.isUserInteractionEnabled = true
        
    }
    
    @objc func dismissPlaylistPicture() {
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.selectPlaylistPictureChildVC.view.alpha = 0
            self?.configureNavBar()
        })
        selectPlaylistPictureChildVC.view.isUserInteractionEnabled = false
        self.title = "COLLECTION"
        self.collectionView?.isUserInteractionEnabled = true
        
    }
    
    @objc func didTapNext() {
        self.newPlaylistChildVC.newPlaylistName = self.newPlaylistChildVC.newPlaylistNameTextField.text ?? ""
        
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.newPlaylistChildVC.view.alpha = 0
            self?.selectPlaylistPictureChildVC.view.alpha = 1
            self?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "CREATE", style: .done, target: self, action: #selector(self?.didTapCreatePlaylist))
            self?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "CANCEL", style: .done, target: self, action: #selector(self?.dismissPlaylistPicture))
        })
        newPlaylistChildVC.view.isUserInteractionEnabled = false
        selectPlaylistPictureChildVC.view.isUserInteractionEnabled = true
        
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
    
    
    @objc func didTapCreatePlaylist() {
        self.newPlaylistChildVC.newPlaylistNameTextField.resignFirstResponder()
        
        guard let userId = InformationManager.shared.getUserId() else {
            return
        }
        
        let playlistId = UUID().uuidString
        
        let playlistName = self.newPlaylistChildVC.newPlaylistName.lowercased()
        
        let isPublic = self.newPlaylistChildVC.isPublic
        
        guard let playlistImage = self.selectPlaylistPictureChildVC.imageView.image else {
            showPlaylistCreationError(.noImage)
            return
        }
        
        let imageData = playlistImage.pngData()
        
        guard playlistName != "" else {
            showPlaylistCreationError(.noTitle)
            return
        }
        
        showLoadingView()
        StorageManager.shared.uploadSongGroupImage(songGroupId: playlistId, data: imageData , completion: {
            [weak self] url in
            
            guard let url = url else {
                self?.showPlaylistCreationError(.databaseError)
                self?.hideLoadingView()
                return
            }
            
            let urlString = url.absoluteString
            
            
            let newPlaylist = Content(name: playlistName, isArtist: false, isSong: false, isAlbum: false, isPlaylist: true, imageUrl: urlString, ArtistName: "", contentCreator: userId, orderNumber: 0, isPublic: isPublic, contentId: playlistId, songIds: [], yearPosted: "", albumId: nil, duration: nil, playlistSongCount: 0, totalStreams: nil)
            
            DatabaseManager.shared.createPlaylist(userId: userId, playlistId: playlistId, content: newPlaylist, completion: {
                [weak self] success in
                self?.hideLoadingView()
                if success {
                    self?.dismissPlaylistPicture()
                    self?.fetchGroups()
                    DispatchQueue.main.async {
                        self?.selectPlaylistPictureChildVC.imageView.image = nil
                        self?.selectPlaylistPictureChildVC.selectPhotoLabel.isHidden = false
                        self?.selectPlaylistPictureChildVC.reselectButton.isHidden = true
                        self?.selectPlaylistPictureChildVC.addPhotoButton.isHidden = false
                        self?.newPlaylistChildVC.newPlaylistNameTextField.text = nil
                    }
                } else {
                    self?.showPlaylistCreationError(.databaseError)
                }
            })
            
        })
    }
    
    func showPlaylistCreationError(_ err: playlistCreationError) {
        let ac = UIAlertController(title: err.errorDescription, message: err.errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(ac, animated: true)
        }
    }
    
    
    enum playlistCreationError: LocalizedError {
        case noTitle
        case databaseError
        case noImage
        
        var errorDescription: String? {
            switch self {
           
            case .noTitle:
                return "No playlist title entered"
            case .databaseError:
                return "An issue occured"
            case .noImage:
                return "No playlist image selected"
            }
        }
        
        var errorMessage: String? {
            switch self {
            
            case .noTitle:
                return "Please enter a title for playlist"
            case .databaseError:
                return "Please try again later"
            case .noImage:
                return "please select an image"
            }
        }
    }
    
    //when it enters foreground reconfigure the liked songs collection view cell incase light or dark mode changes
    
    @objc func willEnterForeground() {
        DispatchQueue.main.async { [weak self] in

            guard let playlistItems = self?.items else {return}

            for (index, playlist) in playlistItems.enumerated() {
                if playlist.name == "Liked Songs" {
                    guard let collectionView = self?.collectionView else {return}
                    
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SongGroupCollectionViewCell.identifier, for: IndexPath(row: index, section: 1)) as? SongGroupCollectionViewCell else {
                        fatalError()
                    }
                    cell.configureForLiked()
                    self?.collectionView?.reloadData()
                }
            }
        }
    }
}
