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
    public static var localReceiptData: Data? {
        return shared.appStoreReceiptData
    }
    private var refreshReceiptRequest: SKReceiptRefreshRequest = SKReceiptRefreshRequest(receiptProperties: nil)
    private var receiptRefreshRequest: InAppReceiptRefreshRequest?
    var isSubscribed: Bool {
        return UserDefaults.standard.value(forKey: StringKey.IS_SUBSCRIBED) as? Bool ?? false
    }
    
    var request: SKProductsRequest!
    var products = [SKProduct]()
    var productIDs: [String] = []
    
    var appStoreReceiptURL: URL? = Bundle.main.appStoreReceiptURL
    var appStoreReceiptData: Data? {
        guard let receiptDataURL = appStoreReceiptURL,
            let data = try? Data(contentsOf: receiptDataURL) else {
            return nil
        }
        return data
    }
    @discardableResult
    func fetchReceipt(forceRefresh: Bool, refresh: InAppReceiptRefreshRequest.ReceiptRefresh = InAppReceiptRefreshRequest.refresh, completion: @escaping (FetchReceiptResult) -> Void) -> InAppRequest? {
        if let receiptData = appStoreReceiptData, forceRefresh == false {
            completion(.success(receiptData: receiptData))
            return nil
        } else {
            
            receiptRefreshRequest = refresh(nil) { result in
                
                self.receiptRefreshRequest = nil
                
                switch result {
                case .success:
                    if let receiptData = self.appStoreReceiptData {
                        completion(.success(receiptData: receiptData))
                    } else {
                        completion(.error(error: .noReceiptData))
                    }
                case .error(let e):
                    completion(.error(error: .networkError(error: e)))
                }
            }
            return receiptRefreshRequest
        }
    }
    private var isAuthorizedForPayments: Bool {
        let result = SKPaymentQueue.canMakePayments()
        return result
    }
    
    private override init() {
        super.init()
        print(#function, "StoreKitManager")
        getProductIdentifiers()
    }
    
    public func requestSubscription(with type: SubscriptionType) {
        print("products.count: \(products.count)")
        products.forEach { print("productIdentifier: \($0.productIdentifier)") }
        guard let selectedProduct = products.filter({ $0.productIdentifier == type.identifier }).first else { return }
        guard isAuthorizedForPayments else { return }
        
        let payment = SKMutablePayment(product: selectedProduct)
        payment.quantity = 1
        // 결제 요청 제출
        SKPaymentQueue.default().add(payment)
    }
    
    func isValidateReceipts() {
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
           FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
            do {
                let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                print(receiptData)
                
                let receiptString = receiptData.base64EncodedString(options: [])
                // Read receiptData.
            }
            catch { print("Couldn't read receipt data with error: " + error.localizedDescription)
            }
        }
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
