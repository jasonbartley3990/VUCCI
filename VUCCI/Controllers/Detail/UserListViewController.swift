//
//  UserListViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 4/21/22.
//

import UIKit

class UserListViewController: UIViewController {
    
    private var users: [User] = []
    
    private let isFollowers: Bool
    
    private let userInQuestion: String
    
    private var profilesTableView: UITableView = {
        let table = UITableView()
        table.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        return table
    }()
    
    private let loadingViewChildVC = LoadingViewController()
    
    init(followers: Bool, user: String) {
        self.isFollowers = followers
        self.userInQuestion = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(profilesTableView)
        profilesTableView.delegate = self
        profilesTableView.dataSource = self
        
        addChild(loadingViewChildVC)
        view.addSubview(loadingViewChildVC.view)
        loadingViewChildVC.didMove(toParent: self)
        loadingViewChildVC.view.alpha = 0
        loadingViewChildVC.view.layer.cornerRadius = 20
        loadingViewChildVC.view.clipsToBounds = true
        loadingViewChildVC.view.backgroundColor = .label
        loadingViewChildVC.ImageView.tintColor = .systemBackground
        loadingViewChildVC.ImageView.backgroundColor = .label
        
        if self.isFollowers {
            grabFollowers()
        } else {
            grabFollowing()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profilesTableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 60)
        
        loadingViewChildVC.view.frame = CGRect(x: ((view.width - (view.width * 0.4))/2), y: (view.height - (view.width * 0.4))/2, width: (view.width * 0.4), height: (view.width * 0.4))
    }
    
    private func grabFollowers() {
        DatabaseManager.shared.getUsersFollowers(user: self.userInQuestion, completion: {
            [weak self] users, success in
            if success {
                let group = DispatchGroup()
                
                for user in users {
                    group.enter()
                    DatabaseManager.shared.findAUserWithId(userId: user.user, completion: {
                        [weak self] user in
                        defer {
                            group.leave()
                        }
                        guard let user = user else {return}
                        self?.users.append(user)
                    })
                }
                group.notify(queue: .main, execute: {
                    self?.hideLoadingView()
                    self?.profilesTableView.reloadData()
                })
            } else {
                self?.hideLoadingView()
                self?.showError()
            }
        })
    }
    
    private func grabFollowing() {
        DatabaseManager.shared.getUsersFollowing(user: self.userInQuestion, completion: {
            [weak self] users, success in
            if success {
                let group = DispatchGroup()
                
                for user in users {
                    group.enter()
                    DatabaseManager.shared.findAUserWithId(userId: user.user, completion: {
                        [weak self] user in
                        defer {
                            group.leave()
                        }
                        guard let user = user else {return}
                        self?.users.append(user)
                    })
                }
                
                group.notify(queue: .main, execute: {
                    self?.hideLoadingView()
                    self?.profilesTableView.reloadData()
                })
            } else {
                self?.hideLoadingView()
                self?.showError()
            }
        })
    }
    
    
    public func showError() {
        DispatchQueue.main.async { [weak self] in
            self?.profilesTableView.isHidden = true
            let ac = UIAlertController(title: "An issue occured!", message: "Please try again later", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }))
            self?.present(ac, animated: true)
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
}

extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
        cell.configure(with: user)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = users[indexPath.row]
        guard let currentUserId = UserDefaults.standard.string(forKey: "userId") else {return}
        if user.userId == currentUserId { return }
        let vc = ArtistOrUserViewController(userId: user.userId)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
