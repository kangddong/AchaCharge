//
//  ImageButton.swift
//  Controllers
//
//  Created by 강동영 on 12/7/23.
//

import UIKit

final class ImageButton: UIButton {
    typealias OnOffImage = (onImage: UIImage?, offImage: UIImage?)
    var resource: OnOffImage = (UIImage(systemName: "checkmark.circle.fill"), UIImage(systemName: "checkmark.circle"))
    
    override var isSelected: Bool {
        didSet {
            print("ImageButton.isSelected: \(isSelected)")
            layer.borderColor = isSelected ? UIColor.systemGreen.cgColor : UIColor.black.cgColor
            tintColor = isSelected ? UIColor.systemGreen : UIColor.black
        }
    }
    
    init(resource: OnOffImage) {
        super.init(frame: .zero)
        self.resource = resource
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2.0
        layer.cornerRadius = 10
        tintColor = .black
        backgroundColor = .systemBackground
        
        setImage(resource.offImage, for: .normal)
        setImage(resource.onImage, for: .selected)
    }
}
