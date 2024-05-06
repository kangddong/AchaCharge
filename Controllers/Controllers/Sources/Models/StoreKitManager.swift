//
//  StoreKitManager.swift
//  Controllers
//
//  Created by 강동영 on 2023/08/27.
//

import Foundation
import StoreKit

enum SubscriptionType: Int {
    case week = 0
    case month
    case yearly
    
    var identifier: String {
        switch self {
        case .week: "weekly"
        case .month: "monthly.10percent"
        case .yearly: "yearly.25percent"
        }
    }
}

public protocol InAppRequest: AnyObject {
    func start()
    func cancel()
}

final class StoreKitManager: NSObject {
    
    static let shared: StoreKitManager = StoreKitManager()
    var isSubscribed: Bool {
        return UserDefaults.standard.value(forKey: StringKey.IS_SUBSCRIBED) as? Bool ?? false
    }
    
    var productIDs: [String] = []

    private var isAuthorizedForPayments: Bool {
        let result = SKPaymentQueue.canMakePayments()
        return result
    }
    
    private override init() {
        super.init()
        print(#function, "StoreKitManager")
        getProductIdentifiers()
    }
}

// MARK: - StoreKit Private Method
extension StoreKitManager {
    private func getProductIdentifiers() {
        guard let url = Bundle.main.url(forResource: "ProductIDs", withExtension: "plist") else { fatalError("Unable to resolve url for in the bundle.") }
        do {
            let data = try Data(contentsOf: url)
            let productIdentifiers = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as? [String]
            print("productIdentifiers: \(productIdentifiers)")
            productIDs = productIdentifiers ?? []
        } catch let error as NSError {
            print("\(error.localizedDescription)")
        }
    }
}
