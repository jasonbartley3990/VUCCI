//
//  SignUpViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 2/18/22.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    enum steps {
        case stepOne
        case stepTwo
        case stepThree
    }
    
    private var currentStep: steps = .stepOne
    
    private var firstName: String = ""
    private var lastName: String = ""
    private var email: String = ""
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = false
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "vucciLogo")
        return imageView
    }()
    
    private let currentStepLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .thin)
        label.textColor = .label
        label.textAlignment = .center
        label.text = "Step 1: Personal Info"
        return label
    }()
    
    private let stepOneLine: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGreen
        label.layer.cornerRadius = 2
        label.clipsToBounds = true
        return label
    }()
    
    private let stepTwoLine: UILabel = {
        let label = UILabel()
        label.backgroundColor = .label
        label.layer.cornerRadius = 2
        label.clipsToBounds = true
        return label
    }()
    
    private let stepThreeLine: UILabel = {
        let label = UILabel()
        label.backgroundColor = .label
        label.layer.cornerRadius = 2
        label.clipsToBounds = true
        return label
    }()
    
    private let nextToStepTwoButton: UILabel = {
        let label = UILabel()
        label.text = "NEXT"
        label.textColor = .white
        label.backgroundColor = .systemGreen
        label.layer.cornerRadius = 20
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let nextToStepThreeButton: UILabel = {
        let label = UILabel()
        label.text = "NEXT"
        label.textColor = .white
        label.backgroundColor = .systemGreen
        label.layer.cornerRadius = 20
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        label.isHidden = true
        return label
    }()
    
    private let createAccountButton: UILabel = {
        let label = UILabel()
        label.text = "CREATE"
        label.textColor = .white
        label.backgroundColor = .systemGreen
        label.layer.cornerRadius = 20
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        label.isHidden = true
        return label
    }()
    
    private let backToStepOneButton: UILabel = {
        let label = UILabel()
        label.text = "BACK"
        label.textColor = .white
        label.backgroundColor = .systemGreen
        label.layer.cornerRadius = 20
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        label.isHidden = true
        return label
    }()
    
    private let backToStepTwoButton: UILabel = {
        let label = UILabel()
        label.text = "BACK"
        label.textColor = .white
        label.backgroundColor = .systemGreen
        label.layer.cornerRadius = 20
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        label.isHidden = true
        return label
    }()
    
    
    private let reselectButton: UILabel = {
        let label = UILabel()
        label.text = "RESELECT"
        label.textColor = .label
        label.backgroundColor = .systemBackground
        label.layer.cornerRadius = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        label.isHidden = true
        return label
    }()
    
    private let firstNameTextField: VucciTextField = {
        let textField = VucciTextField()
        textField.placeholder = "Enter First Name"
        textField.isUserInteractionEnabled = true
        textField.textAlignment = .center
        textField.keyboardType = .default
        textField.font = .systemFont(ofSize: 20, weight: .thin)
        textField.autocorrectionType = .no
        return textField
    }()
    
    private let lastNameTextField: VucciTextField = {
        let textField = VucciTextField()
        textField.placeholder = "Enter Last Name"
        textField.isUserInteractionEnabled = true
        textField.textAlignment = .center
        textField.keyboardType = .default
        textField.font = .systemFont(ofSize: 20, weight: .thin)
        textField.autocorrectionType = .no
        return textField
    }()
    
    private let emailTextField: VucciTextField = {
        let textField = VucciTextField()
        textField.placeholder = "Enter Email"
        textField.isUserInteractionEnabled = true
        textField.textAlignment = .center
        textField.keyboardType = .default
        textField.font = .systemFont(ofSize: 20, weight: .thin)
        textField.autocorrectionType = .no
        return textField
    }()
    
    private let usernameTextField: VucciTextField = {
        let textField = VucciTextField()
        textField.placeholder = "Enter A Username"
        textField.textAlignment = .center
        textField.keyboardType = .default
        textField.font = .systemFont(ofSize: 20, weight: .thin)
        textField.isHidden = true
        textField.isUserInteractionEnabled = false
        textField.autocorrectionType = .no
        return textField
    }()
    
    private let passwordTextField: VucciTextField = {
        let textField = VucciTextField()
        textField.placeholder = "Enter Password"
        textField.textAlignment = .center
        textField.keyboardType = .default
        textField.font = .systemFont(ofSize: 20, weight: .thin)
        textField.isUserInteractionEnabled = false
        textField.isHidden = true
        textField.autocorrectionType = .no
        return textField
    }()
    
    private let confirmPasswordTextField: VucciTextField = {
        let textField = VucciTextField()
        textField.placeholder = "Confirm Password"
        textField.textAlignment = .center
        textField.keyboardType = .default
        textField.font = .systemFont(ofSize: 20, weight: .thin)
        textField.isHidden = true
        textField.isUserInteractionEnabled = false
        textField.autocorrectionType = .no
        return textField
    }()
    
    private let firstNameLine: UILabel = {
        let label = UILabel()
        label.backgroundColor = .label
        label.layer.cornerRadius = 1.5
        label.clipsToBounds = true
        return label
    }()
    
    private let lastNameLine: UILabel = {
        let label = UILabel()
        label.backgroundColor = .label
        label.layer.cornerRadius = 1.5
        label.clipsToBounds = true
        return label
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
        label.isHidden = true
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private let confirmPasswordLine: UILabel = {
        let label = UILabel()
        label.backgroundColor = .label
        label.layer.cornerRadius = 1.5
        label.clipsToBounds = true
        label.isUserInteractionEnabled = false
        label.isHidden = true
        return label
    }()
    
    
    private let usernameLine: UILabel = {
        let label = UILabel()
        label.backgroundColor = .label
        label.layer.cornerRadius = 1.5
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isHidden = true
        return imageView
    }()
    
    private let selectProfilePhotoButton: UILabel = {
        let label = UILabel()
        label.text = "SELECT PHOTO"
        label.textColor = .white
        label.backgroundColor = .systemGreen
        label.layer.cornerRadius = 20
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        label.isHidden = true
        return label
    }()
    
    private var loadingViewChildVC = LoadingViewController()
    
    
    let nextButtonSize: CGFloat = 90
    let selectPhotoButtonSize: CGFloat = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "CREATE AN ACCOUNT"
        view.addSubview(scrollView)
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        usernameTextField.delegate = self
        
        addChild(loadingViewChildVC)
        view.addSubview(loadingViewChildVC.view)
        loadingViewChildVC.didMove(toParent: self)
        loadingViewChildVC.view.alpha = 0
        loadingViewChildVC.view.layer.cornerRadius = 20
        loadingViewChildVC.view.clipsToBounds = true
        loadingViewChildVC.view.backgroundColor = .label
        loadingViewChildVC.ImageView.tintColor = .systemBackground
        loadingViewChildVC.ImageView.backgroundColor = .label
        
        switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                logoImageView.image = UIImage(named: "vucciLogo")
            case .dark:
                logoImageView.image = UIImage(named: "vucciLogoDarkMode")
            @unknown default:
                logoImageView.image = UIImage(named: "vucciLogo")
        }
        
        
        let nextToStepTwoTap = UITapGestureRecognizer(target: self, action: #selector(didTapNext))
        nextToStepTwoButton.addGestureRecognizer(nextToStepTwoTap)
        
        let nextToStepThreeTap = UITapGestureRecognizer(target: self, action: #selector(didTapNext))
        nextToStepThreeButton.addGestureRecognizer(nextToStepThreeTap)
        
        let backToStepOneTap = UITapGestureRecognizer(target: self, action: #selector(didTapBack))
        backToStepOneButton.addGestureRecognizer(backToStepOneTap)
        
        let backToStepTwoTap = UITapGestureRecognizer(target: self, action: #selector(didTapBack))
        backToStepTwoButton.addGestureRecognizer(backToStepTwoTap)
        
        let selectPhotoTap = UITapGestureRecognizer(target: self, action: #selector(didTapSelectPhoto))
        selectProfilePhotoButton.addGestureRecognizer(selectPhotoTap)
        
        let reselectPhotoTap = UITapGestureRecognizer(target: self, action: #selector(didTapSelectPhoto))
        reselectButton.addGestureRecognizer(reselectPhotoTap)
        
        let createAccountTap = UITapGestureRecognizer(target: self, action: #selector(didTapCreateAccount))
        createAccountButton.addGestureRecognizer(createAccountTap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let imageViewSize: CGFloat = view.width * 0.5
        let stepLineWidth: CGFloat = ((view.width - 60)/3)
        
        scrollView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        scrollView.contentSize = CGSize(width: view.width, height: 900)
        scrollView.addSubview(logoImageView)
        scrollView.addSubview(currentStepLabel)
        scrollView.addSubview(firstNameTextField)
        scrollView.addSubview(lastNameTextField)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(usernameTextField)
        scrollView.addSubview(confirmPasswordTextField)
        scrollView.addSubview(stepOneLine)
        scrollView.addSubview(stepTwoLine)
        scrollView.addSubview(stepThreeLine)
        scrollView.addSubview(firstNameLine)
        scrollView.addSubview(lastNameLine)
        scrollView.addSubview(emailLine)
        scrollView.addSubview(passwordLine)
        scrollView.addSubview(usernameLine)
        scrollView.addSubview(confirmPasswordLine)
        scrollView.addSubview(nextToStepTwoButton)
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(selectProfilePhotoButton)
        scrollView.addSubview(backToStepOneButton)
        scrollView.addSubview(backToStepTwoButton)
        scrollView.addSubview(nextToStepThreeButton)
        scrollView.addSubview(reselectButton)
        scrollView.addSubview(createAccountButton)
        
        //step one UI
        
        logoImageView.frame = CGRect(x: (view.width - imageViewSize)/2, y: 0, width: imageViewSize, height: imageViewSize)
        currentStepLabel.frame = CGRect(x: 5, y: logoImageView.bottom + 5, width: view.width - 10, height: 20)
        stepOneLine.frame = CGRect(x: 20, y: currentStepLabel.bottom + 15, width: stepLineWidth, height: 4)
        stepTwoLine.frame = CGRect(x: stepOneLine.right + 10, y: currentStepLabel.bottom + 15, width: stepLineWidth, height: 4)
        stepThreeLine.frame = CGRect(x: stepTwoLine.right + 10, y: currentStepLabel.bottom + 15, width: stepLineWidth, height: 4)
        firstNameTextField.frame = CGRect(x: 20, y: stepOneLine.bottom + 35, width: view.width - 40, height: 30)
        firstNameLine.frame = CGRect(x: 45, y: firstNameTextField.bottom, width: view.width - 90, height: 3)
        lastNameTextField.frame = CGRect(x: 20, y: firstNameLine.bottom + 35, width: view.width - 40, height: 30)
        lastNameLine.frame = CGRect(x: 45, y: lastNameTextField.bottom, width: view.width - 90, height: 3)
        emailTextField.frame = CGRect(x: 20, y: lastNameLine.bottom + 35, width: view.width - 40, height: 30)
        emailLine.frame = CGRect(x: 45, y: emailTextField.bottom, width: view.width - 90, height: 3)
        nextToStepTwoButton.frame = CGRect(x: (view.width - nextButtonSize)/2, y: emailLine.bottom + 30, width: nextButtonSize, height: 40)
        
        //step two UI
        
        profileImageView.frame = CGRect(x: (view.width - (view.width * 0.6))/2, y: stepOneLine.bottom + 25, width: view.width * 0.6, height: view.width * 0.6)
        selectProfilePhotoButton.frame = CGRect(x: (view.width - selectPhotoButtonSize)/2  , y: stepOneLine.bottom + 50, width: selectPhotoButtonSize, height: 40)
        reselectButton.frame = CGRect(x: (view.width - 120)/2 , y: profileImageView.bottom + 20, width: 120, height: 40)
        backToStepOneButton.frame = CGRect(x: (view.width - (nextButtonSize*2) - 15)/2, y: reselectButton.bottom + 15, width: nextButtonSize, height: 40)
        nextToStepThreeButton.frame = CGRect(x: backToStepOneButton.right + 15, y: reselectButton.bottom + 15, width: nextButtonSize, height: 40)
        
        //step three UI
        
        usernameTextField.frame = CGRect(x: 20, y: stepOneLine.bottom + 35, width: view.width - 40, height: 30)
        usernameLine.frame = CGRect(x: 45, y: usernameTextField.bottom, width: view.width - 90, height: 3)
        passwordTextField.frame = CGRect(x: 20, y: firstNameLine.bottom + 35, width: view.width - 40, height: 30)
        passwordLine.frame = CGRect(x: 45, y: passwordTextField.bottom, width: view.width - 90, height: 3)
        confirmPasswordTextField.frame = CGRect(x: 20, y: passwordLine.bottom + 35, width: view.width - 40, height: 30)
        confirmPasswordLine.frame = CGRect(x: 45, y: confirmPasswordTextField.bottom, width: view.width - 90, height: 3)
        backToStepTwoButton.frame = CGRect(x: (view.width - (nextButtonSize*2) - 15)/2, y: confirmPasswordLine.bottom + 30, width: nextButtonSize, height: 40)
        createAccountButton.frame = CGRect(x: backToStepOneButton.right + 15, y: confirmPasswordLine.bottom + 30, width: nextButtonSize, height: 40)
        
        loadingViewChildVC.view.frame = CGRect(x: ((view.width - (view.width * 0.4))/2), y: (view.height - (view.width * 0.4))/2, width: (view.width * 0.4), height: (view.width * 0.4))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            textField.resignFirstResponder()
        }
        
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else if textField == confirmPasswordTextField {
            textField.resignFirstResponder()
        }
        
        
        return true
    }
    
    
    @objc func didTapCreateAccount() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        
        guard let username = usernameTextField.text?.lowercased(), !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, let firstPassword = passwordTextField.text, !firstPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, let secondPassword = confirmPasswordTextField.text, !secondPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showSignUpError(.emptyFields)
            return
        }
        
        guard isValidUsername(username) else {
            showSignUpError(.invalidUsername)
            return
        }
        
        guard firstPassword == secondPassword else {
            showSignUpError(.passwordsDoNotMatch)
            return
        }
        
        guard isValidPassword(firstPassword) else {
            showSignUpError(.passwordMissingRequirements)
            return
        }
        
        guard firstPassword.count > 8 else {
            showSignUpError(.passwordTooShort)
            return
        }
        
        self.showLoadingView()
        DatabaseManager.shared.findUserWithUsername(with: username.lowercased(), completion: {
            [weak self] user in
            if user == nil {
                
                guard let userEmail = self?.email.lowercased() else {
                    self?.showSignUpError(.signUpIssue)
                    self?.hideLoadingView()
                    return
                }
                guard let userFirstName = self?.firstName else {
                    self?.showSignUpError(.signUpIssue)
                    self?.hideLoadingView()
                    return
                }
                guard let userLastName = self?.lastName else {
                    self?.showSignUpError(.signUpIssue)
                    self?.hideLoadingView()
                    return
                }
                
                guard let image = self?.profileImageView.image else {
                    self?.showSignUpError(.noProfileImage)
                    self?.hideLoadingView()
                    return
                }
                
                let data = image.pngData()
                
                AuthenticationManager.shared.signUp(email: userEmail, userName: username.lowercased(), password: firstPassword, profilePicture: data, firstName: userFirstName, lastName: userLastName, completion: {
                    [weak self] result in
                    
                    switch result {
                        
                    case .success(_):
                        self?.hideLoadingView()
                        UserDefaults.standard.setValue(self?.email, forKey: "email")
                        UserDefaults.standard.setValue(username.lowercased(), forKey: "username")
                        UserDefaults.standard.setValue("false", forKey: "isAnArtist")
                        
                        let vc = TabBarViewController()
                        vc.modalPresentationStyle = .fullScreen
                        DispatchQueue.main.async {
                            self?.present(vc, animated: true)
                        }
                    case .failure(_):
                        self?.hideLoadingView()
                        self?.showSignUpError(.signUpIssue)
                    }
                })
                
            } else {
                self?.hideLoadingView()
                self?.showSignUpError(.usernameAlreadyInUse)
            }
        })
    }
    
    @objc func didTapNext() {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        
        if currentStep == .stepOne {
            guard let firstName = firstNameTextField.text, !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, let lastName = lastNameTextField.text, !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, let email = emailTextField.text, !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                showSignUpError(.emptyFields)
                return
            }
            
            guard isValidEmail(email) else {
                showSignUpError(.notAValidEmail)
                return
            }
            
            self.showLoadingView()
            DatabaseManager.shared.findUserWithEmail(with: email, completion: {
                [weak self] user in
                if user == nil {
                    self?.hideLoadingView()
                    self?.currentStep = .stepTwo
                    self?.firstName = firstName
                    self?.lastName = lastName
                    self?.email = email
                    
                    self?.firstNameTextField.isUserInteractionEnabled = false
                    self?.lastNameTextField.isUserInteractionEnabled = false
                    self?.emailTextField.isUserInteractionEnabled = false
                    
                    self?.animateStepTwo()
                    
                } else {
                    self?.hideLoadingView()
                    self?.showSignUpError(.emailAlreadyInUse)
                }
            })
        } else if currentStep == .stepTwo {
            self.currentStep = .stepThree
            animateStepThree()
        }
    }
    
    @objc func didTapBack() {
        if currentStep == .stepTwo {
            currentStep = .stepOne
            UIView.animate(withDuration: 0.4, animations: { [weak self] in
                self?.firstNameTextField.isHidden = false
                self?.lastNameTextField.isHidden = false
                self?.emailTextField.isHidden = false
                self?.firstNameLine.isHidden = false
                self?.lastNameLine.isHidden = false
                self?.emailLine.isHidden = false
                self?.nextToStepTwoButton.isHidden = false
                self?.selectProfilePhotoButton.isHidden = true
                self?.backToStepOneButton.isHidden = true
                self?.profileImageView.isHidden = true
                self?.reselectButton.isHidden = true
                self?.nextToStepThreeButton.isHidden = true
                
                self?.firstNameTextField.isUserInteractionEnabled = true
                self?.lastNameTextField.isUserInteractionEnabled = true
                self?.emailTextField.isUserInteractionEnabled = true
                
                self?.stepOneLine.backgroundColor = .systemGreen
                self?.stepTwoLine.backgroundColor = .label
                self?.stepThreeLine.backgroundColor = .label
                
                self?.currentStepLabel.text = "Step 1: Personal Info"
            })
        } else if currentStep == .stepThree {
            currentStep = .stepTwo
            UIView.animate(withDuration: 0.4, animations: { [weak self] in
                self?.usernameTextField.isHidden = true
                self?.usernameLine.isHidden = true
                self?.passwordTextField.isHidden = true
                self?.passwordLine.isHidden = true
                self?.confirmPasswordTextField.isHidden = true
                self?.confirmPasswordLine.isHidden = true
                self?.createAccountButton.isHidden = true
                self?.backToStepTwoButton.isHidden = true
                self?.profileImageView.isHidden = false
                self?.backToStepOneButton.isHidden = false
                self?.profileImageView.isHidden = false
                self?.reselectButton.isHidden = false
                self?.nextToStepThreeButton.isHidden = false
                
                self?.usernameTextField.isUserInteractionEnabled = false
                self?.passwordTextField.isUserInteractionEnabled = false
                self?.confirmPasswordTextField.isUserInteractionEnabled = false
                
                self?.stepOneLine.backgroundColor = .label
                self?.stepTwoLine.backgroundColor = .systemGreen
                self?.stepThreeLine.backgroundColor = .label
                
                self?.currentStepLabel.text = "Step 2: Select Profile Image"
                
            })
        }
    }
    
    
    private func animateStepTwo() {
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.firstNameTextField.isHidden = true
            self?.lastNameTextField.isHidden = true
            self?.emailTextField.isHidden = true
            self?.firstNameLine.isHidden = true
            self?.lastNameLine.isHidden = true
            self?.emailLine.isHidden = true
            self?.nextToStepTwoButton.isHidden = true
            self?.selectProfilePhotoButton.isHidden = false
            
            self?.firstNameTextField.isUserInteractionEnabled = false
            self?.lastNameTextField.isUserInteractionEnabled = false
            self?.emailTextField.isUserInteractionEnabled = false
            
            self?.stepOneLine.backgroundColor = .label
            self?.stepTwoLine.backgroundColor = .systemGreen
            self?.stepThreeLine.backgroundColor = .label
            
            self?.currentStepLabel.text = "Step 2: Select Profile Image"
        })
        
    }
    
    private func animateStepThree() {
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.profileImageView.isHidden = true
            self?.reselectButton.isHidden = true
            self?.nextToStepThreeButton.isHidden = true
            self?.backToStepOneButton.isHidden = true
            self?.backToStepTwoButton.isHidden = false
            self?.usernameTextField.isHidden = false
            self?.usernameLine.isHidden = false
            self?.passwordTextField.isHidden = false
            self?.passwordLine.isHidden = false
            self?.confirmPasswordTextField.isHidden = false
            self?.confirmPasswordLine.isHidden = false
            self?.createAccountButton.isHidden = false
            
            self?.usernameTextField.isUserInteractionEnabled = true
            self?.passwordTextField.isUserInteractionEnabled = true
            self?.confirmPasswordTextField.isUserInteractionEnabled = true
            
            self?.stepOneLine.backgroundColor = .label
            self?.stepTwoLine.backgroundColor = .label
            self?.stepThreeLine.backgroundColor = .systemGreen
            
            self?.currentStepLabel.text = "Step 3: Username & Password"
        })
    }
    
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func didTapSelectPhoto() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        DispatchQueue.main.async {
            self.profileImageView.image = image
        }
        
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.selectProfilePhotoButton.isHidden = true
            self?.profileImageView.isHidden = false
            self?.backToStepOneButton.isHidden = false
            self?.reselectButton.isHidden = false
            self?.nextToStepThreeButton.isHidden = false
            
        })
        
       
    }
}

extension SignUpViewController {
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{8,}$"
        
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
    
    func isValidUsername(_ username: String) -> Bool {
        let RegEx = "\\w{2,14}"
        let usernamePred = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return usernamePred.evaluate(with: username)
    }

    func showSignUpError(_ err: SignUpError) {
        let ac = UIAlertController(title: err.errorDescription, message: err.errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(ac, animated: true)
        }
    }
    
    
    enum SignUpError: LocalizedError {
        case emptyFields
        case passwordTooShort
        case passwordMissingRequirements
        case notAValidEmail
        case emailAlreadyInUse
        case agreeToTermsAndCond
        case passwordsDoNotMatch
        case invalidUsername
        case usernameAlreadyInUse
        case signUpIssue
        case noProfileImage
        
        var errorDescription: String? {
            switch self {
            case .emptyFields:
                return "Empty fields!"
            case .passwordTooShort:
                return "Password too short!"
            case .passwordMissingRequirements:
                return "Password is missing some requirements"
            case .notAValidEmail:
                return "Not a valid email"
            case .emailAlreadyInUse:
                return "Email is already in use"
            case .agreeToTermsAndCond:
                return "Please agree to terms and conditions"
            case .passwordsDoNotMatch:
                return "Passwords do not match"
            case .invalidUsername:
                return "Invalid username"
            case .usernameAlreadyInUse:
                return "That username is already in use"
            case .signUpIssue:
                return "An issue occured"
            case .noProfileImage:
                return "No profile image selected"
            }
        }
        
        var errorMessage: String? {
            switch self {
            
            case .emptyFields:
                return "Please fill in all fields"
            case .passwordTooShort:
                return "Password must be at least 8 characters long "
            case .passwordMissingRequirements:
                return "Password must contain one number and one uppercase letter, no special characters"
            case .notAValidEmail:
                return "please enter a valid email"
            case .emailAlreadyInUse:
                return "Please enter a new email"
            case .agreeToTermsAndCond:
                return "Please check the circle to agree to terms"
            case .passwordsDoNotMatch:
                return "Please make sure passwords match"
            case .invalidUsername:
                return "Usernames must only contain letters and numbers, or underscores, and must be between 2 and 14 characters in length"
            case .usernameAlreadyInUse:
                return "Please enter a new username"
            case .signUpIssue:
                return "Please try again later"
            case .noProfileImage:
                return "Please select a profile image"
            }
        }
    }
}

extension SignUpViewController {
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
                    self?.logoImageView.image = UIImage(named: "vucciLogo")
                
                case .dark:
                    self?.logoImageView.image = UIImage(named: "vucciLogoDarkMode")
                @unknown default:
                    self?.logoImageView.image = UIImage(named: "vucciLogo")
            }
        }
        
    }
    
}

