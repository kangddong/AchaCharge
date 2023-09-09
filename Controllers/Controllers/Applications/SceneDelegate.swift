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
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        setWindow(windowScene: windowScene)
        setRootViewController(configureTabBarController())
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        isBackground = false
        
        guard let vc = UIApplication.topViewController() as? ViewController else { return }
        vc.updateControllerInfo()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

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
