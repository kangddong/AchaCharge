//
//  GameControllerManager.swift
//  Controllers
//
//  Created by 강동영 on 2023/05/29.
//

import Foundation
import GameController

final class GameControllerManager {
    
    private init() {}
    
    static let shared = GameControllerManager.init()
    
    public var vendorName: String? {
        return GCController.current?.vendorName
    }
    
    private var controllers: [GCController] = []
    
    public func addDidConnect(observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(
            observer,
            selector: selector,
            name: .GCControllerDidConnect,
            object: nil
        )
    }
    
    public func addDidDisconnect(observer: Any, selector: Selector) {
        
        NotificationCenter.default.addObserver(
            observer,
            selector: selector,
            name: .GCControllerDidDisconnect,
            object: nil
        )
    }
    
    public func remove(observer: Any) {
        NotificationCenter.default.removeObserver(
            observer,
            name: .GCControllerDidConnect,
            object: nil
        )
        
        NotificationCenter.default.removeObserver(
            observer,
            name: .GCControllerDidDisconnect,
            object: nil
        )
    }
    
    public func getControllerCount() {
        updateController()
    }  
    
    public func getBatteryInfo() -> (level: Float, state: Int)? {
        guard let battery = GCController.current?.battery else {
            return nil
        }
        
        print("GCController.current?.battery = \(battery)")
        print("GCDeviceBattery().batteryLevel = \(battery.batteryLevel)")
        print("GCDeviceBattery().batteryState = \(battery.batteryState)")
        
        return (battery.batteryLevel, battery.batteryState.rawValue)
    }
}

extension GameControllerManager {
    
    private func updateController() {
        controllers = GCController.controllers()
    }
}
