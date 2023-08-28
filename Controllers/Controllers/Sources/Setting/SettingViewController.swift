//
//  SettingViewController.swift
//  Controllers
//
//  Created by 강동영 on 2023/08/23.
//

import UIKit

final class SettingViewController: UIViewController {
    
    enum SectionType {
        case premium
        case csInfo
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        return tableView
    }()
    
    private lazy var testButton: UIButton = {
        let button = UIButton()
        button.setTitle("IAP Test", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tappedTestButton), for: .touchUpInside)
        
        return button
    }()
    
    private let storKitManager: StoreKitManager = StoreKitManager()
    private var sectionType: [SectionType] = [.premium, .csInfo]
    private var premiumSections: [SectionType] = [.premium, .csInfo]
    private var csInfoSections: [SectionType] = [.premium, .csInfo]
    
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
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc
    private func tappedTestButton() {
        print(#function)
        
        storKitManager.requestMonthSubscription()
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate Method
extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionType.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sectionType[section] {
        case .premium:
            return premiumSections.count
        case .csInfo:
            return csInfoSections.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionType[indexPath.section] {
        case .premium:
            return UITableViewCell()
        case .csInfo:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sectionType[indexPath.section] {
        case .premium:
            break //return UITableViewCell()
        case .csInfo:
            break //return UITableViewCell()
        }
    }
    
}
