//
//  SearchViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 2/18/22.
//

import UIKit

class MainSearchViewController: UIViewController, UISearchResultsUpdating {
    
    private let searchVC = UISearchController(searchResultsController: SearchResultsViewController())
    
    private var recentSearches: [Content] = []
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "FIND"
        view.addSubview(recentSearchesLabel)
        view.addSubview(noSearchHistoryLabel)
        view.addSubview(tableView)
        view.addSubview(magnifyingGlassImage)
        tableView.delegate = self
        tableView.dataSource = self
        
        (searchVC.searchResultsController as? SearchResultsViewController)?.delegate = self
        searchVC.searchResultsUpdater = self
        searchVC.searchBar.placeholder = "search for songs, artists, albums"
        navigationItem.searchController = searchVC
        
        grabRecentSearches()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        recentSearchesLabel.frame = CGRect(x: 10, y: view.safeAreaInsets.top + 38, width: view.width - 20, height: 25)
        tableView.frame = CGRect(x: 0, y: recentSearchesLabel.bottom + 10, width: view.width, height: view.height - 45 - 60 - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
        
        noSearchHistoryLabel.frame = CGRect(x: 10, y: (view.height)/2 - 70, width: view.width - 20, height: 25)
        magnifyingGlassImage.frame = CGRect(x: (view.width - 60)/2, y: noSearchHistoryLabel.bottom + 10, width: 60, height: 60)
    }
  
    
    //update search results after a user has typed something
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let vc = searchController.searchResultsController as? SearchResultsViewController, let query = searchController.searchBar.text?.lowercased(), !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        DatabaseManager.shared.findContent(with: query, completion: {
            content in
            DispatchQueue.main.async {
                vc.update(with: content)
            }
        })
        
    }
    
    //grab search history
    
    private func grabRecentSearches() {
        self.recentSearches = InformationManager.shared.MainSearchHistory
        self.recentSearches = self.recentSearches.reversed()
        if self.recentSearches.isEmpty {
            showNoSearchHistory()
        } else {
            showSearchHistory()
        }
    }
    
    //show this message if no search history
    
    private func showNoSearchHistory() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.isHidden = true
            self?.recentSearchesLabel.isHidden = true
            self?.noSearchHistoryLabel.isHidden = false
            self?.magnifyingGlassImage.isHidden = false
        }
    }
    
    //show recent searches
    
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
    
    //if from music tab you click on an artist if will navigate to that artist from this view controller
    
    public func didTapArtistFromMusicTab(artistId: String) {
        let vc = ArtistOrUserViewController(userId: artistId)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //if you tap a song from the music tab it will navigate to its album from this view controller
    
    public func didTapSongFromMusicTab(content: Content) {
        let vc = SongGroupDetailViewController(contentData: content)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //if from the music tab you want to add a song to a playlist, you will navigate to the playlist search from this view controller
    
    public func didTapAddToPlaylist(content: Content) {
        let vc = PlaylistOrSongSearchViewController(type: .playlist, playlistName: nil, rank: 0, content: content)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MainSearchViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewController(_ vc: SearchResultsViewController, didSelectItemWith content: Content) {
        InformationManager.shared.addItem(content: content)
       
        grabRecentSearches()
        
        searchVC.resignFirstResponder()
        if content.isSong {
            SharedSongManager.shared.wasQueued = false
            SharedSongManager.shared.currentSong = content
        } else if content.isAlbum {
            let vc = SongGroupDetailViewController(contentData: content)
            navigationController?.pushViewController(vc, animated: true)
        } else if content.isPlaylist {
            let vc = SongGroupDetailViewController(contentData: content)
            navigationController?.pushViewController(vc, animated: true)
        } else if content.isArtist {
            guard let userId = InformationManager.shared.getUserId() else {return}
            if content.contentCreator == userId { return }
            
            let vc = ArtistOrUserViewController(userId: content.contentId)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension MainSearchViewController: UITableViewDelegate, UITableViewDataSource {
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
        if searchItem.isAlbum {
            let vc = SongGroupDetailViewController(contentData: searchItem)
            navigationController?.pushViewController(vc, animated: true)
        } else if searchItem.isSong {
            SharedSongManager.shared.wasQueued = false
            SharedSongManager.shared.currentSong = searchItem
        } else if searchItem.isArtist {
            let vc = ArtistOrUserViewController(userId: searchItem.contentId)
            navigationController?.pushViewController(vc, animated: true)
        } else if searchItem.isPlaylist {
            let vc = SongGroupDetailViewController(contentData: searchItem)
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
