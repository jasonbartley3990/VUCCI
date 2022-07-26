//
//  TopSongOrAlbumSearchViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 5/24/22.
//

import UIKit

class TopSongOrAlbumSearchViewController: UIViewController, UISearchResultsUpdating {

    private var contentType: ContentType
    
    private var rank: Int

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
    
    init(type: ContentType, rank: Int) {
        self.contentType = type
        self.rank = rank
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(recentSearchesLabel)
        view.addSubview(tableView)
        view.addSubview(magnifyingGlassImage)
        view.addSubview(noSearchHistoryLabel)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        (searchVC.searchResultsController as? SearchResultsViewController)?.delegate = self
        searchVC.searchResultsUpdater = self
        
        if contentType == .song {
            searchVC.searchBar.placeholder = "SEARCH FOR A SONG"
            title = "CHANGE # \(String(self.rank)) SONG"
        } else if contentType == .album {
            searchVC.searchBar.placeholder = "SEARCH FOR AN ALBUM"
            title = "CHANGE # \(String(self.rank)) ALBUM"
        }
        
        navigationItem.searchController = searchVC
        
        grabSearchHistory()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        recentSearchesLabel.frame = CGRect(x: 10, y: view.safeAreaInsets.top + 38, width: view.width - 20, height: 25)
        tableView.frame = CGRect(x: 0, y: recentSearchesLabel.bottom + 10, width: view.width, height: view.height - 30 - 60 - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
        
        noSearchHistoryLabel.frame = CGRect(x: 10, y: (view.height)/2 - 70, width: view.width - 20, height: 25)
        magnifyingGlassImage.frame = CGRect(x: (view.width - 60)/2, y: noSearchHistoryLabel.bottom + 10, width: 60, height: 60)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let vc = searchController.searchResultsController as? SearchResultsViewController, let query = searchController.searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        //Database call
        if contentType == .song {
            DatabaseManager.shared.findSong(with: query.lowercased(), completion: {
                content in
                DispatchQueue.main.async {
                    vc.update(with: content)
                }
            })
            
        } else if contentType == .album {
            DatabaseManager.shared.findAlbum(with: query.lowercased(), completion: {
                content in
                DispatchQueue.main.async {
                    vc.update(with: content)
                }
            })
            
        }
    }
    
    private func grabSearchHistory() {
        if self.contentType == .album {
            self.recentSearches = InformationManager.shared.AlbumSearchHistory
        } else if contentType == .song {
            self.recentSearches = InformationManager.shared.SongSearchHistory
        }
        
        self.recentSearches = self.recentSearches.reversed()
        if self.recentSearches.isEmpty {
            showNoSearchHistory()
        } else {
            showSearchHistory()
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
}


extension TopSongOrAlbumSearchViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewController(_ vc: SearchResultsViewController, didSelectItemWith content: Content) {
        
        guard let userId = InformationManager.shared.getUserId() else {return}
        
        
        if contentType == .album {
            InformationManager.shared.addItem(content: content)
            
            let newTopFive = TopFive(rank: self.rank, contentId: content.contentId, name: content.name, artist: content.ArtistName, imageUrl: content.imageUrl)
            let rankReference = documentReference(rank: self.rank)
            
            DatabaseManager.shared.changeTopFive(topFiveModel: newTopFive, rank: rankReference, userId: userId, completion: {
                [weak self] success in
                if success {
                    NotificationCenter.default.post(name: NSNotification.Name("didPostContent"), object: nil)
                    self?.navigationController?.popToRootViewController(animated: true)
                } else {
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            })
        
            
            
        } else if contentType == .song {
            InformationManager.shared.addItem(content: content)
            
            let newTopTen = TopTen(rank: self.rank, contentId: content.contentId, name: content.name, artist: content.ArtistName, imageUrl: content.imageUrl)
            let rankReference = documentReference(rank: self.rank)
            
            DatabaseManager.shared.changeTopTen(topTenModel: newTopTen, rank: rankReference, userId: userId, completion: {
                [weak self] success in
                if success {
                    NotificationCenter.default.post(name: NSNotification.Name("didPostContent"), object: nil)
                    self?.navigationController?.popToRootViewController(animated: true)
                } else {
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            })
            
        }
    }
}

extension TopSongOrAlbumSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        guard let userId = InformationManager.shared.getUserId() else {return}
        
        if searchItem.isSong {
            let newTopTen = TopTen(rank: self.rank, contentId: searchItem.contentId, name: searchItem.name, artist: searchItem.ArtistName, imageUrl: searchItem.imageUrl)
            let rankReference = documentReference(rank: self.rank)
            
            DatabaseManager.shared.changeTopTen(topTenModel: newTopTen, rank: rankReference, userId: userId, completion: {
                [weak self] success in
                if success {
                    NotificationCenter.default.post(name: NSNotification.Name("didPostContent"), object: nil)
                    self?.navigationController?.popToRootViewController(animated: true)
                } else {
                    
                }
            })
        } else if searchItem.isAlbum {
            let newTopFive = TopFive(rank: self.rank, contentId: searchItem.contentId, name: searchItem.name, artist: searchItem.ArtistName, imageUrl: searchItem.imageUrl)
            let rankReference = documentReference(rank: self.rank)
            
            DatabaseManager.shared.changeTopFive(topFiveModel: newTopFive, rank: rankReference, userId: userId, completion: {
                [weak self] success in
                if success {
                    NotificationCenter.default.post(name: NSNotification.Name("didPostContent"), object: nil)
                    self?.navigationController?.popToRootViewController(animated: true)
                } else {
                    
                }
            })
        }
    }
}


extension TopSongOrAlbumSearchViewController {
    func documentReference(rank:Int) -> String {
        if rank == 1 {
            return "first"
        } else if rank == 2 {
            return "second"
        } else if rank == 3 {
            return "third"
        } else if rank == 4 {
            return "fourth"
        } else if rank == 5 {
            return "fifth"
        } else if rank == 6 {
            return "sixth"
        } else if rank == 7 {
            return "seventh"
        } else if rank == 8 {
            return "eighth"
        } else if rank == 9 {
            return "ninth"
        } else {
            return "tenth"
        }
    }
}
