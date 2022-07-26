//
//  UploadMenuViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 5/7/22.
//

import UIKit

class UploadMenuViewController: UIViewController {
    
    private let disclaimerLabel: UILabel = {
        let label = UILabel()
        label.text = "If you wish to upload content on VUCCI,\nplease email the address below."
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .thin)
        return label
    }()
    
    private let contactLabel: UILabel = {
        let label = UILabel()
        label.text = "vucciapp@gmail.com"
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 25, weight: .thin)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(contactLabel)
        view.addSubview(disclaimerLabel)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        disclaimerLabel.frame = CGRect(x: 10, y: (view.height - 90)/2, width: view.width - 20, height: 50)
        contactLabel.frame = CGRect(x: 10, y: (disclaimerLabel.bottom + 10), width: view.width - 20, height: 30)
    }
    
}
