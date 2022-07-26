//
//  TopTenView.swift
//  VUCCI
//
//  Created by Jason bartley on 4/14/22.
//

import UIKit

class TopTenView: UIView {
    
    public var isTopTen: Bool = true

    private let myTopTenLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.text = "MY TOP 10"
        label.font = .systemFont(ofSize: 25, weight: .thin)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(myTopTenLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        myTopTenLabel.frame = CGRect(x: 10 , y: (height*0.80)/2 , width: width - 20, height: height*0.8)
        
    }

    public func configure(isTopTen: Bool) {
        if isTopTen == false {
            self.isTopTen = false
            myTopTenLabel.text = "MY TOP 5"
        }
    }
    
}
