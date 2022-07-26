//
//  SearchResultsViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 2/18/22.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewController(_ vc: SearchResultsViewController, didSelectItemWith content: Content)
}

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var items = [Content]()
    
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    public let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ContentTableViewCell.self, forCellReuseIdentifier: ContentTableViewCell.identifier)
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
    
    public func update(with items: [Content]) {
        self.items = items
        
        if self.items.isEmpty {
            let noResult = Content(name: "", isArtist: true, isSong: true, isAlbum: true, isPlaylist: true, imageUrl: "", ArtistName: "", contentCreator: "", orderNumber: nil, isPublic: true, contentId: "no results", songIds: [], yearPosted: "", albumId: nil, duration: nil, playlistSongCount: nil, totalStreams: nil)
            self.items.append(noResult)
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
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.items[indexPath.row]
        if item.contentId == "no results" {
            return
        }
        delegate?.searchResultsViewController(self, didSelectItemWith: items[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        
        if item.contentId == "no results" {
            let cell = tableView.dequeueReusableCell(withIdentifier: NoResultsTableViewCell.identifier, for: indexPath) as! NoResultsTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.identifier, for: indexPath) as! ContentTableViewCell
            cell.configure(with: items[indexPath.row], index: indexPath.row)
            cell.moreButton.isHidden = true
            return cell
        }
    }
    
}
