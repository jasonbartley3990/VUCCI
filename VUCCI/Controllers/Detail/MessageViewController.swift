//
//  MessageViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 4/19/22.
//

import UIKit

class MessageViewController: UIViewController {
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBackground
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .thin)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .label
        view.addSubview(messageLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        messageLabel.frame = CGRect(x: 5, y: (view.height - 35)/2, width: view.width - 10, height: 35)
    }
    
    public func didReceiveMessage(event: messageTypes) {
        switch event {
            
        case .likedSong:
            messageLabel.text = "ADDED TO LIKES"
        case .unlikedSong:
            messageLabel.text = "REMOVED FROM LIKES"
        case .changedAccountType:
            messageLabel.text = "ACCOUNT CHANGED"
        case .addedToPlaylist:
            messageLabel.text = "ADDED TO PLAYLIST"
        case .addedToCollection:
            messageLabel.text = "ADDED TO COLLECTION"
        case .removeFromCollection:
            messageLabel.text = "REMOVED FROM COLLECTION"
        case .shared:
            messageLabel.text = "SHARED CONTENT"
        case .deletePlaylist:
            messageLabel.text = "PLAYLIST DELETED"
        case .removeFromPlaylist:
            messageLabel.text = "REMOVED FROM PLAYLIST"
        }
    }
    

}
