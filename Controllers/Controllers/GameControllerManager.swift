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
    private var controllers: [GCController] = []
    @objc dynamic var batteryObserver: GCDeviceBattery?
    public var vendorName: String? {
        return GCController.current?.vendorName
    }
    
    public func add(observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer,
                                               selector: selector,
                                               name: .GCControllerDidConnect,
                                               object: nil)
    }
    
    public func remove(observer: Any) {
        NotificationCenter.default.removeObserver(observer,
                                                  name: .GCControllerDidConnect, object: nil)
    }
    
    public func getControllerCount() {
        updateController()
        print("controllers.count = \(controllers.count)")
        print("GCController.current?.isAttachedToDevice =\(GCController.current?.isAttachedToDevice)")
        
        
        
//        if #available(iOS 14.5, *) {
//            let pad = GCDualSenseGamepad()
//            print(pad.leftTrigger)
//        } else {
//            // Fallback on earlier versions
//        }
        
    }
    
    public func getCurrentInfo() {
        
    }
    
    
    public func getBatteryInfo() -> (level: Float, state: Int)? {
        GCController.current?.battery[keyPath: \.?.batteryLevel]
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
    
    @objc
    private func updateController() {
        controllers = GCController.controllers()
    }
}
