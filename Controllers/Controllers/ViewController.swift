//
//  ViewController.swift
//  Controllers
//
//  Created by 강동영 on 2023/05/29.
//

import UIKit
import GameController

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
    var circularViewDuration: TimeInterval = 2
    
    let manager = GameControllerManager.shared
    private var didConnected: Bool = false {
        didSet {
            indicatorView.stopAnimating()
            manager.getControllerCount()
            updateBatteryInfo(manager.getBatteryInfo())
        }
    }
    
    private var batteryInfo: (level: Float, state: Int) = (0.0, -1) {
        didSet {
            if batteryInfo.state != -1 {
                batteryStateLabel.text = "\(Int(batteryInfo.level * 100)) %"
                circularProgressBarView.progressAnimation(duration: circularViewDuration)
            }
            
        }
    }
    
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
        // align to the center of the screen
        circularProgressBarView.center = view.center
        // call the animation with circularViewDuration
//        circularProgressBarView.progressAnimation(duration: circularViewDuration)
        // add this view to the view controller
        view.addSubview(circularProgressBarView)
    }
    
    @objc
    private func didConnectedController() {
        didConnected = true
    }
    
    private func updateBatteryInfo(_ info :(level: Float, state: Int)?) {
        guard let info = info else { return }
        batteryInfo = info
        
    }
}

