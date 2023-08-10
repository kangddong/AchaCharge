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
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        isBackground = false
        guard let vc = window?.rootViewController as? ViewController else { return }
        vc.updateBatteryInfo()
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "아차 충전 !"
        content.body = "포어그라운드 들어감"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: "enter.background", content: content, trigger: trigger)
        center.add(request)
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
        scheduleAppRefresh()
        isBackground = true
        print(#function)
    }


    // STEP3
    func scheduleAppRefresh() {
        
        //1. 원하는 형태의 TaskRequest를 만듭니다. 이 때, 사용되는 identifier는 위의 1, 2과정에서 등록한 info.plist의 identifier여야 해요!
        let request = BGAppRefreshTaskRequest(identifier: StringKey.BATTERY_IDENTIFIER)
        
        //2. 리퀘스트가 언제 실행되면 좋겠는지 지정합니다. 기존의 setMinimumFetchInterval과 동일하다고 합니다.
        //여전히, 언제 실행될지는 시스템의 마음입니다...
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        
        
        //3. 실제로 task를 submit 합니다.
        //이 때 주의사항은, submit은 synchronous한 함수라, launching 때 실행하면 메인 스레드가 블락 될 수 있으니
        //OperationQueue, GCD등을 이용해 다른 스레드에서 호출하는 것을 권장한다고 하네요.
        /*
         디버깅용도
         e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.controller.battery"]
         */
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
}

