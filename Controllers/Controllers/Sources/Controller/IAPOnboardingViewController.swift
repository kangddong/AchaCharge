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
        label.text = "Notifications can also be sent to the controller's battery information during game play".localized
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 26)
        
        return label
    }()
    
    private lazy var weeklyButton: ImageButton = {
        let button = ImageButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = SubscriptionType.week.rawValue
        button.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
        button.setTitle("Week Plan".localized, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBackground
        
        return button
    }()
    
    private lazy var monthlyButton: ImageButton = {
        let button = ImageButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = SubscriptionType.month.rawValue
        button.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
        button.setTitle("Month Plan".localized, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBackground
        
        return button
    }()
    
    private lazy var yearlyButton: ImageButton = {
        let button = ImageButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = SubscriptionType.yearly.rawValue
        button.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
        button.setTitle("Year Plan".localized, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBackground
        
        return button
    }()
    
    private lazy var termOfUseButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tappedTerms), for: .touchUpInside)
        button.setTitle("termOfUse".localized, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.setUnderline()
        
        return button
    }()
    
    private lazy var privacyPolicyButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tappedTerms), for: .touchUpInside)
        button.setTitle("privacy Policy".localized, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.setUnderline()
        
        return button
    }()
    
    private lazy var premiumContentsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startPremiumButton)
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var startPremiumButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tappedStartPreminumButton), for: .touchUpInside)
        button.setTitle("Start Premium".localized, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
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
    
    // MARK: - Properties
    private let storKitManager: StoreKitManager = StoreKitManager.shared
    private var priceInfo: String = "₩1,400 /주" {
        didSet {
            priceLabel.text = priceInfo
        }
    }
    
    private var subscriptionType: SubscriptionType = .week {
        didSet {
            switch subscriptionType {
            case .week:
                priceInfo = "₩1,400 /주"
            case .month:
                priceInfo = "₩4,400 /월"
            case .yearly:
                priceInfo = "₩45,000 /연"
            }
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
        [scrollView, premiumContentsView, priceLabel, closeButton].forEach { view.addSubview($0) }
        scrollView.addSubview(scrollContentsView)
        [titleLabel, infoLabel, monthlyButton, weeklyButton, yearlyButton, termOfUseButton, privacyPolicyButton].forEach { scrollContentsView.addSubview($0) }
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
            
            premiumContentsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            premiumContentsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            premiumContentsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            premiumContentsView.heightAnchor.constraint(equalToConstant: 100),
            
            startPremiumButton.topAnchor.constraint(equalTo: premiumContentsView.safeAreaLayoutGuide.topAnchor, constant: 15),
            startPremiumButton.leadingAnchor.constraint(equalTo: premiumContentsView.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            startPremiumButton.trailingAnchor.constraint(equalTo: premiumContentsView.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            startPremiumButton.bottomAnchor.constraint(equalTo: premiumContentsView.safeAreaLayoutGuide.bottomAnchor, constant: -15),
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
            weeklyButton.heightAnchor.constraint(equalToConstant: view.frame.height / 10),
            weeklyButton.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: 15),
            weeklyButton.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -15),
            weeklyButton.bottomAnchor.constraint(equalTo: monthlyButton.topAnchor, constant: -15),
            
            monthlyButton.heightAnchor.constraint(equalToConstant: view.frame.height / 10),
            monthlyButton.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: 15),
            monthlyButton.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -15),
            monthlyButton.bottomAnchor.constraint(equalTo: yearlyButton.topAnchor, constant: -15),
            
            yearlyButton.heightAnchor.constraint(equalToConstant: view.frame.height / 10),
            yearlyButton.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: 15),
            yearlyButton.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -15),
            yearlyButton.bottomAnchor.constraint(equalTo: termOfUseButton.safeAreaLayoutGuide.topAnchor, constant: -15),
            
            termOfUseButton.heightAnchor.constraint(equalTo: yearlyButton.heightAnchor, multiplier: 0.5),
            termOfUseButton.trailingAnchor.constraint(equalTo: yearlyButton.centerXAnchor, constant: -15),
            termOfUseButton.bottomAnchor.constraint(equalTo: scrollContentsView.safeAreaLayoutGuide.bottomAnchor, constant: -(premiumContentsView.frame.height + 150)),
            
            privacyPolicyButton.heightAnchor.constraint(equalTo: yearlyButton.heightAnchor, multiplier: 0.5),
            privacyPolicyButton.leadingAnchor.constraint(equalTo: yearlyButton.centerXAnchor, constant: 15),
            privacyPolicyButton.bottomAnchor.constraint(equalTo: scrollContentsView.safeAreaLayoutGuide.bottomAnchor, constant: -(premiumContentsView.frame.height + 150)),
        ])
        
        NSLayoutConstraint.activate([
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
    private func tappedButton(button: UIButton) {
        print(#function)
        guard let type = SubscriptionType(rawValue: button.tag) else { return }
        
        subscriptionType = type
        [weeklyButton, monthlyButton, yearlyButton].forEach { $0.isSelected = false }
        
        button.isSelected.toggle()
    }
    
    @objc
    private func tappedTerms(button: UIButton) {
        if button == termOfUseButton {
            let urlString = "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        } else if button == privacyPolicyButton {
            let urlString = "https://voracious-pigment-aaf.notion.site/30f23504cad7456e9472ac959c3e95b8?pvs=4"
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    @objc
    private func tappedStartPreminumButton() {
        print(#function, "subscriptionType: \(subscriptionType)")
        storKitManager.requestSubscription(with: subscriptionType)
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
