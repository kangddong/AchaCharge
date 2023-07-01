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

    @IBOutlet weak var gamePadImageView: UIImageView!
    @IBOutlet weak var batteryStateLabel: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var refreshButton: UIButton!
    
    private var circularProgressBarView: CircularProgressBarView!
    private var circularViewDuration: TimeInterval = 0.5
    
    private let manager = GameControllerManager.shared
    private let _CIRCLEARVIEW_TAG = 20230701
    
    private var isConnected: Bool = false {
        didSet {
            loadingView.isHidden = isConnected
            circularProgressBarView.isHidden = !isConnected
            UserDefaults.shared.setValue(isConnected, forKey: StringKey.CONTROLLER_CONNECTED)
        }
    }
    private var batteryInfo: (level: Float, state: Int) = (0.0, -1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.shared.setValue(false, forKey: StringKey.CONTROLLER_CONNECTED)
        
        refreshButton.addTarget(self, action: #selector(tappedRefresh), for: .touchUpInside)
        
        addCircularProgressBarView()
        setUpIndicatoreView()
        addControllerObservers()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print(#function)
        
        if isConnected {
            circularProgressBarView.progressAnimation(duration: circularViewDuration, value: batteryInfo.level)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        manager.remove(observer: self)
    }
    
    public func updateBatteryInfo() {
        guard let info = manager.getBatteryInfo() else { return }
        batteryInfo = info
        if isConnected {
            batteryStateLabel.text = "\(Int(batteryInfo.level * 100)) %"
            
            circularProgressBarView.progressAnimation(duration: circularViewDuration, value: batteryInfo.level)
            
            UserDefaults.shared.setValue(batteryInfo.level, forKey: StringKey.BATTERY_LEVEL)
        } else {
            batteryStateLabel.text = "Not Connected.."
        }
    }
    
    private func refreshBatteryInfo() {
        
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
    private func addCircularProgressBarView() {
        
        circularProgressBarView = CircularProgressBarView(frame: .zero)
        circularProgressBarView.tag = _CIRCLEARVIEW_TAG
        view.addSubview(circularProgressBarView)
        circularProgressBarView.translatesAutoresizingMaskIntoConstraints = false
        circularProgressBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        circularProgressBarView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        circularProgressBarView.isHidden = true
    }
    
    private func setUpIndicatoreView() {
     
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
    }
    
    @objc
    private func tappedRefresh() {
        circularProgressBarView.progressAnimation(duration: circularViewDuration, value: batteryInfo.level)
    }
}

