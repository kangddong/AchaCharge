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
                return "Controlelr"
            
            case .setting:
                return "Setting"
            }
        }
        
        var deSelectedImage: UIImage {
            switch self {
            case .controlelr:
                return UIImage()
            
            case .setting:
                return UIImage()
            }
        }
        
        var selectedImage: UIImage {
            switch self {
            case .controlelr:
                return UIImage()
            
            case .setting:
                return UIImage()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
    }
}

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
