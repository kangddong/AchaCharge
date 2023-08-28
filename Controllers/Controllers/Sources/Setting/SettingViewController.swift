//
//  SettingViewController.swift
//  Controllers
//
//  Created by 강동영 on 2023/08/23.
//

import UIKit

final class SettingViewController: UIViewController {
    
    enum SectionType: Int {
        case premium = 0
        case csInfo = 1
    }
    
    enum PremiumSectionType: String {
        case premium
        case restorepurchase
    }
    
    enum CsInfoSectionType: String {
        case info
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(SettingItemCell.self, forCellReuseIdentifier: SettingItemCell.reuseIdentifier)
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = 50.0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private let storKitManager: StoreKitManager = StoreKitManager()
    
    private var sectionType: [SectionType] = [.premium, .csInfo]
    private var settingItems: [SettingItemDTO] = []
    
    private var settingItems: [SettingItemDTO] = []
    private var premiumItems: [SettingItemDTO] = []
    private var csInfoItems: [SettingItemDTO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchJSON()
        initLayout()
        configureTableView()
    }
    
    @objc
    private func tappedTestButton() {
        storKitManager.requestMonthSubscription()
    }
}

extension SettingViewController {
    private func fetchJSON() {
        var settingItemsDataDecoder = CustomJSONDecoder<[SettingItemDTO]>()
        guard let decodedItems = settingItemsDataDecoder.decode(jsonFileName: "SettingItems") else { return }
        settingItems = decodedItems
        premiumItems = settingItems.filter { $0.sectionTypeCode == 0 }
        csInfoItems = settingItems.filter { $0.sectionTypeCode == 1 }
    }
    
    private func initLayout() {
        title = MainTabBarController.TabType.setting.title
        view.backgroundColor = .systemBackground
        addSubViews()
        addConstraints()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func addSubViews() {
        view.addSubview(tableView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
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
            return premiumItems.count
        case .csInfo:
            return csInfoItems.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingItemCell.reuseIdentifier, for: indexPath)
        guard let convertedCell = cell as? SettingItemCell else { return cell }
        
        switch sectionType[indexPath.section] {
        case .premium:
            guard let item = premiumItems[safe: indexPath.row] else { return cell }
            convertedCell.setData(item)
            
            return convertedCell
            
        case .csInfo:
            guard let item = csInfoItems[safe: indexPath.row] else { return cell }
            convertedCell.setData(item)
            
            return convertedCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch sectionType[indexPath.section] {
        case .premium:
            
            guard let title = premiumItems[safe: indexPath.row]?.title else { return }
            let typeString = title.replacingOccurrences(of: " ", with: "").lowercased()
            
            guard let type = PremiumSectionType(rawValue: typeString) else { return }
            switch type {
            case .premium:
                tappedTestButton()
                print("premium tapped!")
            case .restorepurchase:
                print("restorePurchase tapped!")
            }
            
            
            
        case .csInfo:
            guard let title = csInfoItems[safe: indexPath.row]?.title else { return }
            print("item.title: \(title)")
            let typeString = title.replacingOccurrences(of: " ", with: "").lowercased()
            
            guard let type = CsInfoSectionType(rawValue: typeString) else { return }
            
            switch type {
            case .info:
                print("premium tapped!")
            }
        }
    }
    
}
