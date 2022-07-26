//
//  SelectPlaylistPictureViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 4/13/22.
//

import UIKit
import Photos
import PhotosUI
import AVFoundation
import Foundation

class SelectPlaylistPictureViewController: UIViewController {
    
    public let addPhotoButton: UILabel = {
        let label = UILabel()
        label.text = "SELECT"
        label.textColor = .white
        label.backgroundColor = .systemGreen
        label.layer.cornerRadius = 20
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.isHidden = false
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    public let selectPhotoLabel: UILabel = {
        let label = UILabel()
        label.text = "Select A Playlist Cover Photo"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .thin)
        label.textColor = .label
        return label
    }()
    
    public let reselectButton: UIButton = {
        let button = UIButton()
        button.setTitle("RESELECT", for: .normal)
        button.layer.cornerRadius = 12
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        button.isHidden = true
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(addPhotoButton)
        view.addSubview(reselectButton)
        view.addSubview(selectPhotoLabel)
        
        let addPhotoTap = UITapGestureRecognizer(target: self, action: #selector(addPhoto))
        addPhotoButton.addGestureRecognizer(addPhotoTap)
        reselectButton.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let reselectButtonSize: CGFloat = 120
        let imageSize: CGFloat = view.width * 0.80
        selectPhotoLabel.frame = CGRect(x: 10, y: view.safeAreaInsets.top + 20, width: view.width - 20, height: 20)
        reselectButton.frame = CGRect(x: (view.width - reselectButtonSize)/2, y: view.safeAreaInsets.top + 20, width: reselectButtonSize, height: 40)
        imageView.frame = CGRect(x: (view.width - imageSize)/2 , y: reselectButton.bottom + 15, width: imageSize, height: imageSize)
        
        addPhotoButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addPhotoButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addPhotoButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        
    }
    
    @objc private func addPhoto() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
}

extension SelectPlaylistPictureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        imageView.image = image
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.imageView.isHidden = false
            self?.reselectButton.isHidden = false
            self?.addPhotoButton.isHidden = true
            self?.selectPhotoLabel.isHidden = true
        })
        
        addPhotoButton.isUserInteractionEnabled = false
    }
}
