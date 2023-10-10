//
//  StoreKitManager.swift
//  Controllers
//
//  Created by 강동영 on 2023/08/27.
//

import Foundation
import StoreKit

final class StoreKitManager: NSObject {
    
    static let shared: StoreKitManager = StoreKitManager()
    
    var request: SKProductsRequest!
    var products = [SKProduct]()
    var productIDs: [String] = []
    
    private override init() {
        super.init()
        print(#function, "StoreKitManager")
        getProductIdentifiers()
        validate(productIdentifiers: productIDs)
    }
    
    public var isAuthorizedForPayments: Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func requestMonthSubscription() {
        guard let product = products.first else { return } // TODO: 에러 처리 팝업
        let payment = SKMutablePayment(product: product)
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
