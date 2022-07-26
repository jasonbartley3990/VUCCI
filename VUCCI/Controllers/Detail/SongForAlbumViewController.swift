//
//  SongForAlbumViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 5/16/22.
//

import UIKit
import MediaPlayer

protocol SongForAlbumViewControllerDelegate: AnyObject {
    func SongForAlbumViewControllerDidTapSave(index: Int, newSong: NewSongViewModel)
}

class SongForAlbumViewController: UIViewController, UITextFieldDelegate {
    
    public weak var delegate: SongForAlbumViewControllerDelegate?
    
    public var index: Int = 0
    
    public var image: UIImage?
    
    private var songData: Data?
    
    private var songLengthString: String = ""
    
    private var songLength: Double = 0.0
    
    private let newSongLabel: UILabel = {
        let label = UILabel()
        label.text = "1.Name Of Song"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .thin)
        label.textColor = .label
        return label
    }()
    
    
    public let newSongNameTextField: VucciTextField = {
        let textField = VucciTextField()
        textField.placeholder = "Song Name"
        textField.isUserInteractionEnabled = true
        textField.textAlignment = .center
        textField.keyboardType = .default
        textField.font = .systemFont(ofSize: 30, weight: .thin)
        return textField
    }()
    
    private let line: UILabel = {
        let label = UILabel()
        label.backgroundColor = .label
        label.layer.cornerRadius = 1.5
        label.clipsToBounds = true
        return label
    }()
    
    
    private let selectSongLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "2.SELECT SONG FOR UPLOAD"
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .thin)
        return label
    }()
    
    private let selectSongButton: UILabel = {
        let label = UILabel()
        label.text = "SELECT SONG"
        label.textColor = .white
        label.backgroundColor = .systemGreen
        label.layer.cornerRadius = 20
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let songSuccessfullyChoosenImage: UIButton = {
        let button = UIButton()
        button.tintColor = .systemGreen
        let image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))
        button.setImage(image, for: .normal)
        button.isHidden = true
        return button
    }()
    
    private let songSuccessfullyChoosenLabel: UILabel = {
        let label = UILabel()
        label.text = "Audio File Uploaded"
        label.font = .systemFont(ofSize: 20, weight: .thin)
        label.textAlignment = .left
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private let songDuration: UILabel = {
        let label = UILabel()
        label.text = "Song Duration"
        label.font = .systemFont(ofSize: 16, weight: .thin)
        label.textAlignment = .center
        label.textColor = .label
        label.isHidden = true
        return label
    }()
    
    private let saveButton: UILabel = {
        let label = UILabel()
        label.text = "SAVE"
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
    
    private let loadingViewChildVC = LoadingViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(newSongLabel)
        view.addSubview(line)
        view.addSubview(newSongNameTextField)
        view.addSubview(selectSongLabel)
        view.addSubview(selectSongButton)
        view.addSubview(songSuccessfullyChoosenImage)
        view.addSubview(songSuccessfullyChoosenLabel)
        view.addSubview(songDuration)
        view.addSubview(saveButton)
        
        newSongNameTextField.delegate = self
        
        let selectSongTap = UITapGestureRecognizer(target: self, action: #selector(didTapSelectSong))
        selectSongButton.addGestureRecognizer(selectSongTap)
        
        let saveSongTap = UITapGestureRecognizer(target: self, action: #selector(didTapSaveSong))
        saveButton.addGestureRecognizer(saveSongTap)
        
        addChild(loadingViewChildVC)
        view.addSubview(loadingViewChildVC.view)
        loadingViewChildVC.didMove(toParent: self)
        loadingViewChildVC.view.alpha = 0
        loadingViewChildVC.view.layer.cornerRadius = 20
        loadingViewChildVC.view.clipsToBounds = true
        loadingViewChildVC.view.backgroundColor = .label
        loadingViewChildVC.ImageView.tintColor = .systemBackground
        loadingViewChildVC.ImageView.backgroundColor = .label
        loadingViewChildVC.configureForProcessing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        newSongLabel.frame = CGRect(x: 10, y: view.safeAreaInsets.top + 15, width: view.width - 20, height: 30)
        newSongNameTextField.frame = CGRect(x: 20, y: newSongLabel.bottom + 35, width: view.width - 40, height: 30)
        line.frame = CGRect(x: 45, y: newSongNameTextField.bottom, width: view.width - 90, height: 3)
        
        selectSongLabel.frame = CGRect(x: 10, y: line.bottom + 80, width: view.width - 10, height: 30)
        selectSongButton.frame = CGRect(x: (view.width - 135)/2, y: selectSongLabel.bottom + 20, width: 135, height: 40)
        songSuccessfullyChoosenImage.frame = CGRect(x: (view.width - 40 - 170)/2, y: selectSongLabel.bottom + 15, width: 40, height: 40)
        songDuration.frame = CGRect(x: 10, y: songSuccessfullyChoosenImage.bottom + 4, width: view.width - 20, height: 25)
        saveButton.frame = CGRect(x: (view.width - 100)/2 , y: songDuration.bottom + 15, width: 100, height: 40)
        
        songSuccessfullyChoosenLabel.centerYAnchor.constraint(equalTo: songSuccessfullyChoosenImage.centerYAnchor, constant: 0).isActive = true
        songSuccessfullyChoosenLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        songSuccessfullyChoosenLabel.widthAnchor.constraint(equalToConstant: 170).isActive = true
        songSuccessfullyChoosenLabel.leftAnchor.constraint(equalTo: songSuccessfullyChoosenImage.rightAnchor).isActive = true
        
        loadingViewChildVC.view.frame = CGRect(x: ((view.width - (view.width * 0.4))/2), y: (view.height - (view.width * 0.4))/2, width: (view.width * 0.4), height: (view.width * 0.4))
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newSongNameTextField.resignFirstResponder()
        return true
    }
    
    @objc func didTapSelectSong() {
        let picker = MPMediaPickerController(mediaTypes: .anyAudio)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func didTapSaveSong() {
        guard let contentName = newSongNameTextField.text else {
            showUploadError(.databaseError)
            return
        }
        
        guard let audio = songData else {
            showUploadError(.databaseError)
            return
        }
        
        guard let image = self.image else {
            showUploadError(.databaseError)
            return
        }
        
        let uniqueSongId = UUID().uuidString
        let newSong = NewSongViewModel(name: contentName, audioData: audio, songDuration: self.songLength, coverImage: image,songId: uniqueSongId)
        
        delegate?.SongForAlbumViewControllerDidTapSave(index: self.index, newSong: newSong)
        
        DispatchQueue.main.async {
            
            self.newSongNameTextField.text = ""
            self.songLength = 0.0
            
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.songSuccessfullyChoosenImage.isHidden = true
                self?.songSuccessfullyChoosenLabel.isHidden = true
                self?.selectSongButton.isHidden = false
                self?.saveButton.isHidden = true
                self?.songDuration.isHidden = true
            })
        }
    }
}

extension SongForAlbumViewController: MPMediaPickerControllerDelegate {
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true)
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        showLoadingView()
        
        guard let assetUrl = mediaItemCollection.items.first?.assetURL else {
            hideLoadingView()
            return
        }
        
        guard let audioLength: Double = mediaItemCollection.items.first?.playbackDuration else  {
            hideLoadingView()
            showUploadError(.corruptSoundFile)
            return
        }
        
        guard audioLength < 3600 else {
            hideLoadingView()
            showUploadError(.audioFileToLarge)
            return
        }
        
        self.songLength = audioLength
        
        UrlExporter.shared.export(assetUrl, completionHandler: {
            [weak self] url, error in
            guard let newUrl = url else {
                self?.hideLoadingView()
                return
            }
            
            do {
                let audioData = try Data(contentsOf: newUrl)
                self?.songData = audioData
                self?.audioFileChoosen()
                self?.hideLoadingView()
                
            } catch {
                self?.hideLoadingView()
                self?.showUploadError(.corruptSoundFile)
            }
            
        })
        
        
        mediaPicker.dismiss(animated: true)
    }
    
    private func audioFileChoosen() {
       
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.newSongNameTextField.resignFirstResponder()
                self?.songSuccessfullyChoosenImage.isHidden = false
                self?.songSuccessfullyChoosenLabel.isHidden = false
                self?.selectSongButton.isHidden = true
                self?.saveButton.isHidden = false
                self?.songDuration.isHidden = false
                
            })
            
            let time = self.songLength.timeInString()
            self.songLengthString = time
            self.songDuration.text = "Song Duration: \(time)"
        }
    }
}

extension SongForAlbumViewController {
    
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
    
    func showUploadError(_ err: uploadError) {
        let ac = UIAlertController(title: err.errorDescription, message: err.errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(ac, animated: true)
        }
    }
    
    enum uploadError: LocalizedError {
        case corruptSoundFile
        case databaseError
        case audioFileToLarge
        
        var errorDescription: String? {
            switch self {
            case .corruptSoundFile:
                return "Problems reading audio file"
            case .databaseError:
                return "An error occured uploading content"
            case .audioFileToLarge:
                return "Audio file to large"
            }
        }
        
        var errorMessage: String? {
            switch self {
            
            case .corruptSoundFile:
                return "Please try again or select a different audio file"
            case .databaseError:
                return "Please try again later"
            case .audioFileToLarge:
                return "please select an song less than an hour"
            }
        }
    }
    
}
