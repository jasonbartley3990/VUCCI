//
//  userSearchResultsViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 5/19/22.
//

import UIKit

protocol UserSearchResultsViewControllerDelegate: AnyObject {
    func userSearchResultsViewControllerDidTapUser(_ vc: UserSearchResultsViewController, didSelectUserWith user: User)
}

class UserSearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var users = [User]()
    
    public weak var delegate: UserSearchResultsViewControllerDelegate?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = false
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        tableView.register(NoResultsTableViewCell.self, forCellReuseIdentifier: NoResultsTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public func update(with users: [User]) {
        self.users = users
        if users.isEmpty {
            let noResult = User(isAnArtistAccount: true, email: "", username: "", firstName: "", lastName: "", artistName: "", dateJoined: 0.0, userId: "no results", profileUrl: nil)
            self.users.append(noResult)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.users[indexPath.row]
        if item.userId == "no results" {
            return
        }
        delegate?.userSearchResultsViewControllerDidTapUser(self, didSelectUserWith: users[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = users[indexPath.row]
        
        if item.userId == "no results" {
            let cell = tableView.dequeueReusableCell(withIdentifier: NoResultsTableViewCell.identifier, for: indexPath) as! NoResultsTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
            cell.configure(with: users[indexPath.row])
            return cell
        }
    }
}
