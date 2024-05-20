//
//  ControllerViewController.swift
//  Controllers
//
//  Created by 강동영 on 2023/05/29.
//

import UIKit
import ControllerKit

final class ControllerViewController: UIViewController {
    private let controllerView: ControllerView
    private let manager = GameControllerManager.shared
    private var batteryInfo: (level: Float, state: Int) = (0.0, -1)
    
    init(naviTitle: String, view: ControllerView) {
        controllerView = view
        super.init(nibName: nil, bundle: nil)
        title = naviTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        controllerView.delegate = self
        view = controllerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addControllerObservers()
        UserDefaults.shared.setValue(false, forKey: StringKey.CONTROLLER_CONNECTED)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print(#function)
        
        controllerView.progressAnimation(value: batteryInfo.level)
    }
    
    public func updateControllerInfo() {
        NSLog("filter: \(#function)")
        guard let info = manager.getControlelrInfo() else {
            controllerView.clearText()
            return
        }
        
        NSLog("filter: info.batteryLevel")
        NSLog("filter: \(info.batteryLevel)")
        controllerView.updateControllerInfo(
            with: ControllerView.ControllerViewModel(batteryLevel: info.batteryLevel,
                                                     vendorName: info.vendorName)
        )
        UserDefaults.shared.setValue(info.batteryLevel, forKey: StringKey.BATTERY_LEVEL)
    }
    
    private func refreshBatteryInfo() {
        
    }
}

// MARK: - Controller Logic
extension ControllerViewController: ControllerViewDelegate {
    func tappedRefresh(with progresssView: CircularProgressBarView) {
        guard let info = manager.getBatteryInfo() else { return }
        progresssView.progressAnimation(value: info.level)
    }
}
extension ControllerViewController {
    private func addControllerObservers() {
        NSLog("filter: \(#function)")
        manager.delegate = self
    }
}

// MARK: - GameControllerDelegate Method
extension ControllerViewController: GameControllerDelegate {
    func didConnectedController() {
        controllerView.setController(with: true)
        controllerView.stopIndicatoreView()
        updateControllerInfo()
    }
    
    func didDisConnectedController() {
        controllerView.setController(with: false)
        controllerView.strartIndicatoreView()
        updateControllerInfo()
    }
}

