//
//  InfoViewController.swift
//  Controllers
//
//  Created by 강동영 on 2023/08/29.
//

import UIKit

final class InfoViewController: UIViewController {

    private let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppLogo")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
        label.text = appName
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let appVersionLabel: UILabel = {
        let label = UILabel()
        let versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
        let buildString = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0.0"
        
        label.text = "\(versionString) (\(buildString))"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initLayout()
    }
}

extension InfoViewController {
    private func initLayout() {
        view.backgroundColor = .systemBackground
        addSubViews()
        addConstraints()
        closeButton.addTarget(self, action: #selector(tappedClosedButton), for: .touchUpInside)
    }
    
    private func addSubViews() {
        [appIconImageView,
         appNameLabel,
         appVersionLabel,
         closeButton,
        ].forEach { view.addSubview($0) }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            appIconImageView.widthAnchor.constraint(equalToConstant: 150),
            appIconImageView.heightAnchor.constraint(equalToConstant: 150),
            appIconImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            appIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            appNameLabel.topAnchor.constraint(equalTo: appIconImageView.bottomAnchor, constant: 10),
            appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            appVersionLabel.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 6),
            appVersionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            closeButton.widthAnchor.constraint(equalToConstant: 50),
            closeButton.heightAnchor.constraint(equalToConstant: 50),
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    @objc
    private func tappedClosedButton() {
        self.dismiss(animated: true)
    }
}
