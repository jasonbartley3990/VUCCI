//
//  LoadingViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 4/30/22.
//

import UIKit

class LoadingViewController: UIViewController {
    
    public let ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName:"circle.grid.cross.fill")
        imageView.tintColor = .label
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    private let processingLabel: UILabel = {
        let label = UILabel()
        label.text = "PROCESSING"
        label.textColor = .systemBackground
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .thin)
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(ImageView)
        view.addSubview(processingLabel)
    }
    
    override func viewDidLayoutSubviews() {
        ImageView.frame = view.bounds
        processingLabel.frame = CGRect(x: 2, y: (view.height - 25)/2 , width: view.width - 4, height: 25)
    }
    
    public func startAnimation() {
        UIView.animate(withDuration: 1.1, delay: 0, options: [.autoreverse, .curveEaseInOut, .repeat], animations: { [weak self] in
            self?.ImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }, completion: nil)
        
    }
    
    public func stopAnimation() {
        DispatchQueue.main.async {
            self.ImageView.layer.removeAllAnimations()
        }
    }
    
    public func configureForProcessing() {
        DispatchQueue.main.async { [weak self] in
            self?.ImageView.isHidden = true
            self?.processingLabel.isHidden = false
        }
        
    }

}
