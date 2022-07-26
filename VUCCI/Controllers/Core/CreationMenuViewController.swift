//
//  CreationMenuViewController.swift
//  VUCCI
//
//  Created by Jason bartley on 5/4/22.
//

import UIKit

class CreationMenuViewController: UIViewController {
    
    private let coloredBackground: CAGradientLayer = {
        let background = CAGradientLayer()
        background.colors = [
            UIColor.darkGray.cgColor,
            UIColor.systemGray.cgColor,
            UIColor.secondarySystemBackground.cgColor,
            UIColor.secondarySystemBackground.cgColor,
            UIColor.systemBackground.cgColor,
            UIColor.systemBackground.cgColor,
            UIColor.systemBackground.cgColor,
            UIColor.secondarySystemBackground.cgColor,
            UIColor.secondarySystemBackground.cgColor,
            UIColor.systemGray.cgColor,
            UIColor.darkGray.cgColor
        ]
        return background
    }()
    
    private let creationSymbol: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "line.3.crossed.swirl.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 130))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let musicCreationComingSoonLabel: UILabel = {
        let label = UILabel()
        label.text = "Music Creation\nComing Soon"
        label.font = .systemFont(ofSize: 29, weight: .thin)
        label.textAlignment = .center
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.layer.addSublayer(coloredBackground)
        coloredBackground.opacity = 0.30
        
        view.addSubview(musicCreationComingSoonLabel)
        view.addSubview(creationSymbol)
        
        startAnimation()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        coloredBackground.frame = view.bounds
        
        creationSymbol.frame = CGRect(x: (view.width - 160)/2, y: ((view.height - 160)/2) - 60, width: 160, height: 160)
        musicCreationComingSoonLabel.frame = CGRect(x: 10, y: creationSymbol.bottom, width: view.width - 20, height: 70)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        startAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        creationSymbol.transform = .identity
    }
    
    public func startAnimation() {
        UIView.animate(withDuration: 1.1, delay: 0, options: [.autoreverse, .curveEaseInOut, .repeat], animations: { [weak self] in
            self?.creationSymbol.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }, completion: nil)
        
    }

    

}
