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
    
    public var controllers: [GCController] = []
    
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
    
    public func getControlelrInfo() -> Controller? {
        guard let controller = GCController.current else {
            return nil
        }
        
        let count = GCController.controllers().count
        let batteryLevel = controller.battery?.batteryLevel ?? 0.0
        let state = BatteryState(rawValue: controller.battery!.batteryState.rawValue) ?? .unknown
        let vendorName = controller.vendorName ?? "Game Controller"
        
        return Controller(controllerCount: count,
                          batteryLevel: batteryLevel,
                          batteryState: state,
                          vendorName: vendorName)
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

// MARK: - Private Method
extension GameControllerManager {
    
}

// MARK: - User Interaction
extension GameControllerManager {
}
struct Controller {
    let controllerCount: Int
    let batteryLevel: Float
    let batteryState: BatteryState
    let vendorName: String
}

enum BatteryState: Int {
    case unknown = -1
    case discharging = 0
    case charging = 1
    case full = 2
}
