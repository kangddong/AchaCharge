//
//  ViewController.swift
//  Controllers
//
//  Created by 강동영 on 2023/05/29.
//

import UIKit

enum BatteryState: Int {
    case unknown = -1
    case discharging = 0
    case charging = 1
    case full = 2
}

final class ViewController: UIViewController {

    @IBOutlet weak var batteryStateLabel: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    
    private var circularProgressBarView: CircularProgressBarView!
    private var circularViewDuration: TimeInterval = 1
    
    private let manager = GameControllerManager.shared

    private var isConnected: Bool = false {
        didSet {
            loadingView.isHidden = isConnected
            UserDefaults.shared.setValue(isConnected, forKey: StringKey.CONTROLLER_CONNECTED)
        }
    }
    private var batteryInfo: (level: Float, state: Int) = (0.0, -1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.shared.setValue(false, forKey: StringKey.CONTROLLER_CONNECTED)
        setUpIndicatoreView()
        addControllerObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        manager.remove(observer: self)
    }
    
    public func updateBatteryInfo() {
        guard let info = manager.getBatteryInfo() else { return }
        batteryInfo = info
        
        if batteryInfo.state != -1 {
            batteryStateLabel.text = "\(Int(batteryInfo.level * 100)) %"
            setUpCircularProgressBarView()
            
            UserDefaults.shared.setValue(batteryInfo.level, forKey: StringKey.BATTERY_LEVEL)
        } else {
            batteryStateLabel.text = "Not Connected.."
            circularProgressBarView.removeFromSuperview()
        }
    }
}

extension ViewController {

    private func addControllerObservers() {
        
        manager.addDidConnect(
            observer: self,
            selector: #selector(didConnectedController)
        )
        
        manager.addDidDisconnect(
            observer: self,
            selector: #selector(didDisConnectedController)
        )
    }
    
    @objc
    private func didConnectedController() {
        
        isConnected = true
        indicatorView.stopAnimating()
        manager.getControllerCount()
        updateBatteryInfo()
    }
    
    @objc
    private func didDisConnectedController() {
        
        isConnected = false
        indicatorView.startAnimating()
        manager.getControllerCount()
        updateBatteryInfo()
    }
    
    private func setUpCircularProgressBarView() {
        // set view
        circularProgressBarView = CircularProgressBarView(frame: .zero)
        circularProgressBarView.center = view.center
        circularProgressBarView.progressAnimation(duration: circularViewDuration, value: batteryInfo.level)
        
        view.addSubview(circularProgressBarView)
    }
    
    private func setUpIndicatoreView() {
     
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
    }
}

