//
//  StoreObserver.swift
//  Controllers
//
//  Created by 강동영 on 2023/08/24.
//

import Foundation
import StoreKit

protocol StoreObserverDelegate: AnyObject {
    func storeObserverRestoreDidSucceed()
}

final class StoreObserver: NSObject {
    
    static let shared: StoreObserver = StoreObserver()
    
    weak var delegate: StoreObserverDelegate?
    // MARK: - Initializer
    private override init() {}
    
    public func restore() {
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
            switch transaction.transactionState {
                // Call the appropriate custom method for the transaction state.
//            case .purchasing: showTransactionAsInProgress(transaction, deferred: false)
//            case .deferred: showTransactionAsInProgress(transaction, deferred: true)
//            case .failed: failedTransaction(transaction)
//            case .purchased: completeTransaction(transaction)
//            case .restored: restoreTransaction(transaction)
                
            case .purchasing: print("purchasing")
            case .deferred: print("deferred")
            case .failed: print("failed")
            case .purchased: print("purchased")
                UserDefaults.standard.setValue(true, forKey: StringKey.IS_SUBSCRIBED)
            case .restored: print("restored")
                handleRestored(with: transaction)
                // For debugging purposes.
            @unknown default: print("Unexpected transaction state \(transaction.transactionState)")
            }
        }
    }
}

extension StoreObserver {
    func handleRestored(with transaction: SKPaymentTransaction) {
        UserDefaults.standard.setValue(true, forKey: StringKey.IS_SUBSCRIBED)
        
        DispatchQueue.main.async {
            self.delegate?.storeObserverRestoreDidSucceed()
        }
        // Finishes the restored transaction.
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}
