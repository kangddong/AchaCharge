//
//  MainTabBarController.swift
//  Controllers
//
//  Created by 강동영 on 2023/08/23.
//

import UIKit

class MainTabBarController: UITabBarController {

    enum TabType: CaseIterable {
        case controlelr
        case setting
        
        var viewController: UIViewController {
            switch self {
            case .controlelr:
                return ViewController()
            
            case .setting:
                return SettingViewController()
            }
        }
        
        var title: String {
            switch self {
            case .controlelr:
                return "Controller".localized
            
            case .setting:
                return "Setting".localized
            }
        }
        
        var deSelectedImage: UIImage? {
            switch self {
            case .controlelr:
                return UIImage(systemName: "gamecontroller")
            
            case .setting:
                return UIImage(systemName: "gearshape")
            }
        }
        
        var selectedImage: UIImage? {
            switch self {
            case .controlelr:
                return UIImage(systemName: "gamecontroller.fill")
            
            case .setting:
                return UIImage(systemName: "gearshape.fill")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLyaout()
        delegate = self
    }
}

extension MainTabBarController {
    
    private func initLyaout() {
        
        tabBar.layer.borderWidth = 1.0
        tabBar.layer.borderColor = UIColor.color(name: .tabBarTintColor).cgColor
        tabBar.tintColor = .label
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .color(name: .tabBarBackgroundColor)
    }
}

// MARK: - UITabBarControllerDelegate Method
extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print(#function)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, willBeginCustomizing viewControllers: [UIViewController]) {
        print(#function)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, willEndCustomizing viewControllers: [UIViewController], changed: Bool) {
        print(#function)
    }
}
