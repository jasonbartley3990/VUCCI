//
//  NewPlaylistNameViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 4/12/22.
//

import UIKit

class NewPlaylistNameViewController: UIViewController, UITextFieldDelegate {
    
    public var newPlaylistName: String = ""
    
    public var isPublic: Bool = true
    
    private let newPlaylistLabel: UILabel = {
        let label = UILabel()
        label.text = "NEW PLAYLIST"
        label.textAlignment = .center
        label.textColor = .label
        label.isUserInteractionEnabled = true
        label.font = .systemFont(ofSize: 30, weight: .thin)
        return label
    }()
    
    private let line: UILabel = {
        let label = UILabel()
        label.backgroundColor = .label
        label.layer.cornerRadius = 1.5
        label.clipsToBounds = true
        return label
    }()
    
    public let newPlaylistNameTextField: VucciTextField = {
        let textField = VucciTextField()
        textField.placeholder = "Enter Name"
        textField.isUserInteractionEnabled = true
        textField.textAlignment = .center
        textField.keyboardType = .default
        textField.font = .systemFont(ofSize: 30, weight: .thin)
        return textField
    }()
    
    private let publicLabel: UILabel = {
        let label = UILabel()
        label.text = "PUBLIC"
        label.font = .systemFont(ofSize: 20, weight: .thin)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let privateLabel: UILabel = {
        let label = UILabel()
        label.text = "PRIVATE "
        label.font = .systemFont(ofSize: 20, weight: .thin)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let publicCheckedButton: UIButton = {
        let button = UIButton()
        button.tintColor = .systemGreen
        let image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let privateCheckedButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))
        button.setImage(image, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(newPlaylistLabel)
        view.addSubview(newPlaylistNameTextField)
        view.addSubview(line)
        view.addSubview(privateLabel)
        view.addSubview(publicLabel)
        view.addSubview(publicCheckedButton)
        view.addSubview(privateCheckedButton)
        
        publicCheckedButton.addTarget(self, action: #selector(didTapPublic), for: .touchUpInside)
        privateCheckedButton.addTarget(self, action: #selector(didTapPrivate), for: .touchUpInside)
        
        newPlaylistNameTextField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        newPlaylistLabel.frame = CGRect(x: 5, y: view.safeAreaInsets.top + 15, width: view.width - 10, height: 40)
        newPlaylistNameTextField.frame = CGRect(x: 45, y: newPlaylistLabel.bottom + 40, width: view.width - 90, height: 40)
        line.frame = CGRect(x: 45, y: newPlaylistNameTextField.bottom, width: view.width - 90, height: 3)
        publicCheckedButton.frame = CGRect(x: 50, y: line.bottom + 40, width: 40, height: 40)
        privateCheckedButton.frame = CGRect(x: 50, y: publicCheckedButton.bottom + 20, width: 40, height: 40)
        
        
        publicLabel.centerYAnchor.constraint(equalTo: publicCheckedButton.centerYAnchor, constant: 0).isActive = true
        publicLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        publicLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true
        publicLabel.leftAnchor.constraint(equalTo: publicCheckedButton.rightAnchor).isActive = true
        
        privateLabel.centerYAnchor.constraint(equalTo: privateCheckedButton.centerYAnchor, constant: 0).isActive = true
        privateLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        privateLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        privateLabel.leftAnchor.constraint(equalTo: privateCheckedButton.rightAnchor).isActive = true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newPlaylistNameTextField.resignFirstResponder()
        return true
    }
    
    
    @objc func didTapPrivate() {
        self.isPublic = false
        let greenCheckedImage = UIImage(systemName: "checkmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        let unCheckedImage = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        DispatchQueue.main.async {
            self.privateCheckedButton.setImage(greenCheckedImage, for: .normal)
            self.privateCheckedButton.tintColor = .systemGreen
            self.publicCheckedButton.setImage(unCheckedImage, for: .normal)
            self.publicCheckedButton.tintColor = .label
        }
    }
    
    @objc func didTapPublic() {
        self.isPublic = true
        let greenCheckedImage = UIImage(systemName: "checkmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        let unCheckedImage = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        DispatchQueue.main.async {
            self.privateCheckedButton.setImage(unCheckedImage, for: .normal)
            self.privateCheckedButton.tintColor = .label
            self.publicCheckedButton.setImage(greenCheckedImage, for: .normal)
            self.publicCheckedButton.tintColor = .systemGreen
        }
    }

}
