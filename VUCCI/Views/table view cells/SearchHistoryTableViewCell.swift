//
//  SearchHistoryTableViewCell.swift
//  VUCCI
//
//  Created by Jason bartley on 5/3/22.
//

import UIKit

class SearchHistoryTableViewCell: UITableViewCell {
    
    static let identifier = "SearchHistoryTableViewCell"

    private let searchedText: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 23, weight: .thin)
        return label
    }()
    
    private let contentImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .secondarySystemBackground
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(searchedText)
        addSubview(contentImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let contentImageSize: CGFloat = contentView.height/1.4
        contentImage.frame = CGRect(x: 20, y: (contentView.height - contentImageSize)/2, width: contentImageSize, height: contentImageSize)
        searchedText.frame = CGRect(x: contentImage.right + 7, y: (contentView.height - 30)/2, width: contentView.width - 30 - contentImageSize , height: 30)
    }
    
    public func configure(content: Content) {
        self.searchedText.text = content.name.uppercased()
        guard let imageUrl = URL(string: content.imageUrl) else {return}
        contentImage.sd_setImage(with: imageUrl)
    }
}
