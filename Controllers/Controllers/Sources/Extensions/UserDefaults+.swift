//
//  UserDefaults+.swift
//  Controllers
//
//  Created by 강동영 on 2023/06/28.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        let appGroupId = "group.arex.achaCharge"
        return UserDefaults(suiteName: appGroupId)!
    }
}
