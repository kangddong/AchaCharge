//
//  GameControllerManager.swift
//  Controllers
//
//  Created by 강동영 on 2023/05/29.
//

import GameController

public protocol GameControllerDelegate: AnyObject {
    func didConnectedController()
    func didDisConnectedController()
}

public final class GameControllerManager {
    public static let shared: GameControllerManager = .init()
    
    public weak var delegate: GameControllerDelegate?
    
    private init() {
        addObserver()
    }
    
    public var controllers: [GCController] = []
    private var current: Controller?
    
    public func getControlelrInfo() -> Controller? {
        return current
    }
    
    public func getBatteryInfo() -> (level: Float, state: Int)? {
        guard let current = current else { return nil }
        
        print("current gamepad's batteryLevel = \(current.batteryLevel)")
        print("current gamepad's batteryState = \(current.batteryState)")
        
        return (current.batteryLevel, current.batteryState.rawValue)
    }
    
    deinit {
        removeObserver()
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
        NSLog("Connected Game Controller !!)")
        if let controller = getCurrentController() {
            NSLog("Connected Controller's count: \(controller.controllerCount)")
            NSLog("current Controller's vendorName: \(controller.vendorName)")
            NSLog("current Controller's batteryLevel: \(controller.batteryLevel * 100)%")
            NSLog("current Controller's batteryState: \(controller.batteryState), \(controller.batteryState.description)")
            current = controller
        }
        
        delegate?.didConnectedController()
    }
    
    private func getCurrentController() -> Controller? {
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
    
    @objc
    private func didDisConnectedController() {
        NSLog("Disconnected Game Controller !!)")
        delegate?.didDisConnectedController()
    }
}

// MARK: - User Interaction
extension GameControllerManager {}

public struct Controller {
    public let controllerCount: Int
    public let batteryLevel: Float
    public let batteryState: BatteryState
    public let vendorName: String
}

public enum BatteryState: Int, CustomStringConvertible {
    case unknown = -1
    case discharging = 0
    case charging = 1
    case full = 2
    
    public var description: String {
        switch self {
        case .discharging:
            "discharging"
        case .charging:
            "charging"
        case .full:
            "full"
        case .unknown:
            "unknown"
        }
    }
}
