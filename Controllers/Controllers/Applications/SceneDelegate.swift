//
//  SceneDelegate.swift
//  Controllers
//
//  Created by 강동영 on 2023/05/29.
//

import UIKit
import BackgroundTasks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var isBackground = false

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        setWindow(windowScene: windowScene)
        setRootViewController(configureTabBarController())
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {
        isBackground = false
        
        guard let vc = UIApplication.topViewController() as? ViewController else { return }
        vc.updateControllerInfo()
    }

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {
        let appDeleagate = UIApplication.shared.delegate as! AppDelegate
        appDeleagate.scheduleAppRefresh()
        isBackground = true
        print(#function)
    }
}

extension SceneDelegate {
    
    private func setWindow(windowScene: UIWindowScene) {
        
        window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene
    }
    
    private func setRootViewController(_ viewController: UIViewController) {
        
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
    
    private func configureTabBarController() -> UITabBarController {
        
        let tabBarController = MainTabBarController()
        let tabItem = MainTabBarController.TabType.allCases
        var viewControllers: [UIViewController] = []
        tabItem.forEach { viewControllers.append(UINavigationController(rootViewController: $0.viewController)) }
        
        tabBarController.setViewControllers(viewControllers, animated: true)
        
        
        guard tabBarController.viewControllers?.count ?? 0 > 0 else { return tabBarController }
        
        for index in 0...tabBarController.viewControllers!.count - 1 {
            if let items = tabBarController.tabBar.items {
                items[index].selectedImage = tabItem[index].selectedImage
                items[index].image = tabItem[index].deSelectedImage
                items[index].title = tabItem[index].title
            }
        }
        
        return tabBarController
    }
}
