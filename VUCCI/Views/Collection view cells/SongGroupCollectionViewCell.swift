//
//  SongGroupCollectionViewCell.swift
//  VUCCI
//
//  Created by Jason bartley on 4/11/22.
//

import UIKit
import SDWebImage

protocol SongGroupCollectionViewCellDelegate: AnyObject {
    func songGroupCollectionViewCellDidTap(_ cell: SongGroupCollectionViewCell)
}

class SongGroupCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SongGroupCollectionViewCell"
    
    public weak var delegate: SongGroupCollectionViewCellDelegate?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let groupTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(groupTitle)
        contentView.addSubview(imageView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        imageView.addGestureRecognizer(tap)
        groupTitle.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x:7, y: 7, width: contentView.width - 14, height: contentView.width - 14)
        groupTitle.frame = CGRect(x: 5, y: imageView.bottom + 10, width: contentView.width - 10, height: 20)
    }
    
    @objc func didTap() {
        delegate?.songGroupCollectionViewCellDidTap(self)
    }
    
    public func configure(with model: Content) {
        groupTitle.text = model.name.uppercased()
        
        let url = URL(string: model.imageUrl)
        imageView.sd_setImage(with: url)
        
    }
    
    public func configureForLiked() {
        switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                groupTitle.text = "Liked Songs"
                imageView.image = UIImage(named: "Liked")
            case .dark:
                groupTitle.text = "Liked Songs"
                imageView.image = UIImage(named: "LikedDarkMode")
            @unknown default:
                groupTitle.text = "Liked Songs"
                imageView.image = UIImage(named: "Liked")
        }
    }
    
}
