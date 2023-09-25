//
//  FetchGameControllerOperation.swift
//  Controllers
//
//  Created by 강동영 on 2023/09/25.
//

import Foundation
import UserNotifications

class FetchGameControllerOperation: Operation {
    private let manager: GameControllerManager
    
    init(manager: GameControllerManager) {
        self.manager = manager
    }
    
    override func main() {
        guard
            let info = manager.getControlelrInfo(),
            info.controllerCount > 0
        else { return }
        
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as! String
        content.title = appName.localized
        let level = Int(info.batteryLevel * 100)
        content.body = "현재 배터리가 \(level)% 입니다 !"
        NSLog("filter: Push 성공, 배터리 레벨 : \(level)")
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: "batterPush", content: content, trigger: trigger)
        center.add(request)
    }
}
