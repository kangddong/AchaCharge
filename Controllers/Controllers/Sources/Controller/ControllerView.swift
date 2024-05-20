//
//  ControllerView.swift
//  Controllers
//
//  Created by 강동영 on 5/20/24.
//

import UIKit

protocol ControllerViewDelegate: AnyObject {
    func tappedRefresh(with progresssView: CircularProgressBarView)
}

final class ControllerView: UIView {
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
        view.tag = CircularProgressBarView.identifier
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var isConnected: Bool = false {
        didSet {
            loadingView.isHidden = isConnected
            circularProgressBarView.isHidden = !isConnected
            UserDefaults.shared.setValue(isConnected, forKey: StringKey.CONTROLLER_CONNECTED)
        }
    }
    
    weak var delegate: ControllerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        addConstraints()
        setUpIndicatoreView()
        refreshButton.addTarget(self, action: #selector(tappedRefresh), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func strartIndicatoreView() {
        indicatorView.startAnimating()
    }
    
    public func stopIndicatoreView() {
        indicatorView.stopAnimating()
    }
    
    public func setController(with state: Bool) {
        isConnected = state
    }
    
    public func updateControllerInfo(with model: ControllerViewModel) {
        batteryStateLabel.text = "\(Int(model.batteryLevel * 100)) %"
        controllerVendorNameLabel.text = model.vendorName
        circularProgressBarView.progressAnimation(value: model.batteryLevel)
    }
    
    public func progressAnimation(duration: TimeInterval = 0.5, value: Float) {
        guard isConnected else { return }
        circularProgressBarView.progressAnimation(
            duration: duration,
            value: value
        )
    }
    
    public func clearText() {
        controllerVendorNameLabel.text = ""
        batteryStateLabel.text = "Not Connected..".localized
    }
    
    struct ControllerViewModel {
        let batteryLevel: Float
        let vendorName: String
    }
}

// MARK: - layout Method
extension ControllerView {
    private func addSubViews() {
        
        backgroundColor = .systemBackground
        [
            loadingView,
            gamePadImageView,
            circularProgressBarView,
            batteryStateLabel,
            controllerVendorNameLabel,
            refreshButton,
        ].forEach { addSubview($0) }
        loadingView.addSubview(indicatorView)
    }
    
    private func addConstraints() {
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            loadingView.heightAnchor.constraint(equalToConstant: 120),
            
            indicatorView.topAnchor.constraint(equalTo: loadingView.topAnchor),
            indicatorView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            indicatorView.widthAnchor.constraint(equalToConstant: 80),
            indicatorView.heightAnchor.constraint(equalToConstant: 80),
            
            circularProgressBarView.centerXAnchor.constraint(equalTo: centerXAnchor),
            circularProgressBarView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            gamePadImageView.widthAnchor.constraint(equalToConstant: 180),
            gamePadImageView.heightAnchor.constraint(equalToConstant: 130),
            gamePadImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            gamePadImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            batteryStateLabel.topAnchor.constraint(equalTo: gamePadImageView.bottomAnchor, constant: 36),
            batteryStateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            controllerVendorNameLabel.topAnchor.constraint(equalTo: batteryStateLabel.bottomAnchor, constant: 57),
            controllerVendorNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            refreshButton.topAnchor.constraint(equalTo: controllerVendorNameLabel.bottomAnchor, constant: 20),
            refreshButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    private func setUpIndicatoreView() {
        indicatorView.startAnimating()
    }
}

// MARK: - UI Gesture Method
extension ControllerView {
    @objc
    private func tappedRefresh() {
        delegate?.tappedRefresh(with: circularProgressBarView)
    }
}
