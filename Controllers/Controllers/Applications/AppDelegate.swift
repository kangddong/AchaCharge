//
//  AppDelegate.swift
//  Controllers
//
//  Created by 강동영 on 2023/05/29.
//

import UIKit
import UserNotifications
import BackgroundTasks
import StoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let iapObserver = StoreObserver()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        requestNotificationAuthorization()
        addStoreKitQueue()
        registBackgroundTask()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        SKPaymentQueue.default().remove(iapObserver)
    }
}


// MARK: Push Notifications Method
extension AppDelegate {
    
    private func requestNotificationAuthorization() {
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            print("Permission granted: \(granted)")
        }
    }
}

// MARK: StoreKit Method
extension AppDelegate {
    
    private func addStoreKitQueue() {
        SKPaymentQueue.default().add(iapObserver)
    }
}


// MARK: BGTask Method
extension AppDelegate {
    
    private func registBackgroundTask() {
        // STEP1
        // Register for background app refresh task
        BGTaskScheduler.shared.register(forTaskWithIdentifier: StringKey.BATTERY_IDENTIFIER, using: nil) { task in
            // Perform your background fetch here
            self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
        }
    }
    
    func handleAppRefreshTask(task: BGAppRefreshTask) {
        // STEP2
        // Perform background fetch here
            
        // Be sure to call the completion handler when the task is complete
        scheduleAppRefresh()
        GameControllerManager.shared.getControllerCount()
        if GameControllerManager.shared.controllers.count > 0 {
            let info = GameControllerManager.shared.getBatteryInfo()
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "아차 충전 !"
            content.body = "level: \(info?.level), state: \(info?.state)"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            let request = UNNotificationRequest(identifier: "batterPush", content: content, trigger: trigger)
            center.add(request)
        } else {
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "아차 충전 !"
            content.body = "컨트롤러 연결 안되어있음 !"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            let request = UNNotificationRequest(identifier: "batterPush.off", content: content, trigger: trigger)
            center.add(request)
        }
        
        task.setTaskCompleted(success: true)
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
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
}
