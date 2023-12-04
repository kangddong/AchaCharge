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
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let scrollContentsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Upgrade to Pro"
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 40)
        
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Notifications can also be sent to the controller's battery information during game play"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 26)
        
        return label
    }()
    
    private lazy var monthlyButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tappedMonthlyButton), for: .touchUpInside)
        button.setTitle("Month Plan", for: .normal)
        button.tintColor = .label
        button.layer.cornerRadius = 10
        button.backgroundColor = .green
        
        return button
    }()
    
    private lazy var weeklyButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tappedWeeklyButton), for: .touchUpInside)
        button.setTitle("Week Plan", for: .normal)
        button.tintColor = .label
        button.layer.cornerRadius = 10
        button.backgroundColor = .green
        
        return button
    }()
    
    private lazy var yearlyButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tappedYearlyButton), for: .touchUpInside)
        button.setTitle("Year Plan", for: .normal)
        button.tintColor = .label
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemPink
        
        return button
    }()
    
    private lazy var termOfUseButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tappedYearlyButton), for: .touchUpInside)
        button.setTitle("termOfUse", for: .normal)
        button.tintColor = .label
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemPink
        
        return button
    }()
    
    private lazy var privacyPolicyButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tappedYearlyButton), for: .touchUpInside)
        button.setTitle("privacy Policy", for: .normal)
        button.tintColor = .label
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemPink
        
        return button
    }()
    
    private lazy var startPremiumButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tappedYearlyButton), for: .touchUpInside)
        button.setTitle("Start Premium", for: .normal)
        button.tintColor = .label
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemPink
        
        return button
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = priceInfo
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 10)
        
        return label
    }()
    
    private let storKitManager: StoreKitManager = StoreKitManager.shared
    private var priceInfo: String = "₩1,400 /주" {
        didSet {
            priceLabel.text = priceInfo
        }
    }
    
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
//        [closeButton, scrollView, titleLabel, infoLabel, monthlyButton, weeklyButton, yearlyButton, startPremiumButton, priceLabel].forEach { view.addSubview($0) }
        [scrollView, startPremiumButton, priceLabel, closeButton].forEach { view.addSubview($0) }
        scrollView.addSubview(scrollContentsView)
        [titleLabel, infoLabel, monthlyButton, weeklyButton, yearlyButton, termOfUseButton, privacyPolicyButton].forEach { scrollContentsView.addSubview($0) }
//        [titleLabel, infoLabel, termOfUseButton, privacyPolicyButton].forEach { scrollContentsView.addSubview($0) }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: scrollContentsView.safeAreaLayoutGuide.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 100),
            closeButton.heightAnchor.constraint(equalToConstant: 100),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            scrollContentsView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollContentsView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollContentsView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            scrollContentsView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollContentsView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            startPremiumButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            startPremiumButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            startPremiumButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            startPremiumButton.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        let contentViewHeight = scrollContentsView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        contentViewHeight.priority = .defaultLow
        contentViewHeight.isActive = true
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: closeButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -20),
            
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            infoLabel.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: 15),
            infoLabel.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -15),
            
            weeklyButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 50),
//            weeklyButton.heightAnchor.constraint(equalTo: scrollContentsView.heightAnchor, multiplier: 0.08),
            weeklyButton.heightAnchor.constraint(equalToConstant: 200),
            weeklyButton.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: 15),
            weeklyButton.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -15),
            weeklyButton.bottomAnchor.constraint(equalTo: monthlyButton.topAnchor, constant: -15),
            
//            monthlyButton.heightAnchor.constraint(equalTo: scrollContentsView.heightAnchor, multiplier: 0.08),
            monthlyButton.heightAnchor.constraint(equalToConstant: 200),
            monthlyButton.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: 15),
            monthlyButton.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -15),
            monthlyButton.bottomAnchor.constraint(equalTo: yearlyButton.topAnchor, constant: -15),
            
            yearlyButton.heightAnchor.constraint(equalToConstant: 200),
//            yearlyButton.heightAnchor.constraint(equalTo: scrollContentsView.heightAnchor, multiplier: 0.08),
            yearlyButton.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: 15),
            yearlyButton.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -15),
            yearlyButton.bottomAnchor.constraint(equalTo: termOfUseButton.safeAreaLayoutGuide.topAnchor, constant: -1500),
            
            termOfUseButton.heightAnchor.constraint(equalToConstant: 100),
//            termOfUseButton.topAnchor.constraint(equalTo: yearlyButton.bottomAnchor),
            termOfUseButton.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: 15),
            termOfUseButton.bottomAnchor.constraint(equalTo: scrollContentsView.bottomAnchor, constant: -15),
            
            privacyPolicyButton.heightAnchor.constraint(equalToConstant: 100),
//            privacyPolicyButton.topAnchor.constraint(equalTo: yearlyButton.bottomAnchor),
            privacyPolicyButton.leadingAnchor.constraint(equalTo: termOfUseButton.trailingAnchor, constant: 15),
            privacyPolicyButton.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -15),
            privacyPolicyButton.bottomAnchor.constraint(equalTo: scrollContentsView.safeAreaLayoutGuide.bottomAnchor, constant: -15),
        ])
        
        NSLayoutConstraint.activate([
//            startPremiumButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),
//            startPremiumButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
//            startPremiumButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
//            startPremiumButton.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -10),
            
            priceLabel.heightAnchor.constraint(equalToConstant: 20),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            priceLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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
    private func tappedYearlyButton() {
        print(#function)
        storKitManager.requestSubscription(with: .yearly)
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
