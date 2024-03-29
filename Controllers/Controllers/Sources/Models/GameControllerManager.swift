//
//  GameControllerManager.swift
//  Controllers
//
//  Created by 강동영 on 2023/05/29.
//

import Foundation
import GameController

protocol GameControllerDelegate: AnyObject {
    func didConnectedController()
    func didDisConnectedController()
}

final class GameControllerManager {
    
    private init() {
        addObserver()
    }
    
    deinit {
        removeObserver()
    }
    
    public weak var delegate: GameControllerDelegate?
    static let shared = GameControllerManager.init()
    
    public var controllers: [GCController] = []
    
    public func getControlelrInfo() -> Controller? {
        guard let controller = GCController.current else {
            return nil
        }
        
        let count = GCController.controllers().count
        let batteryLevel = controller.battery?.batteryLevel ?? 0.0
        let rawValue = (controller.battery?.batteryState ?? .unknown).rawValue
        let state = BatteryState(rawValue: rawValue)
        let vendorName = controller.vendorName ?? "Game Controller"
        
        return Controller(controllerCount: count,
                          batteryLevel: batteryLevel,
                          batteryState: state ?? .unknown,
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
    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didConnectedController),
            name: .GCControllerDidConnect,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didDisConnectedController),
            name: .GCControllerDidDisconnect,
            object: nil
        )
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: .GCControllerDidConnect,
            object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: .GCControllerDidDisconnect,
            object: nil
        )
    }
    
    @objc
    private func didConnectedController() {
        NSLog("filter: GameControllerManager")
        NSLog("filter: \(#function)")
        delegate?.didConnectedController()
    }
    
    @objc
    private func didDisConnectedController() {
        NSLog("filter: GameControllerManager")
        NSLog("filter: \(#function)")
        delegate?.didDisConnectedController()
    }
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
