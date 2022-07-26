//
//  SignInViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 2/18/22.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = false
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    
    private let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .secondarySystemBackground
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "vucciLogo")
        return imageView
    }()
    
    private let emailTextField: VucciTextField = {
        let textField = VucciTextField()
        textField.placeholder = "EMAIL"
        textField.isUserInteractionEnabled = true
        textField.textAlignment = .center
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.font = .systemFont(ofSize: 20, weight: .thin)
        return textField
    }()
    
    private let passwordTextField: VucciTextField = {
        let textField = VucciTextField()
        textField.placeholder = "PASSWORD"
        textField.isUserInteractionEnabled = true
        textField.textAlignment = .center
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.font = .systemFont(ofSize: 20, weight: .thin)
        return textField
    }()
    
    private let emailLine: UILabel = {
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
    
    private let signInButton: UILabel = {
        let label = UILabel()
        label.text = "SIGN IN"
        label.textColor = .white
        label.backgroundColor = .systemGreen
        label.layer.cornerRadius = 20
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let createAccountButton: UILabel = {
        let label = UILabel()
        label.text = "CREATE ACCOUNT"
        label.textColor = .label
        label.backgroundColor = .systemBackground
        label.layer.cornerRadius = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private var didShift: Bool = false
    
    private let loadingViewChildVC = LoadingViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "SIGN IN"
        view.addSubview(scrollView)
        view.addSubview(logoImage)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(emailLine)
        view.addSubview(passwordLine)
        view.addSubview(createAccountButton)
        view.addSubview(signInButton)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                logoImage.image = UIImage(named: "vucciLogo")
            case .dark:
                logoImage.image = UIImage(named: "vucciLogoDarkMode")
            @unknown default:
                logoImage.image = UIImage(named: "vucciLogo")
        }
        
        
        self.addChild(self.loadingViewChildVC)
        self.view.addSubview(self.loadingViewChildVC.view)
        self.loadingViewChildVC.didMove(toParent: self)
        loadingViewChildVC.view.alpha = 0
        loadingViewChildVC.view.layer.cornerRadius = 20
        loadingViewChildVC.view.clipsToBounds = true
        loadingViewChildVC.view.backgroundColor = .label
        loadingViewChildVC.ImageView.tintColor = .systemBackground
        loadingViewChildVC.ImageView.backgroundColor = .label
        
        let signInTap = UITapGestureRecognizer(target: self, action: #selector(didTapSignIn))
        signInButton.addGestureRecognizer(signInTap)
        
        let createAccountTap = UITapGestureRecognizer(target: self, action: #selector(didTapCreateAccount))
        createAccountButton.addGestureRecognizer(createAccountTap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        scrollView.contentSize = CGSize(width: view.width, height: 900)
        
        scrollView.addSubview(logoImage)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(emailLine)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(passwordLine)
        scrollView.addSubview(signInButton)
        scrollView.addSubview(createAccountButton)
        
        let logoSize:CGFloat = view.width * 0.6
        logoImage.frame = CGRect(x: (view.width - logoSize)/2, y: view.safeAreaInsets.top - 30, width: logoSize, height: logoSize)
        emailTextField.frame = CGRect(x: 20, y: logoImage.bottom, width: view.width - 40, height: 30)
        emailLine.frame = CGRect(x: 45, y: emailTextField.bottom, width: view.width - 90, height: 3)
        passwordTextField.frame = CGRect(x: 20, y: emailLine.bottom + 15, width: view.width - 40, height: 30)
        passwordLine.frame = CGRect(x: 45, y: passwordTextField.bottom, width: view.width - 90, height: 3)
        signInButton.frame = CGRect(x: (view.width - 140)/2, y: passwordLine.bottom + 30, width: 140, height: 40)
        createAccountButton.frame = CGRect(x: 30, y: signInButton.bottom + 20, width: view.width - 60, height: 25)
        
        loadingViewChildVC.view.frame = CGRect(x: ((view.width - (view.width * 0.4))/2), y: (view.height - (view.width * 0.4))/2, width: (view.width * 0.4), height: (view.width * 0.4))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            didTapSignIn()
        }
        
        return true
    }
    
    @objc func didTapCreateAccount() {
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapSignIn() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let email = emailTextField.text?.lowercased(), let password = passwordTextField.text,
              !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            DispatchQueue.main.async {
                let ac = UIAlertController(title: "Invalid fields", message: "Please make sure all fields are filled out correctly", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(ac, animated: true)
            }
            return
        }
        
        self.showLoadingView()
        AuthenticationManager.shared.signIn(email: email, password: password) {
            [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.hideLoadingView()
                    let vc = TabBarViewController()
                    vc.modalPresentationStyle = .fullScreen
                    DispatchQueue.main.async {
                        self?.present(vc, animated: true)
                    }
                case .failure(_):
                    self?.hideLoadingView()
                    let ac = UIAlertController(title: "Wrong username or password", message: nil, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    DispatchQueue.main.async {
                        self?.present(ac, animated: true)
                    }
                }
            }
        }
    }

}

extension SignInViewController {
    private func showLoadingView() {
        DispatchQueue.main.async {
            [weak self] in
            self?.loadingViewChildVC.view.alpha = 1
            self?.loadingViewChildVC.startAnimation()
        }
    }
    
    private func hideLoadingView() {
        
        DispatchQueue.main.async {
            [weak self] in
            self?.loadingViewChildVC.view.alpha = 0
            self?.loadingViewChildVC.ImageView.transform = .identity
        }
        
    }
    
    @objc func willEnterForeground() {
        DispatchQueue.main.async { [weak self] in
            
            switch self?.traitCollection.userInterfaceStyle {
                case .light, .unspecified:
                    self?.logoImage.image = UIImage(named: "vucciLogo")
                case .dark:
                    self?.logoImage.image = UIImage(named: "vucciLogoDarkMode")
                @unknown default:
                    self?.logoImage.image = UIImage(named: "vucciLogo")
            }
        }
        
    }
    
}
