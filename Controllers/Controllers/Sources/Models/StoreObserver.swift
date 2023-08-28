//
//  StoreObserver.swift
//  Controllers
//
//  Created by 강동영 on 2023/08/24.
//

import Foundation
import StoreKit

class StoreObserver: NSObject, SKPaymentTransactionObserver {
    
    override init() {
        super.init()
        
    }
    
    deinit {
        print("deinit StoreObserver")
    }
    
    
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
            case .restored: print("restored")
                
                // For debugging purposes.
            @unknown default: print("Unexpected transaction state \(transaction.transactionState)")
            }
        }
    }
}
