//
//  NewAlbumFooter.swift
//  VUCCI
//
//  Created by Jason bartley on 5/17/22.
//

import UIKit

protocol NewAlbumFooterDelegate: AnyObject {
    func NewAlbumFooterDidTapNext()
}

class NewAlbumFooter: UIView {
    
    public weak var delegate: NewAlbumFooterDelegate?

    private let nextButton: UILabel = {
        let label = UILabel()
        label.text = "next"
        label.textColor = .white
        label.backgroundColor = .systemGreen
        label.layer.cornerRadius = 20
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nextButton)
        
        let nextTap = UITapGestureRecognizer(target: self, action: #selector(didTapNext))
        nextButton.addGestureRecognizer(nextTap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nextButton.frame = CGRect(x: (width - 100)/2, y: 20, width: 100, height: 40)
    }
    
    @objc func didTapNext() {
        delegate?.NewAlbumFooterDidTapNext()
    }
    

}
