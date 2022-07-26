//
//  PlaylistOrSongSearchViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 4/22/22.
//

import UIKit

class PlaylistOrSongSearchViewController: UIViewController, UISearchResultsUpdating {
    
    private var contentType: ContentType
    
    private var playlist: String?
    
    private var content: Content?

    private let searchVC = UISearchController(searchResultsController: SearchResultsViewController())
    
    private var recentSearches: [Content] = []
    
    private var playlistItems: [Content] = []
    
    private let recentSearchesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 28, weight: .regular)
        label.text = "RECENT SEARCHES"
        return label
    }()
    
    private let noSearchHistoryLabel: UILabel = {
        let label = UILabel()
        label.text = "NO SEARCH HISTORY"
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 22, weight: .thin)
        return label
    }()
    
    private let magnifyingGlassImage: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(SearchHistoryTableViewCell.self, forCellReuseIdentifier: SearchHistoryTableViewCell.identifier)
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        return table
    }()
    
    
    private var collectionView: UICollectionView?
    
    init(type: ContentType, playlistName: String?, rank: Int, content: Content?) {
        self.contentType = type
        self.playlist = playlistName
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(recentSearchesLabel)
        view.addSubview(noSearchHistoryLabel)
        view.addSubview(magnifyingGlassImage)
        view.addSubview(tableView)
        view.addSubview(recentSearchesLabel)
        
        (searchVC.searchResultsController as? SearchResultsViewController)?.delegate = self
        searchVC.searchResultsUpdater = self
        
        if contentType == .song {
            searchVC.searchBar.placeholder = "SEARCH FOR A SONG"
            if playlist != nil {
                title = "Add To A Playlist"
            }
            tableView.delegate = self
            tableView.dataSource = self
            grabSearchHistory()
        } else if contentType == .playlist {
            searchVC.searchBar.placeholder = "SEARCH FOR A PLAYLIST"
            title = "Add To A Playlist"
            playlistItems = InformationManager.shared.allPlaylists
            configureCollectionView()
        }
        
        navigationItem.searchController = searchVC
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if contentType == .playlist {
            collectionView?.isHidden = false
            recentSearchesLabel.isHidden = true
            noSearchHistoryLabel.isHidden = true
            magnifyingGlassImage.isHidden = true
            tableView.isHidden = true
            
            collectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: (view.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 30))
        }
        if contentType == .song {
            collectionView?.isHidden = true
            recentSearchesLabel.frame = CGRect(x: 10, y: view.safeAreaInsets.top + 38, width: view.width - 20, height: 25)
            tableView.frame = CGRect(x: 0, y: recentSearchesLabel.bottom + 10, width: view.width, height: view.height - 30 - 60 - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
            
            noSearchHistoryLabel.frame = CGRect(x: 10, y: (view.height)/2 - 70, width: view.width - 20, height: 25)
            magnifyingGlassImage.frame = CGRect(x: (view.width - 60)/2, y: noSearchHistoryLabel.bottom + 10, width: 60, height: 60)
            
        }
    }
    
    private func grabSearchHistory() {
        if contentType == .song {
            self.recentSearches = InformationManager.shared.SongSearchHistory
            self.recentSearches = self.recentSearches.reversed()
            if self.recentSearches.isEmpty {
                showNoSearchHistory()
            } else {
                showSearchHistory()
            }
        }
    }
    
    private func showNoSearchHistory() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.isHidden = true
            self?.recentSearchesLabel.isHidden = true
            self?.noSearchHistoryLabel.isHidden = false
            self?.magnifyingGlassImage.isHidden = false
        }
    }
    
    private func showSearchHistory() {
        DispatchQueue.main.async {
            [weak self] in
            self?.tableView.isHidden = false
            self?.recentSearchesLabel.isHidden = false
            self?.noSearchHistoryLabel.isHidden = true
            self?.magnifyingGlassImage.isHidden = true
            self?.tableView.reloadData()
        }
       
    }
    
  
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let vc = searchController.searchResultsController as? SearchResultsViewController, let query = searchController.searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        guard let user = InformationManager.shared.getUserId() else {
            return
        }
        
        //Database call
        if contentType == .song {
            DatabaseManager.shared.findSong(with: query.lowercased(), completion: {
                content in
                DispatchQueue.main.async {
                    vc.update(with: content)
                }
            })
            
        } else if contentType == .playlist {
            DatabaseManager.shared.findAUsersPlaylist(with: query.lowercased(),user: user, completion: {
                content in
                DispatchQueue.main.async {
                    vc.update(with: content)
                }
            })
        }
    }
}

extension PlaylistOrSongSearchViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewController(_ vc: SearchResultsViewController, didSelectItemWith content: Content) {
        
        if contentType == .playlist {
            
            //MARK: add song to a selected playlist
            
            guard let song = self.content else {return}
            
            guard var playlistCount = content.playlistSongCount else {return}
            
            playlistCount += 1
            
            DatabaseManager.shared.addSongToPlaylist(songToAdd: song, orderNum: playlistCount,  playlist: content, completion: {
                [weak self] success in
                MessageManager.shared.createdEvent(eventType: .addedToPlaylist)
                NotificationCenter.default.post(name: NSNotification.Name("didChangeCollection"), object: nil)
                self?.navigationController?.popToRootViewController(animated: true)
            })
            
            
        } else if contentType == .song {
            
            InformationManager.shared.addItem(content: content)
            
            //MARK: add a selected song to a playlist
            
            guard let playlist = self.content else {return}
            guard var playlistSongCount = playlist.playlistSongCount else {return}
            playlistSongCount += 1
            
            DatabaseManager.shared.addSongToPlaylist(songToAdd: content, orderNum: playlistSongCount,  playlist: playlist, completion: {
                [weak self] success in
                MessageManager.shared.createdEvent(eventType: .addedToPlaylist)
                NotificationCenter.default.post(name: NSNotification.Name("didChangeCollection"), object: nil)
                self?.navigationController?.popToRootViewController(animated: true)
            })
        }
    }
}

extension PlaylistOrSongSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlistItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SongGroupCollectionViewCell.identifier, for: indexPath) as? SongGroupCollectionViewCell else {
            fatalError()
        }
        
        cell.configure(with: playlistItems[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let song = self.content else {return}
        let playlist = playlistItems[indexPath.row]
        
        guard var playlistCount = playlist.playlistSongCount else {return}
        
        playlistCount += 1
        
        DatabaseManager.shared.addSongToPlaylist(songToAdd: song, orderNum: playlistCount,  playlist: playlist, completion: {
            [weak self] success in
            MessageManager.shared.createdEvent(eventType: .addedToPlaylist)
            self?.navigationController?.popToRootViewController(animated: true)
        })
        
    }
    
    private func configureCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: {
            index, _ -> NSCollectionLayoutSection? in

            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))

            item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)

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

extension PlaylistOrSongSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchItem = recentSearches[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchHistoryTableViewCell.identifier, for: indexPath) as! SearchHistoryTableViewCell
        cell.configure(content: searchItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let searchItem = recentSearches[indexPath.row]
       
        if searchItem.isSong {
            guard let playlist = self.content else {return}
            guard var playlistSongCount = playlist.playlistSongCount else {return}
            playlistSongCount += 1
            
            DatabaseManager.shared.addSongToPlaylist(songToAdd: searchItem, orderNum: playlistSongCount,  playlist: playlist, completion: {
                [weak self] success in
                MessageManager.shared.createdEvent(eventType: .addedToPlaylist)
                self?.navigationController?.popToRootViewController(animated: true)
            })
        }
    }
    
}

