//
//  SettingsMainMenuViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 4/13/22.
//

import UIKit
import SafariServices
import StoreKit

struct settingsSection {
    let title: String
    let options : [settingOption]
}

struct settingOption {
    let title: String
    let handler: (() -> Void)
}

class SettingsMainMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var sections: [settingsSection] = []
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.sectionIndexBackgroundColor = .systemBackground
        table.backgroundColor = .systemBackground
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        return table
    }()
    
    private var footer = SettingsTableFooter()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "SETTINGS"
        view.addSubview(tableView)
        
        configureModels()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = footer
        footer.delegate = self
        
        tableView.frame = view.bounds
        footer.frame = CGRect(x: 0, y: 0, width: view.width, height: 140)
    }
    
    public func configureModels() {
        sections.append(settingsSection(title: "App", options: [settingOption(title: "Rate App") { [weak self] in
            guard let scene = self?.view.window?.windowScene else {return}
            if #available(iOS 14.0, *) {
                SKStoreReviewController.requestReview(in: scene)
            } else {
                let ac = UIAlertController(title: "Unable to bring up app review", message: "Current iOS version does not sopport this", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
                self?.present(ac, animated: true)
            }
        },
        settingOption(title: "Change Account Type", handler: { [weak self] in
            guard let isAnArtistAccount = UserDefaults.standard.string(forKey: "isAnArtist") else {
                return
            }
            if isAnArtistAccount == "true" {
                let vc = ChangeAccountTypeViewController(isAnArtist: true)
                self?.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = ChangeAccountTypeViewController(isAnArtist: false)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }),
        settingOption(title: "Change Username", handler: { [weak self] in
            let vc = ChangeUsernameViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
            
        }),
        settingOption(title: "Change Profile Photo", handler: { [weak self] in
            let vc = ChangeProfilePhotoViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        })]))
        sections.append(settingsSection(title: "Information", options: [
        settingOption(title: "Privacy Policy") { [weak self] in
            let website = "https://www.privacypolicies.com/live/bb87099e-22e4-4e64-93d7-6a655a0a0c8b"
            let result = URLOpener.shared.verifyUrl(urlString: website)
            if result == true {
                if let url = URL(string: website ) {
                    let vc = SFSafariViewController(url: url)
                    self?.present(vc, animated: true)
                }
            } else {
                let ac = UIAlertController(title: "Invalid Url", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
                self?.present(ac, animated: true)
            }
        },
        settingOption(title: "Terms and Conditions"){ [weak self] in
            let vc = TermsAndConditionsViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        },
        settingOption(title: "Report an Issue"){ [weak self] in
            let vc = ReportAnIssueViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }]))
        
    }
    
    private func didTapSignOut() {
        let actionSheet = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: {
            [weak self] _ in
            AuthenticationManager.shared.signOut {
                success in
                if success {
                    SharedSongManager.shared.stopMusic()
                    SharedSongManager.shared.currentSong = nil
                    DispatchQueue.main.async {
                        let vc = SignInViewController()
                        let navVc = UINavigationController(rootViewController: vc)
                        navVc.modalPresentationStyle = .fullScreen
                        self?.present(navVc, animated: true)
                    }
                } else {
                    print("failed to sign out")
                }
            }
        }))
        present(actionSheet, animated: true)
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        cell.textLabel?.font = .systemFont(ofSize: 19, weight: .thin)
        cell.textLabel?.textColor = .label
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }

}

extension SettingsMainMenuViewController: SettingsTableFooterDelegate {
    func SettingTableFooterDidTapSignOut() {
        didTapSignOut()
    }
    
    
}
