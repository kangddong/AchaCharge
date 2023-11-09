//
//  IAPOnboardingViewController.swift
//  Controllers
//
//  Created by 강동영 on 2023/10/11.
//

import UIKit

final class IAPOnboardingViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tappedCloseButton), for: .touchUpInside)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.imageView?.tintColor = .label
        
        return button
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Upgrade to Pro"
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 40)
        
        return label
    }()
    
    private lazy var monthlyButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tappedMonthlyButton), for: .touchUpInside)
        button.setTitle("$4.99 / Month", for: .normal)
        button.tintColor = .label
        button.layer.cornerRadius = 10
        button.backgroundColor = .green
        
        return button
    }()
    
    private lazy var weeklyButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tappedWeeklyButton), for: .touchUpInside)
        button.setTitle("$1.99 / Week", for: .normal)
        button.tintColor = .label
        button.layer.cornerRadius = 10
        button.backgroundColor = .green
        
        return button
    }()
    
    private lazy var tryButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tappedTryButton), for: .touchUpInside)
        button.setTitle("Try it free", for: .normal)
        button.tintColor = .label
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemPink
        
        return button
    }()
    
    private let storKitManager: StoreKitManager = StoreKitManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initLayout()
        StoreObserver.shared.uiDelegate = self
    }
}

extension IAPOnboardingViewController {
    private func initLayout() {
        view.backgroundColor = .systemBackground
        addSubViews()
        addConstraints()
    }
    
    private func addSubViews() {
        [closeButton, infoLabel, monthlyButton, weeklyButton, tryButton].forEach { view.addSubview($0) }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 100),
            closeButton.heightAnchor.constraint(equalToConstant: 100),
            
            infoLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 50),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            monthlyButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),
            monthlyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            monthlyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            monthlyButton.bottomAnchor.constraint(equalTo: weeklyButton.topAnchor, constant: -15),
            
            weeklyButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),
            weeklyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            weeklyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            weeklyButton.bottomAnchor.constraint(equalTo: tryButton.topAnchor, constant: -15),
            
            tryButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),
            tryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
        ])
    }
    
    private func donePurchases() {
        let alert = UIAlertController(title: "Done".localized,
                                      message: "Purchase is completed".localized,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok!".localized, style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}

// MARK: - User Interactions
extension IAPOnboardingViewController {
    @objc
    private func tappedCloseButton() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func tappedTryButton() {
        print(#function)
    }
    
    @objc
    private func tappedMonthlyButton() {
        print(#function)
        storKitManager.requestSubscription(with: .month)
    }
    
    @objc
    private func tappedWeeklyButton() {
        print(#function)
        storKitManager.requestSubscription(with: .week)
    }
}

extension IAPOnboardingViewController: InAppPurchaseUIDelegate {
    func purchasing() {
        print(#function)
    }
    
    func deferred() {
        print(#function)
    }
    
    func failed(with error: Error?) {
        print(#function, "by delegate")
        
        let alert = UIAlertController(title: nil, message: error?.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    func purchased() {
        donePurchases()
    }
    
    func restored() {
        donePurchases()
    }
}
