//
//  ChangeAccountTypeViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 4/21/22.
//

import UIKit

class ChangeAccountTypeViewController: UIViewController, UITextFieldDelegate {
    
    private var isAnArtist: Bool
    
    private let changeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 19, weight: .thin)
        return label
    }()
    
    private let disclaimerText: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .thin)
        label.textColor = .label
        label.numberOfLines = 3
        return label
    }()
    
    private let changeButton: UILabel = {
        let label = UILabel()
        label.text = "CHANGE"
        label.textColor = .white
        label.backgroundColor = .systemGreen
        label.layer.cornerRadius = 20
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let newArtistNameTextField: VucciTextField = {
        let textField = VucciTextField()
        textField.placeholder = "Your Artist Name"
        textField.isUserInteractionEnabled = true
        textField.textAlignment = .center
        textField.keyboardType = .default
        textField.font = .systemFont(ofSize: 30, weight: .thin)
        return textField
    }()
        
    private let newArtistNameLine: UILabel = {
        let label = UILabel()
        label.backgroundColor = .label
        label.layer.cornerRadius = 1.5
        label.clipsToBounds = true
        return label
    }()
    
    private let loadingViewChildVC = LoadingViewController()
    

    init(isAnArtist: Bool) {
        self.isAnArtist = isAnArtist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(changeLabel)
        view.addSubview(disclaimerText)
        view.addSubview(changeButton)
        view.addSubview(newArtistNameTextField)
        view.addSubview(newArtistNameLine)
        newArtistNameTextField.delegate = self
        
        let changeTap = UITapGestureRecognizer(target: self, action: #selector(didChangeAccount))
        changeButton.addGestureRecognizer(changeTap)
        
        addChild(loadingViewChildVC)
        view.addSubview(loadingViewChildVC.view)
        loadingViewChildVC.didMove(toParent: self)
        loadingViewChildVC.view.alpha = 0
        loadingViewChildVC.view.layer.cornerRadius = 20
        loadingViewChildVC.view.clipsToBounds = true
        loadingViewChildVC.view.backgroundColor = .label
        loadingViewChildVC.ImageView.tintColor = .systemBackground
        loadingViewChildVC.ImageView.backgroundColor = .label
        
        setUpViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        changeLabel.frame = CGRect(x: 10, y: view.safeAreaInsets.top + 5, width: view.width - 20, height: 30)
        disclaimerText.frame = CGRect(x: 10, y: changeLabel.bottom + 10, width: view.width - 20, height: 70)
        
        if isAnArtist {
            changeButton.frame = CGRect(x: (view.width - 120)/2 , y: disclaimerText.bottom + 20, width: 120, height: 40)
        } else {
            newArtistNameTextField.frame = CGRect(x: 20, y: disclaimerText.bottom + 35, width: view.width - 40, height: 30)
            newArtistNameLine.frame = CGRect(x: 45, y: newArtistNameTextField.bottom, width: view.width - 90, height: 3)
            changeButton.frame = CGRect(x: (view.width - 120)/2 , y: newArtistNameLine.bottom + 20, width: 120, height: 40)
        }
        
        loadingViewChildVC.view.frame = CGRect(x: ((view.width - (view.width * 0.4))/2), y: (view.height - (view.width * 0.4))/2, width: (view.width * 0.4), height: (view.width * 0.4))
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    private func setUpViews() {
        if self.isAnArtist {
            changeLabel.text = "CHANGE TO A LISTENER ACCOUNT"
            disclaimerText.text = "If you change and would like to change back,\nall your music will still be connected\nto your account"
        } else {
            changeLabel.text = "CHANGE TO AN ARTIST ACCOUNT"
            disclaimerText.text = "Although artist accounts are free now,\nin the future monthly memberships may be\n implemented."
        }
    }
    
    @objc func didChangeAccount() {
        showLoadingView()
        guard let userId = InformationManager.shared.getUserId() else {
            hideLoadingView()
            return
        }
        
        if isAnArtist {
            DatabaseManager.shared.changeAccountToAListener(userId: userId , completion: {
                [weak self] success in
                if success {
                    self?.changeSuccessful()
                    self?.hideLoadingView()
                } else {
                    self?.showDatabaseError()
                    self?.hideLoadingView()
                }
            })
            
        } else {
            guard let artistName = newArtistNameTextField.text?.lowercased(), !artistName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                showNoNameAlert()
                self.hideLoadingView()
                return
            }
            
            DatabaseManager.shared.checkIfWasAnArtist(contentId: userId, completion: {
                [weak self] wasArtist, error in
                if error == false {
                    if wasArtist {
                        DatabaseManager.shared.changeAccountToAnArtistAccount(userId: userId, artistName: artistName.lowercased(), artistContent: nil, wasPreviouslyAnArtist: true, completion: {
                            [weak self] success in
                            if success {
                                self?.changeSuccessful()
                                self?.hideLoadingView()
                            } else {
                                self?.showDatabaseError()
                                self?.hideLoadingView()
                            }
                        })
                    } else {
                        StorageManager.shared.profilePictureUrl(for: userId, completion: {
                            [weak self] url in
                            guard let profileUrl = url else {
                                self?.showDatabaseError()
                                self?.hideLoadingView()
                                return
                            }

                            let imageUrlString = profileUrl.absoluteString
                            
                            let artistContent = Content(name: artistName, isArtist: true, isSong: false, isAlbum: false, isPlaylist: false, imageUrl: imageUrlString, ArtistName: artistName, contentCreator: userId, orderNumber: nil, isPublic: true, contentId: userId, songIds: [], yearPosted: "", albumId: nil, duration: nil, playlistSongCount: nil, totalStreams: nil)
                            
                            DatabaseManager.shared.changeAccountToAnArtistAccount(userId: userId, artistName: artistName, artistContent: artistContent, wasPreviouslyAnArtist: false, completion: {
                                [weak self] success in
                                if success {
                                    self?.changeSuccessful()
                                    self?.hideLoadingView()
                                } else {
                                    self?.showDatabaseError()
                                    self?.hideLoadingView()
                                }
                            })
                        })
                    }
                    
                } else {
                    self?.showDatabaseError()
                    self?.hideLoadingView()
                }
            })
        }
        
    }
    
    private func changeSuccessful() {
        UserDefaults.standard.set("true", forKey: "isAnArtist")
        NotificationCenter.default.post(name: NSNotification.Name("didChangeAccount"), object: nil)
        self.navigationController?.popToRootViewController(animated: true)
        MessageManager.shared.createdEvent(eventType: .changedAccountType)
    }
    
    private func showNoNameAlert() {
        let ac = UIAlertController(title: "Please enter a name", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
        DispatchQueue.main.async {
            [weak self] in
            self?.present(ac, animated: true)
        }
    }
    
    private func showDatabaseError() {
        let ac = UIAlertController(title: "An Issue Occured", message: "Please Try Again Later", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
        DispatchQueue.main.async {
            [weak self] in
            self?.present(ac, animated: true)
        }
    }
    
    private func showLoadingView() {
        DispatchQueue.main.async {
            [weak self] in
            self?.loadingViewChildVC.view.isUserInteractionEnabled = false
            self?.loadingViewChildVC.view.alpha = 1
            self?.loadingViewChildVC.startAnimation()
        }
    }
    
    private func hideLoadingView() {
        DispatchQueue.main.async {
            [weak self] in
            self?.loadingViewChildVC.view.isUserInteractionEnabled = true
            self?.loadingViewChildVC.view.alpha = 0
            self?.loadingViewChildVC.ImageView.transform = .identity
        }
        
    }
    
}
