//
//  ViewController.swift
//  Controllers-macOS
//
//  Created by 강동영 on 5/19/24.
//

import Cocoa
import UserNotifications

class ViewController: NSViewController {
    
    private let manager = GameControllerManager.shared
    private var isConnected = false {
        didSet {
            isConnectedLabel.stringValue = isConnected ? "Dual Sense\n, Connected" : "Dual Sense\n,DisConnected"
        }
    }
    
    @IBOutlet weak var isConnectedLabel: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
//        let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as! String
//
        let appName = "appName"
        content.title = appName
        content.sound = .default
        let level = Int(0.85 * 100)
        content.body = "Current Battery is \(level)%"
        NSLog("filter: Push 성공, 배터리 레벨 : \(level)")
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: "batterPush", content: content, trigger: trigger)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+5, execute: {
            print("push sent")
            center.add(request)
        })
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

// MARK: - GameControllerDelegate Method
extension ViewController: GameControllerDelegate {
    func didConnectedController() {
        print(#function, isConnected)
        isConnected = true
    }
    
    func didDisConnectedController() {
        print(#function, isConnected)
        isConnected = false
    }
}

