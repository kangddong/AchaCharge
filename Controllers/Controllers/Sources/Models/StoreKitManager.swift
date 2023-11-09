//
//  StoreKitManager.swift
//  Controllers
//
//  Created by 강동영 on 2023/08/27.
//

import Foundation
import StoreKit

enum SubscriptionType: String {
    case week = "weekly"
    case month = "monthly.10percent"
    case yearly = "yearly.25percent"
}

final class StoreKitManager: NSObject {
    
    static let shared: StoreKitManager = StoreKitManager()
    
    var request: SKProductsRequest!
    var products = [SKProduct]()
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
    
    public func getProduct() {
        let product = products.first
        product?.price
    }
    
    public func requestSubscription(with type: SubscriptionType) {
        print("products.count: \(products.count)")
        products.forEach { print("productIdentifier: \($0.productIdentifier)") }
        guard let selectedProduct = products.filter({ $0.productIdentifier == type.rawValue }).first else { return }
        guard isAuthorizedForPayments else { return }
        
        let payment = SKMutablePayment(product: selectedProduct)
        payment.quantity = 1
        // 결제 요청 제출
        SKPaymentQueue.default().add(payment)
    }
}

extension StoreKitManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print(#function)
        if !response.products.isEmpty {
            products = response.products
            // Implement your custom method here.
            displayStore(products)
        }
        
        
        for invalidIdentifier in response.invalidProductIdentifiers {
            // Handle any invalid product identifiers as appropriate.
            print("invalidIdentifier: \(invalidIdentifier)")
        }
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
            validate(productIdentifiers: productIDs)
        } catch let error as NSError {
            print("\(error.localizedDescription)")
        }
    }
    
    private func validate(productIdentifiers: [String]) {
        print(#function)
        let productIdentifiers = Set(productIdentifiers)
        
        request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
    }
    
    private func displayStore(_ products: [SKProduct]) {
        print(#function)
        print("products: \(products)")
        self.products = products
    }
}
