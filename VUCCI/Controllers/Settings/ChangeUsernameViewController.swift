//
//  ChangeUsernameViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 4/21/22.
//

import UIKit

class ChangeUsernameViewController: UIViewController, UITextFieldDelegate {

    private let changeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 19, weight: .thin)
        label.text = "CHANGE USERNAME"
        return label
    }()
    
    private let newUsernameTextField: VucciTextField = {
        let textField = VucciTextField()
        textField.placeholder = "Enter New Username"
        textField.isUserInteractionEnabled = true
        textField.textAlignment = .center
        textField.keyboardType = .default
        textField.font = .systemFont(ofSize: 30, weight: .thin)
        return textField
    }()
    
    private let passwordTextField: VucciTextField = {
        let textField = VucciTextField()
        textField.placeholder = "Enter Password"
        textField.isUserInteractionEnabled = true
        textField.textAlignment = .center
        textField.keyboardType = .default
        textField.font = .systemFont(ofSize: 30, weight: .thin)
        return textField
    }()
        
    private let newUsernameLine: UILabel = {
        let label = UILabel()
        label.backgroundColor = .label
        label.layer.cornerRadius = 1.5
        label.clipsToBounds = true
        return label
    }()
    
    private let passwordLine: UILabel = {
        let label = UILabel()
        label.backgroundColor = .label
        label.layer.cornerRadius = 1.5
        label.clipsToBounds = true
        return label
    }()
    
    private let loadingViewChildVC = LoadingViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(changeLabel)
        view.addSubview(newUsernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(newUsernameLine)
        view.addSubview(passwordLine)
        
        newUsernameTextField.delegate = self
        passwordTextField.delegate = self
        
        addChild(loadingViewChildVC)
        view.addSubview(loadingViewChildVC.view)
        loadingViewChildVC.didMove(toParent: self)
        loadingViewChildVC.view.alpha = 0
        loadingViewChildVC.view.layer.cornerRadius = 20
        loadingViewChildVC.view.clipsToBounds = true
        loadingViewChildVC.view.backgroundColor = .label
        loadingViewChildVC.ImageView.tintColor = .systemBackground
        loadingViewChildVC.ImageView.backgroundColor = .label
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "CHANGE", style: .done, target: self, action: #selector(didTapChange))

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        changeLabel.frame = CGRect(x: 10, y: view.safeAreaInsets.top + 10, width: view.width - 20, height: 35)
        newUsernameTextField.frame = CGRect(x: 20, y: changeLabel.bottom + 35, width: view.width - 40, height: 30)
        newUsernameLine.frame = CGRect(x: 45, y: newUsernameTextField.bottom, width: view.width - 90, height: 3)
        passwordTextField.frame = CGRect(x: 20, y: newUsernameLine.bottom + 35, width: view.width - 40, height: 30)
        passwordLine.frame = CGRect(x: 45, y: passwordTextField.bottom, width: view.width - 90, height: 3)
        
        loadingViewChildVC.view.frame = CGRect(x: ((view.width - (view.width * 0.4))/2), y: (view.height - (view.width * 0.4))/2, width: (view.width * 0.4), height: (view.width * 0.4))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == newUsernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    
    
    @objc func didTapChange() {
        guard let newUsername = newUsernameTextField.text else {
            return
        }
        
        guard let password = passwordTextField.text else {
            return
        }
        
        guard let email = UserDefaults.standard.string(forKey: "email") else {
            return
        }
        
        guard let userId = InformationManager.shared.getUserId() else {
            return
        }
        
        self.showLoadingView()
        AuthenticationManager.shared.changeUsername(userId: userId, newUsername: newUsername, email: email, password: password, completion: {
            [weak self] success, error in
            if success == true {
                let ac = UIAlertController(title: "Username change successful!", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                DispatchQueue.main.async { [weak self] in
                    self?.hideLoadingView()
                    self?.present(ac, animated: true)
                    self?.didChangeUsername(newusername: newUsername)
                }
                
            } else {
                switch error {
                case .wrongPassword:
                    let ac = UIAlertController(title: "Wrong username or password", message: nil, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    DispatchQueue.main.async { [weak self] in
                        self?.hideLoadingView()
                        self?.present(ac, animated: true)
                    }
                case .databaseIssue:
                    let ac = UIAlertController(title: "Something went wrong", message: "Please try again later", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    DispatchQueue.main.async { [weak self] in
                        self?.hideLoadingView()
                        self?.present(ac, animated: true)
                    }
                }
            }
        })
        
    }
    
    private func didChangeUsername(newusername: String) {
        UserDefaults.standard.set(newusername, forKey: "username")
        NotificationCenter.default.post(name: NSNotification.Name("didChangeUsername"), object: nil)
        self.navigationController?.popToRootViewController(animated: true)
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
            self?.view.isUserInteractionEnabled = true
            self?.loadingViewChildVC.view.alpha = 0
            self?.loadingViewChildVC.ImageView.transform = .identity
        }
        
    }

}
