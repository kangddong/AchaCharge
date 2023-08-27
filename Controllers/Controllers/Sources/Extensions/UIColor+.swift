//
//  UIColor+.swift
//  Controllers
//
//  Created by 강동영 on 2023/08/27.
//

import UIKit

extension UIColor {
    
    enum AssetName: String {
        case tabBarBackgroundColor
        case tabBarTintColor
    }
    
    static func color(name: AssetName) -> UIColor {
        return UIColor.init(named: name.rawValue) ?? .clear
    }
}
