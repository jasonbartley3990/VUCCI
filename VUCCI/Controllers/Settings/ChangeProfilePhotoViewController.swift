//
//  ChangeProfilePhotoViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 5/9/22.
//

import UIKit

class ChangeProfilePhotoViewController: UIViewController {
    
    public let changeButton: UILabel = {
        let label = UILabel()
        label.text = "SELECT"
        label.textColor = .white
        label.backgroundColor = .systemGreen
        label.layer.cornerRadius = 20
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
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
        label.text = "Select A New Profile Photo"
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
    
    private let loadingViewChildVC = LoadingViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(reselectButton)
        view.addSubview(selectPhotoLabel)
        view.addSubview(changeButton)
        
        addChild(loadingViewChildVC)
        view.addSubview(loadingViewChildVC.view)
        loadingViewChildVC.didMove(toParent: self)
        loadingViewChildVC.view.alpha = 0
        loadingViewChildVC.view.layer.cornerRadius = 20
        loadingViewChildVC.view.clipsToBounds = true
        loadingViewChildVC.view.backgroundColor = .label
        loadingViewChildVC.ImageView.tintColor = .systemBackground
        loadingViewChildVC.ImageView.backgroundColor = .label
        
        if let currentProfileImage = InformationManager.shared.profileImage {
            imageView.image = currentProfileImage
        }
        
        let changePhotoTap = UITapGestureRecognizer(target: self, action: #selector(didTapChange))
        changeButton.addGestureRecognizer(changePhotoTap)
        
        let reselectTap = UITapGestureRecognizer(target: self, action: #selector(didTapChange))
        reselectButton.addGestureRecognizer(reselectTap)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SAVE", style: .done, target: self, action: #selector(updateProfilePhoto))

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let reselectButtonSize: CGFloat = 120
        let imageSize: CGFloat = view.width * 0.80
        selectPhotoLabel.frame = CGRect(x: 10, y: view.safeAreaInsets.top + 20, width: view.width - 20, height: 20)
        reselectButton.frame = CGRect(x: (view.width - reselectButtonSize)/2, y: selectPhotoLabel.bottom + 8, width: reselectButtonSize, height: 40)
        changeButton.frame = CGRect(x: (view.width - 110)/2, y: selectPhotoLabel.bottom + 8, width: 110, height: 40)
        imageView.frame = CGRect(x: (view.width - imageSize)/2 , y: reselectButton.bottom + 15, width: imageSize, height: imageSize)

        
        loadingViewChildVC.view.frame = CGRect(x: ((view.width - (view.width * 0.4))/2), y: (view.height - (view.width * 0.4))/2, width: (view.width * 0.4), height: (view.width * 0.4))
    }
    
    @objc func updateProfilePhoto() {
        guard let newProfilePhoto = imageView.image else {
            showError()
            return
        }
        
        guard let userId = InformationManager.shared.getUserId() else {
            showError()
            return
        }
        
        let imageData = newProfilePhoto.pngData()
        
        showLoadingView()
        StorageManager.shared.uploadProfilePicture(userId: userId , data: imageData, completion: {
            [weak self] success in
            self?.hideLoadingView()
            if success == false {
                self?.showError()
            } else {
                self?.pictureSuccessfullyChanged()
            }
        })
    }
    
    @objc func didTapChange() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    private func showError() {
        let ac = UIAlertController(title: "An issue occured please try again", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
        DispatchQueue.main.async {
            self.present(ac, animated: true)
        }
        
    }
    
    private func pictureSuccessfullyChanged() {
        InformationManager.shared.profileImage = imageView.image
        NotificationCenter.default.post(name: NSNotification.Name("didChangeProfilePhoto"), object: nil)
        navigationController?.popViewController(animated: true)
    }
    
    private func showLoadingView() {
        DispatchQueue.main.async {
            [weak self] in
            self?.view.isUserInteractionEnabled = false
            self?.loadingViewChildVC.view.alpha = 1
            self?.loadingViewChildVC.startAnimation()
        }
    }
    
    private func hideLoadingView() {
        DispatchQueue.main.async {
            [weak self] in
            self?.loadingViewChildVC.view.alpha = 0
            self?.loadingViewChildVC.view.isUserInteractionEnabled = true
            self?.loadingViewChildVC.ImageView.transform = .identity
        }
        
    }

}

extension ChangeProfilePhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        DispatchQueue.main.async { [weak self] in
            self?.imageView.image = image
            self?.changeButton.isHidden = true
            self?.reselectButton.isHidden = false
            self?.reselectButton.isUserInteractionEnabled = true
        }
        
    }
    
}
