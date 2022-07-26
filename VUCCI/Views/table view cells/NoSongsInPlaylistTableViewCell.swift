//
//  NoSongsInPlaylistTableViewCell.swift
//  VUCCI
//
//  Created by Jason bartley on 5/2/22.
//

import UIKit

protocol NoSongsInPlaylistTableViewCellDelegate: AnyObject {
    func NoSongsInPlaylistTableViewCellDidTapAdd()
}

class NoSongsInPlaylistTableViewCell: UITableViewCell {
    
    public weak var delegate: NoSongsInPlaylistTableViewCellDelegate?
    
    static let identifier = "NoSongsInPlaylistTableViewCell"

    private let noSongLabel: UILabel = {
        let label = UILabel()
        label.text = "NO SONGS IN PLAYLIST"
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .thin)
        return label
    }()
    
    private let addSongsButton: UIButton = {
        let button = UIButton()
        button.setTitle("ADD SONGS", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 20
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(noSongLabel)
        contentView.addSubview(addSongsButton)
        
        addSongsButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        noSongLabel.frame = CGRect(x: 5, y: contentView.top + 25, width: contentView.width - 10, height: 25)
        addSongsButton.frame = CGRect(x: (contentView.width - 140)/2, y: noSongLabel.bottom + 15, width: 140, height: 40)
    }
    
    @objc func didTapAdd() {
        delegate?.NoSongsInPlaylistTableViewCellDidTapAdd()
    }
    
    public func configure(isCreator: Bool) {
        if isCreator == false {
            addSongsButton.isHidden = true
            addSongsButton.isUserInteractionEnabled = false
        }
    }
    
    
}
