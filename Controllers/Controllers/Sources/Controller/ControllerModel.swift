//
//  ControllerModel.swift
//  Controllers
//
//  Created by 강동영 on 5/10/25.
//

import SwiftUI
import ControllerKit

final class ControllerModel: ObservableObject {
    @Published var isConnected: Bool = false {
        didSet {
            UserDefaults.shared.setValue(isConnected, forKey: StringKey.CONTROLLER_CONNECTED)
        }
    }
    @Published var batteryLevel: Float = 0.0
    @Published var vendorName: String = ""
    
    private let manager = GameControllerManager.shared
    
    init() {
        UserDefaults.shared.setValue(false, forKey: StringKey.CONTROLLER_CONNECTED)
        addControllerObservers()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    public func updateControllerInfo() {
        guard let info = manager.getControlelrInfo() else {
            batteryLevel = 0.0
            return
        }
        
        NSLog("batteryLevel: \(info.batteryLevel)")
        vendorName = info.vendorName
        batteryLevel = info.batteryLevel
        UserDefaults.shared.setValue(info.batteryLevel, forKey: StringKey.BATTERY_LEVEL)
    }
}

extension ControllerModel {
    private func addControllerObservers() {
        manager.delegate = self
    }
}

// MARK: - GameControllerDelegate Method
extension ControllerModel: GameControllerDelegate {
    func didConnectedController() {
        isConnected = true
        updateControllerInfo()
    }
    
    func didDisConnectedController() {
        isConnected = false
        updateControllerInfo()
    }
}
