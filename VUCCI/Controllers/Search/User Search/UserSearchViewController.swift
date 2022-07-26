//
//  UserSearchViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 5/6/22.
//

import UIKit

class UserSearchViewController: UIViewController, UISearchResultsUpdating, UserSearchResultsViewControllerDelegate {
    
    let searchVC = UISearchController(searchResultsController: UserSearchResultsViewController())
    
    private var recentSearches: [User] = []
    
    private let recentSearchesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 25, weight: .thin)
        label.text = "RECENT SEARCHES"
        return label
    }()
    
    private let noSearchHistoryLabel: UILabel = {
        let label = UILabel()
        label.text = "NO USER SEARCH HISTORY"
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 22, weight: .thin)
        label.isHidden = true
        return label
    }()
    
    private let magnifyingGlassImage: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.isHidden = true
        return button
    }()
    
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "User Search"
        view.addSubview(tableView)
        view.addSubview(recentSearchesLabel)
        view.addSubview(noSearchHistoryLabel)
        view.addSubview(tableView)
        view.addSubview(magnifyingGlassImage)
        tableView.delegate = self
        tableView.dataSource = self
        
        (searchVC.searchResultsController as? UserSearchResultsViewController)?.delegate = self
        searchVC.searchResultsUpdater = self
        searchVC.searchBar.placeholder = "Search For Users"
        navigationItem.searchController = searchVC
        
        grabRecentSearches()
        
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        recentSearchesLabel.frame = CGRect(x: 10, y: view.safeAreaInsets.top + 38, width: view.width - 20, height: 25)
        tableView.frame = CGRect(x: 0, y: recentSearchesLabel.bottom + 10, width: view.width, height: view.height - 30 - 60 - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
        
        noSearchHistoryLabel.frame = CGRect(x: 10, y: (view.height)/2 - 70, width: view.width - 20, height: 25)
        magnifyingGlassImage.frame = CGRect(x: (view.width - 60)/2, y: noSearchHistoryLabel.bottom + 10, width: 60, height: 60)
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let vc = searchController.searchResultsController as? UserSearchResultsViewController, let query = searchController.searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        //Database call
        DatabaseManager.shared.findUsers(with: query.lowercased(), completion: {
            users in
            DispatchQueue.main.async {
                vc.update(with: users)
            }
        })
    }
    
    func userSearchResultsViewControllerDidTapUser(_ vc: UserSearchResultsViewController, didSelectUserWith user: User) {
        if (InformationManager.shared.UserSearchHistory.contains { item in
            if item.userId == user.userId {
                return true
            } else {
                return false
            }
        }) == false {
            InformationManager.shared.UserSearchHistory.append(user)
        }
       
        grabRecentSearches()
        
        searchVC.resignFirstResponder()
        
        guard let currentUserId = InformationManager.shared.getUserId() else {return}
        if user.userId == currentUserId { return }
        let vc = ArtistOrUserViewController(userId: user.userId)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func grabRecentSearches() {
        self.recentSearches = InformationManager.shared.UserSearchHistory
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

extension UserSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchItem = recentSearches[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
        cell.configure(with: searchItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let searchItem = recentSearches[indexPath.row]
        let vc = ArtistOrUserViewController(userId: searchItem.userId)
        navigationController?.pushViewController(vc, animated: true)
    }
}
