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

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
