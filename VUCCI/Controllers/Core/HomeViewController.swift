//
//  HomeViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 2/18/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var posts: [Post] = []
    private var viewModels: [PostType] = []
    private var recommendedUsers: [User] = []
    
    private var homeFeedCollectionView: UICollectionView?

    let header = RecommendedUsersTableHeader()
    
    private let userTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.isHidden = true
        return tableView
    }()
    
    private let couldNotGetPostsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.text = "Unable to get posts"
        label.font = .systemFont(ofSize: 18, weight: .thin)
        label.isHidden = true
        return label
    }()
    
    private let postsErrorImage: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "exclamationmark.icloud.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 90))
        button.setImage(image, for: .normal)
        button.isHidden = true
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let noPostsToShowLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.text = "NO POSTS TO SHOW"
        label.font = .systemFont(ofSize: 20, weight: .thin)
        label.isHidden = true
        return label
    }()
    
    private let loadingViewChildVC = LoadingViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "VUCCI"
       
        view.addSubview(userTableView)
        view.addSubview(postsErrorImage)
        view.addSubview(couldNotGetPostsLabel)
        view.addSubview(noPostsToShowLabel)
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.tableHeaderView = header
        header.delegate = self
        
        switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                header.recommendedUsersLabel.textColor = .darkGray
            case .dark:
                header.recommendedUsersLabel.textColor = .label
            @unknown default:
                header.recommendedUsersLabel.textColor = .darkGray
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: #selector(findUsers))
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didFollow), name: Notification.Name("didFollow"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didUnfollow), name: Notification.Name("didUnfollow"), object: nil)
        
        self.addBlurToViewController()
        addChild(loadingViewChildVC)
        view.addSubview(loadingViewChildVC.view)
        loadingViewChildVC.didMove(toParent: self)
        loadingViewChildVC.view.alpha = 1
        loadingViewChildVC.view.layer.cornerRadius = 20
        loadingViewChildVC.view.clipsToBounds = true
        loadingViewChildVC.startAnimation()
        
        grabFollowingPosts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedCollectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 60)
        userTableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 60)
        header.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: 200)
        
        couldNotGetPostsLabel.frame = CGRect(x: 10, y: (view.height/2) - 50, width: view.width - 20, height: 40)
        postsErrorImage.frame = CGRect(x: (view.width - 110)/2, y: couldNotGetPostsLabel.bottom + 10, width: 110, height: 110)
        noPostsToShowLabel.frame = CGRect(x: 10, y: (view.height/2), width: view.width - 20, height: 30)
        
        loadingViewChildVC.view.frame = CGRect(x: ((view.width - (view.width * 0.4))/2), y: (view.height - (view.width * 0.4))/2, width: (view.width * 0.4), height: (view.width * 0.4))
        
    }
    
    private func grabFollowingPosts() {
        self.posts.removeAll()
        self.viewModels.removeAll()
        guard let userId = InformationManager.shared.getUserId() else {
            self.unableToGetFollowing()
            self.stopLoadingView()
            return
        }
        
        DatabaseManager.shared.getUsersFollowing(user: userId, completion: {
            [weak self] users, success in
            
            guard success else {
                self?.stopLoadingView()
                self?.unableToGetFollowing()
                return
            }
            
            let group = DispatchGroup()
            
            if users.count == 0 {
                self?.grabRecommendedUsers()
            } else {
                self?.configureCollectionView()
                for user in users {
                    group.enter()
                    DatabaseManager.shared.grabUsersLatestPost(userId: user.user, completion: {
                        [weak self] posts in
                        defer {
                            group.leave()
                        }
                        guard let posts = posts else {
                            self?.unableToGetFollowing()
                            self?.stopLoadingView()
                            return
                        }
                        
                        for post in posts {
                            if post.postType == "like" {
                                let newViewModel = PostType.likeCell(viewModel: LikeCellPostViewModel(posterId: post.posterId, songImageUrl: post.contentImageUrl, contentName: post.contentName, contentCreatorName: post.contentCreator, contentType: post.contentType, contentId: post.contentId))
                                self?.viewModels.append(newViewModel)
                            } else if post.postType == "newPlaylist" {
                                let newViewModel = PostType.newPlaylistCell(viewModel: NewPlaylistPostViewModel(playlistCreator: post.posterId, playlistName: post.contentName, playlistImageUrl: post.contentImageUrl, contentId: post.contentId))
                                self?.viewModels.append(newViewModel)
                            } else if post.postType == "newMusic" {
                                let newViewModel = PostType.newMusicCell(viewModel: NewMusicPostViewModel(contentCreator: post.contentCreator, songImageUrl: post.contentImageUrl, contentName: post.contentName, contentType: post.contentType, contentId: post.contentId))
                                self?.viewModels.append(newViewModel)
                            }
                        }
                    })
                    
                    group.notify(queue: .main, execute: {
                        self?.stopLoadingView()
                        
                        guard let vms = self?.viewModels else {return}
                        if vms.isEmpty {
                            self?.showNoPosts()
                        } else {
                            self?.homeFeedCollectionView?.reloadData()
                            self?.homeFeedCollectionView?.isHidden = false
                            self?.couldNotGetPostsLabel.isHidden = true
                            self?.postsErrorImage.isHidden = true
                            self?.noPostsToShowLabel.isHidden = true
                            self?.userTableView.isHidden = true
                        }
                    })
                }
            }
        })
    }
    
    public func grabRecommendedUsers() {
        guard let userId = InformationManager.shared.getUserId() else {return}
        
        DatabaseManager.shared.grabRecommendedUsers(completion: {
            [weak self] users in
            var recommendedUsers = users
            for (index, user) in recommendedUsers.enumerated() {
                if user.userId == userId {
                    recommendedUsers.remove(at: index)
                }
            }
            
            self?.recommendedUsers = recommendedUsers
            
            DispatchQueue.main.async {
                self?.stopLoadingView()
                self?.userTableView.reloadData()
                self?.userTableView.isHidden = false
                self?.noPostsToShowLabel.isHidden = true
                self?.couldNotGetPostsLabel.isHidden = true
                self?.postsErrorImage.isHidden = true
                self?.homeFeedCollectionView?.isHidden = true
            }
        })
    }
    
    @objc func findUsers() {
        let vc = UserSearchViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //when view enters foreground make sure to reload the user table view
    
    @objc func willEnterForeground() {
        DispatchQueue.main.async { [weak self] in
            self?.userTableView.reloadData()
        }
    }
    
    //error with database fetch show error
    
    private func unableToGetFollowing() {
        DispatchQueue.main.async { [weak self] in
            self?.postsErrorImage.isHidden = false
            self?.couldNotGetPostsLabel.isHidden = false
            self?.userTableView.isHidden = true
            self?.homeFeedCollectionView?.isHidden = true
            self?.noPostsToShowLabel.isHidden = true
        }
    }
    
    //following has not posted anything show label
    
    private func showNoPosts() {
        DispatchQueue.main.async { [weak self] in
            self?.postsErrorImage.isHidden = true
            self?.couldNotGetPostsLabel.isHidden = true
            self?.userTableView.isHidden = true
            self?.homeFeedCollectionView?.isHidden = true
            self?.noPostsToShowLabel.isHidden = false
        }
    }
    
    //grab new following post because user followed somebody
    
    @objc func didFollow() {
        grabFollowingPosts()
    }
    
    //grab following posts after user unfollowed somebody
    
    @objc func didUnfollow() {
        grabFollowingPosts()
    }
    
    private func stopLoadingView() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingViewChildVC.view.alpha = 0
            self?.removeBlurFromViewController()
            self?.loadingViewChildVC.ImageView.transform = .identity
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = viewModels[indexPath.row]
        switch cell {
        case .likeCell(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikedCollectionViewCell.identifier, for: indexPath) as? LikedCollectionViewCell else {
                fatalError()
            }
            cell.container.delegate = self
            cell.configure(with: viewModel)
            return cell
        case .newMusicCell(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewMusicCollectionViewCell.identifier, for: indexPath) as? NewMusicCollectionViewCell else {
                fatalError()
            }
            cell.container.delegate = self
            cell.configure(with: viewModel)
            return cell
        case .newPlaylistCell(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewPlaylistPostCollectionViewCell.identifier, for: indexPath) as? NewPlaylistPostCollectionViewCell else {
                fatalError()
            }
            cell.container.delegate = self
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    private func configureCollectionView() {
        let sectionHeight: CGFloat = 115

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: {
            index, _ -> NSCollectionLayoutSection? in

            let post = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(115)))

            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(sectionHeight)), subitems: [post]
            )
            
            let section = NSCollectionLayoutSection(group: group)

            section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 10, trailing: 0)

            return section
        }))
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isHidden = false
        collectionView.register(NewMusicCollectionViewCell.self, forCellWithReuseIdentifier: NewMusicCollectionViewCell.identifier)
        collectionView.register(LikedCollectionViewCell.self, forCellWithReuseIdentifier: LikedCollectionViewCell.identifier)
        collectionView.register(NewPlaylistPostCollectionViewCell.self, forCellWithReuseIdentifier: NewPlaylistPostCollectionViewCell.identifier)
        view.addSubview(collectionView)
        self.homeFeedCollectionView = collectionView
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendedUsers.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = recommendedUsers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
        cell.configure(with: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = recommendedUsers[indexPath.row]
        let vc = ArtistOrUserViewController(userId: user.userId)
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension HomeViewController: PostContainerViewDelegate {
    func PostContainerDelegateDidTapPoster(_ view: PostContainerView, poster: String) {
        let vc = ArtistOrUserViewController(userId: poster)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func PostContainerDelegateDidTapCell(_ view: PostContainerView, contentId: String, type: ContentType) {
        
        DatabaseManager.shared.findSong(withId: contentId, completion: {
            [weak self] content in
            guard let content = content else {return}
            if type == .song {
                SharedSongManager.shared.currentQueuePosition = 0
                SharedSongManager.shared.wasQueued = false
                SharedSongManager.shared.currentSong = content
            } else if type == .album {
                let vc = SongGroupDetailViewController(contentData: content)
                self?.navigationController?.pushViewController(vc, animated: true)
            } else if type == .playlist {
                let vc = SongGroupDetailViewController(contentData: content)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
}

extension HomeViewController: RecommendedUsersTableHeaderDelegate {
    func recommendedUsersTableHeaderDidTapFindUsers() {
        findUsers()
    }
}

