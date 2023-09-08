//
//  ViewController.swift
//  Controllers
//
//  Created by 강동영 on 2023/05/29.
//

import UIKit

final class ViewController: UIViewController {

    // MARK: - UI Properties
    private let indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .large
        view.color = .label
        view.backgroundColor = .systemBackground
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let gamePadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "gamecontroller.fill")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let batteryStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Not connected..".localized
        label.textAlignment = .center
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let controllerVendorNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let refreshButton: UIButton = {
        let button = UIButton()
        button.setTitle("Refresh".localized, for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.tintColor = .label
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var circularProgressBarView: CircularProgressBarView = {
        let view = CircularProgressBarView(frame: .zero)
        view.tag = _CIRCLEARVIEW_TAG
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var circularViewDuration: TimeInterval = 0.5
    
    // MARK: - UI Properties
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
        
        title = MainTabBarController.TabType.controlelr.title
        
        addSubViews()
        addConstraints()
        setUpIndicatoreView()
        addControllerObservers()
        
        UserDefaults.shared.setValue(false, forKey: StringKey.CONTROLLER_CONNECTED)
        refreshButton.addTarget(self, action: #selector(tappedRefresh), for: .touchUpInside)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print(#function)
        
        if isConnected {
            circularProgressBarView.progressAnimation(duration: circularViewDuration, value: batteryInfo.level)
        }
    }
    
    public func updateControllerInfo() {
        NSLog("filter: \(#function)")
        guard let info = manager.getControlelrInfo() else {
            controllerVendorNameLabel.text = ""
            batteryStateLabel.text = "Not Connected..".localized
            return
        }
        
        NSLog("filter: info.batteryLevel")
        NSLog("filter: \(info.batteryLevel)")
        batteryStateLabel.text = "\(Int(info.batteryLevel * 100)) %"
        controllerVendorNameLabel.text = info.vendorName
        circularProgressBarView.progressAnimation(duration: circularViewDuration, value: info.batteryLevel)
        
        UserDefaults.shared.setValue(info.batteryLevel, forKey: StringKey.BATTERY_LEVEL)
    }
    
    private func refreshBatteryInfo() {
        
    }
}

// MARK: - UI Methods
extension ViewController {
    private func addSubViews() {
        
        view.backgroundColor = .systemBackground
        [
            loadingView,
            gamePadImageView,
            circularProgressBarView,
            batteryStateLabel,
            controllerVendorNameLabel,
            refreshButton,
        ].forEach { view.addSubview($0) }
        loadingView.addSubview(indicatorView)
    }
    
    private func addConstraints() {
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loadingView.heightAnchor.constraint(equalToConstant: 120),
            
            indicatorView.topAnchor.constraint(equalTo: loadingView.topAnchor),
            indicatorView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            indicatorView.widthAnchor.constraint(equalToConstant: 80),
            indicatorView.heightAnchor.constraint(equalToConstant: 80),
            
            circularProgressBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circularProgressBarView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            gamePadImageView.widthAnchor.constraint(equalToConstant: 180),
            gamePadImageView.heightAnchor.constraint(equalToConstant: 130),
            gamePadImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gamePadImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            batteryStateLabel.topAnchor.constraint(equalTo: gamePadImageView.bottomAnchor, constant: 36),
            batteryStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            controllerVendorNameLabel.topAnchor.constraint(equalTo: batteryStateLabel.bottomAnchor, constant: 57),
            controllerVendorNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            refreshButton.topAnchor.constraint(equalTo: controllerVendorNameLabel.bottomAnchor, constant: 20),
            refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func setUpIndicatoreView() {
     
        indicatorView.startAnimating()
    }
}

// MARK: - Controller Logic
extension ViewController {
    private func addControllerObservers() {
        NSLog("filter: \(#function)")
        manager.delegate = self
    }
    
    @objc
    private func tappedRefresh() {
        guard let info = manager.getBatteryInfo() else { return }
        circularProgressBarView.progressAnimation(duration: circularViewDuration, value: info.level)
    }
}

// MARK: - GameControllerDelegate Method
extension ViewController: GameControllerDelegate {
    func didConnectedController() {
        isConnected = true
        indicatorView.stopAnimating()
        updateControllerInfo()
    }
    
    func didDisConnectedController() {
        isConnected = false
        indicatorView.startAnimating()
        updateControllerInfo()
    }
}

