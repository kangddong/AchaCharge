//
//  StoreObserver.swift
//  Controllers
//
//  Created by 강동영 on 2023/08/24.
//

import Foundation
import StoreKit

protocol DidResotreDelegate: AnyObject {
    func didRestored()
}

protocol InAppPurchaseUIDelegate: AnyObject {
    func purchasing()
    func deferred()
    func failed(with error: Error?)
    func purchased()
    func restored()
}

final class StoreObserver: NSObject {
    
    static let shared: StoreObserver = StoreObserver()
    
    weak var resotreDelegate: DidResotreDelegate?
    weak var uiDelegate: InAppPurchaseUIDelegate?
    // MARK: - Initializer
    private override init() {}
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    deinit {
        print("deinit StoreObserver")
    }
}

extension StoreObserver: SKPaymentTransactionObserver {
    //Observe transaction updates.
    func paymentQueue(_ queue: SKPaymentQueue,updatedTransactions transactions: [SKPaymentTransaction]) {
        //Handle transaction states here.
        for transaction in transactions {
            print(#function, "transaction: \(transaction.description)")
            switch transaction.transactionState {
            case .purchasing: print("purchasing")
                showTransactionAsInProgress(with: transaction, deferred: false)
            
            case .deferred: print("deferred")
                showTransactionAsInProgress(with: transaction, deferred: true)
            
            case .failed: print("failed")
                self.uiDelegate?.failed(with: transaction.error)
                SKPaymentQueue.default().finishTransaction(transaction)
            
            case .purchased: print("purchased")
                UserDefaults.standard.setValue(true, forKey: StringKey.IS_SUBSCRIBED)
                self.uiDelegate?.restored()
                SKPaymentQueue.default().finishTransaction(transaction)
            
            case .restored: print("restored")
                handleRestored(with: transaction)
                // For debugging purposes.
            
            @unknown default: print("Unexpected transaction state \(transaction.transactionState)")
            }
        }
    }
}

extension StoreObserver {
    private func showTransactionAsInProgress(with transaction: SKPaymentTransaction, deferred: Bool) {
        if deferred {
            self.uiDelegate?.deferred()
        } else {
            self.uiDelegate?.purchasing()
        }
    }
    
    private func handleRestored(with transaction: SKPaymentTransaction) {
        print(#function)
        UserDefaults.standard.setValue(true, forKey: StringKey.IS_SUBSCRIBED)
        
        DispatchQueue.main.async {
            self.uiDelegate?.restored()
            self.resotreDelegate?.didRestored()
        }
        // Finishes the restored transaction.
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}
