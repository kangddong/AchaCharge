//
//  AppDelegate.swift
//  Controllers-macOS
//
//  Created by 강동영 on 5/19/24.
//

import Cocoa
import UserNotifications

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    private lazy var statusItem: NSStatusItem = {
        return NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    }()

    private let menu = NSMenu()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        requestNotificationAuthorization()
        setupStatusItem()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}

// MARK: - Private Method
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
    
    private func setupStatusItem() {
        statusItem.button?.imagePosition = .imageTrailing
        statusItem.button?.image = NSImage(systemSymbolName: "gamecontroller", accessibilityDescription: nil)
        
        if #available(macOS 10.15, *) {
            let font = NSFont.monospacedSystemFont(ofSize: 11, weight: .regular)
            statusItem.button?.font = font
        } else {
            let font = NSFont.monospacedDigitSystemFont(ofSize: 11, weight: .regular)
            statusItem.button?.font = font
        }
        
        let menuItem1 = NSMenuItem(title: "카카오톡 열기", action: #selector(toggleShowUsage(_:)), keyEquivalent: "s")
        let menuItem2 = NSMenuItem(title: "모두 읽음 처리", action: #selector(toggleShowUsage(_:)), keyEquivalent: "S")
        let menuItem3 = NSMenuItem(title: "잠금모드", action: #selector(toggleShowUsage(_:)), keyEquivalent: "")
        let menuItem4 = NSMenuItem(title: "로그아웃", action: #selector(toggleShowUsage(_:)), keyEquivalent: "")
        let menuItem5 = NSMenuItem(title: "종료", action: #selector(toggleShowUsage(_:)), keyEquivalent: "")
        menu.addItem(menuItem1)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(menuItem2)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(menuItem3)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(menuItem4)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(menuItem5)
//        menu.addItem(withTitle: "Show CPU Usage",
//                     action: #selector(toggleShowUsage(_:)),
//                     keyEquivalent: "")
//        menu.addItem(NSMenuItem.separator())
//        menu.addItem(withTitle: "About Menubar RunCat",
//                     action: #selector(toggleShowUsage(_:)),
//                     keyEquivalent: "")
//        menu.addItem(withTitle: "Quit Menubar RunCat",
//                     action: #selector(toggleShowUsage(_:)),
//                     keyEquivalent: "")
        statusItem.menu = menu
    }
    
    @objc func toggleShowUsage(_ sender: NSMenuItem) {
        print(#function)
    }
}
