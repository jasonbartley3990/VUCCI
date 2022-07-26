//
//  ReportAnIssueViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 4/20/22.
//

import UIKit

class ReportAnIssueViewController: UIViewController, UITextViewDelegate {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.text = "Type what you have experienced."
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .thin)
        return label
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .secondarySystemBackground
        textView.textContainerInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        textView.font = .systemFont(ofSize: 18, weight: .light)
        textView.layer.borderColor = UIColor.white.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 5
        return textView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
        view.addSubview(label)
        textView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "report", style: .done, target: self, action: #selector(didTapReport))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.frame = CGRect(x: 10, y: view.safeAreaInsets.top + 20, width: view.width - 20, height: 50)
        textView.frame = CGRect(x: 20, y: label.bottom + 5, width: view.width - 40, height: 140)
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    @objc func didTapReport() {
        guard let issueText = textView.text, let email = UserDefaults.standard.string(forKey: "email"), let userId = UserDefaults.standard.string(forKey: "userId") else {
            self.showError()
            return
        }
        
        let newIssue = Issue(userEmail: email, userId: userId, issue: issueText)
        
        DatabaseManager.shared.reportAnIssue(issue: newIssue, completion: {
            [weak self] success in
            if success {
                self?.successfulUpload()
            } else {
                self?.showError()
            }
        })
    }
    
    private func showError() {
        let ac = UIAlertController(title: "Unable To Post Issue", message: "Please Try Again Later", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
        DispatchQueue.main.async { [weak self] in
            self?.present(ac, animated: true)
        }
    }
    
    private func successfulUpload() {
        let ac = UIAlertController(title: "Issue reported", message: "Thank you", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        DispatchQueue.main.async { [weak self] in
            self?.present(ac, animated: true)
        }
    }
    
}
