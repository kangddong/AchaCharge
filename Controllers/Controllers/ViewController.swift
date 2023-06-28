//
//  ViewController.swift
//  Controllers
//
//  Created by 강동영 on 2023/05/29.
//

import UIKit
import GameController
import NotificationCenter

enum BatteryState: Int {
    case unknown = -1
    case discharging = 0
    case charging = 1
    case full = 2
}

final class ViewController: UIViewController {

    @IBOutlet weak var batteryStateLabel: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var circularProgressBarView: CircularProgressBarView!
    var circularViewDuration: TimeInterval = 1
    
    let manager = GameControllerManager.shared

    private var isConnected: Bool = false
    private var batteryInfo: (level: Float, state: Int) = (0.0, -1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCircularProgressBarView()
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
        manager.add(observer: self, selector: #selector(didConnectedController))
        print(multitaskingSupported())
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        manager.remove(observer: self)
    }
    
    func multitaskingSupported() -> Bool {
            let device = UIDevice.current
            var backgroundIsSupported = false
            
            if device.responds(to: #selector(getter: UIDevice.isMultitaskingSupported)){
                backgroundIsSupported = device.isMultitaskingSupported
            }
            return backgroundIsSupported
            
            
        }
}

extension ViewController {

    private func setUpCircularProgressBarView() {
        // set view
        circularProgressBarView = CircularProgressBarView(frame: .zero)
        circularProgressBarView.center = view.center
        view.addSubview(circularProgressBarView)
    }
    
    @objc
    private func didConnectedController() {
        
        isConnected = true
        indicatorView.stopAnimating()
        manager.getControllerCount()
        updateBatteryInfo()
    }
    
    public func updateBatteryInfo() {
        guard let info = manager.getBatteryInfo() else { return }
        batteryInfo = info
        
        if batteryInfo.state != -1 {
            batteryStateLabel.text = "\(Int(batteryInfo.level * 100)) %"
            circularProgressBarView.progressAnimation(duration: circularViewDuration, value: batteryInfo.level)
            UserDefaults.shared.setValue(batteryInfo.level, forKey: "batteryLevel")
        }
    }
}

