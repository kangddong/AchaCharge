//
//  SettingViewController.swift
//  Controllers
//
//  Created by 강동영 on 2023/08/23.
//

import UIKit

final class SettingViewController: UIViewController {
    
    private lazy var testButton: UIButton = {
        let button = UIButton()
        button.setTitle("IAP", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tappedTestButton), for: .touchUpInside)
        
        return button
    }()
    
    let storKitManager: StoreKitManager = StoreKitManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = MainTabBarController.TabType.setting.title
        print(#fileID, #function)
        view.addSubview(testButton)
        NSLayoutConstraint.activate([
            testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            testButton.widthAnchor.constraint(equalToConstant: 100),
            testButton.heightAnchor.constraint(equalToConstant: 100),
        ])
        view.backgroundColor = .systemBackground
    }
    
    @objc
    private func tappedTestButton() {
        print(#function)
        
        storKitManager.requestMonthSubscription()
    }
}
